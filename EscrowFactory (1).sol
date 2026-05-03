// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title EscrowFactory
 * @notice Deploy this contract ONCE. Sellers create individual Deal structs
 *         directly on this factory — no re-deployment needed per transaction.
 *
 * ─── Flow ──────────────────────────────────────────────────────────────────────
 *
 *  1. SELLER calls createDeal(imageHash, priceWei, buyerAddress)
 *     → Deal is created in AWAITING_DECISION state.
 *
 *  2. BUYER calls acceptDeal(dealId) with msg.value == deal.price
 *     → ETH is locked inside the contract.
 *     → Deal moves to FUNDED.
 *     → Seller's claimable balance is credited immediately.
 *
 *     OR BUYER calls rejectDeal(dealId)
 *     → Deal moves to REJECTED. No funds move. Deal is over.
 *
 *  3. SELLER calls withdrawSeller() at any time after a deal is funded.
 *     → All accumulated earnings are pushed to the seller in one call.
 *
 *  4. If the seller wants to cancel before the buyer decides, seller calls
 *     cancelDeal(dealId) → Deal moves to CANCELLED.
 *
 * ─── Why pull-payment? ─────────────────────────────────────────────────────────
 *  The old "push on accept" pattern calls an external address mid-transaction.
 *  If that call fails for ANY reason (gas, reverting fallback, etc.) the whole
 *  acceptDeal reverts and the buyer's ETH bounces back — no deal, bad UX.
 *
 *  Pull-payment separates concerns:
 *    • acceptDeal     → only state + accounting  (safe, predictable, no external call)
 *    • withdrawSeller → one external call, isolated and retryable by the seller
 *
 *  ETH sitting in the contract is INTENTIONAL — it is claimable earnings waiting
 *  for the seller to call withdraw. It is NOT stuck.
 */
contract EscrowFactory {

    // ─── State Enum ────────────────────────────────────────────────────────────

    enum DealState {
        AWAITING_DECISION,  // Seller created deal, buyer has not acted yet
        FUNDED,             // Buyer accepted and paid — funds claimable by seller
        REJECTED,           // Buyer explicitly rejected the price
        CANCELLED           // Seller cancelled before buyer decided
    }

    // ─── Deal Struct ───────────────────────────────────────────────────────────

    struct Deal {
        address payable seller;
        address         buyer;
        uint256         price;       // in wei
        bytes32         imageHash;   // keccak256(imageBytes) — off-chain proof
        DealState       state;
        uint256         createdAt;
    }

    // ─── Storage ───────────────────────────────────────────────────────────────

    uint256 public dealCount;
    mapping(uint256 => Deal)    public deals;

    /// @notice Claimable ETH per seller address. Credited on acceptDeal.
    mapping(address => uint256) public pendingWithdrawals;

    // ─── Events ────────────────────────────────────────────────────────────────

    event DealCreated(
        uint256 indexed dealId,
        address indexed seller,
        address indexed buyer,
        uint256 price,
        bytes32 imageHash
    );
    event DealFunded(uint256 indexed dealId, address indexed buyer, uint256 price);
    event DealRejected(uint256 indexed dealId, address indexed buyer);
    event DealCancelled(uint256 indexed dealId, address indexed seller);
    event SellerWithdrew(address indexed seller, uint256 amount);

    // ─── Modifiers ─────────────────────────────────────────────────────────────

    modifier onlySeller(uint256 dealId) {
        require(msg.sender == deals[dealId].seller, "EscrowFactory: not the seller");
        _;
    }

    modifier onlyBuyer(uint256 dealId) {
        require(msg.sender == deals[dealId].buyer, "EscrowFactory: not the buyer");
        _;
    }

    modifier inState(uint256 dealId, DealState expected) {
        require(
            deals[dealId].state == expected,
            "EscrowFactory: invalid state for this action"
        );
        _;
    }

    // ─── Seller Actions ────────────────────────────────────────────────────────

    /**
     * @notice Seller creates a new deal.
     * @param imageHash  keccak256 hash of the image bytes (computed off-chain).
     * @param priceWei   Asking price in wei.
     * @param buyerAddr  Address of the buyer this deal is intended for.
     * @return dealId    The ID of the newly created deal.
     */
    function createDeal(
        bytes32 imageHash,
        uint256 priceWei,
        address buyerAddr
    ) external returns (uint256 dealId) {
        require(priceWei > 0,            "EscrowFactory: price must be > 0");
        require(buyerAddr != address(0), "EscrowFactory: invalid buyer address");
        require(buyerAddr != msg.sender, "EscrowFactory: buyer cannot be seller");
        require(imageHash != bytes32(0), "EscrowFactory: image hash required");

        dealId = dealCount++;

        deals[dealId] = Deal({
            seller:    payable(msg.sender),
            buyer:     buyerAddr,
            price:     priceWei,
            imageHash: imageHash,
            state:     DealState.AWAITING_DECISION,
            createdAt: block.timestamp
        });

        emit DealCreated(dealId, msg.sender, buyerAddr, priceWei, imageHash);
    }

    /**
     * @notice Seller cancels a deal that hasn't been accepted/rejected yet.
     */
    function cancelDeal(uint256 dealId)
        external
        onlySeller(dealId)
        inState(dealId, DealState.AWAITING_DECISION)
    {
        deals[dealId].state = DealState.CANCELLED;
        emit DealCancelled(dealId, msg.sender);
    }

    /**
     * @notice Seller withdraws ALL accumulated earnings in a single call.
     *
     *         Uses strict Checks-Effects-Interactions:
     *           1. Check   — balance must be > 0
     *           2. Effect  — zero the balance BEFORE the transfer (reentrancy-safe)
     *           3. Interact— transfer ETH to the caller
     */
    function withdrawSeller() external {
        uint256 amount = pendingWithdrawals[msg.sender];
        require(amount > 0, "EscrowFactory: nothing to withdraw");

        // Zero BEFORE the external call — reentrancy guard
        pendingWithdrawals[msg.sender] = 0;

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "EscrowFactory: ETH transfer to seller failed");

        emit SellerWithdrew(msg.sender, amount);
    }

    // ─── Buyer Actions ─────────────────────────────────────────────────────────

    /**
     * @notice Buyer accepts the deal and locks payment in the contract.
     *         msg.value MUST equal deal.price exactly.
     *
     *         ETH is credited to pendingWithdrawals[seller] — no external call
     *         happens here. The seller calls withdrawSeller() to receive funds.
     */
    function acceptDeal(uint256 dealId)
        external
        payable
        onlyBuyer(dealId)
        inState(dealId, DealState.AWAITING_DECISION)
    {
        Deal storage deal = deals[dealId];
        require(msg.value == deal.price, "EscrowFactory: msg.value must equal asking price");

        deal.state = DealState.FUNDED;
        pendingWithdrawals[deal.seller] += msg.value;

        emit DealFunded(dealId, msg.sender, msg.value);
    }

    /**
     * @notice Buyer rejects the price. No funds are sent.
     *         The deal is permanently terminated.
     */
    function rejectDeal(uint256 dealId)
        external
        onlyBuyer(dealId)
        inState(dealId, DealState.AWAITING_DECISION)
    {
        deals[dealId].state = DealState.REJECTED;
        emit DealRejected(dealId, msg.sender);
    }

    // ─── View Functions ────────────────────────────────────────────────────────

    /**
     * @notice Returns full details for a deal.
     */
    function getDeal(uint256 dealId)
        external
        view
        returns (
            address seller,
            address buyer,
            uint256 price,
            bytes32 imageHash,
            DealState state,
            uint256 createdAt
        )
    {
        Deal storage d = deals[dealId];
        return (d.seller, d.buyer, d.price, d.imageHash, d.state, d.createdAt);
    }

    /**
     * @notice Human-readable state label.
     */
    function getStateLabel(uint256 dealId) external view returns (string memory) {
        DealState s = deals[dealId].state;
        if (s == DealState.AWAITING_DECISION) return "AWAITING_DECISION";
        if (s == DealState.FUNDED)            return "FUNDED";
        if (s == DealState.REJECTED)          return "REJECTED";
        if (s == DealState.CANCELLED)         return "CANCELLED";
        return "UNKNOWN";
    }

    /**
     * @notice Returns all deal IDs where the given address is the seller.
     */
    function getDealsAsSeller(address seller)
        external
        view
        returns (uint256[] memory)
    {
        uint256 count = 0;
        for (uint256 i = 0; i < dealCount; i++) {
            if (deals[i].seller == seller) count++;
        }
        uint256[] memory result = new uint256[](count);
        uint256 idx = 0;
        for (uint256 i = 0; i < dealCount; i++) {
            if (deals[i].seller == seller) result[idx++] = i;
        }
        return result;
    }

    /**
     * @notice Returns all deal IDs where the given address is the buyer.
     */
    function getDealsAsBuyer(address buyer)
        external
        view
        returns (uint256[] memory)
    {
        uint256 count = 0;
        for (uint256 i = 0; i < dealCount; i++) {
            if (deals[i].buyer == buyer) count++;
        }
        uint256[] memory result = new uint256[](count);
        uint256 idx = 0;
        for (uint256 i = 0; i < dealCount; i++) {
            if (deals[i].buyer == buyer) result[idx++] = i;
        }
        return result;
    }

    // ─── Safety ────────────────────────────────────────────────────────────────

    /// @dev Only acceptDeal may send ETH in. Reject any direct/accidental transfers.
    receive() external payable { revert("EscrowFactory: use acceptDeal to send ETH"); }
    fallback() external payable { revert("EscrowFactory: unknown function"); }
}
