// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title EscrowFactory
 * @notice Deploy this contract ONCE. Sellers then create individual Deal structs
 *         directly on this factory — no re-deployment needed for new transactions.
 *
 * ─── Flow ──────────────────────────────────────────────────────────────────────
 *
 *  1. SELLER calls createDeal(imageHash, priceWei, buyerAddress)
 *     • imageHash  – keccak256 of the image (proof of content, stored off-chain)
 *     • priceWei   – seller's asking price in wei
 *     • buyer      – wallet address of the intended buyer
 *     → Deal is created in AWAITING_DECISION state.
 *
 *  2. BUYER calls acceptDeal(dealId) with msg.value == deal.price
 *     → Funds lock in the contract. Deal moves to FUNDED.
 *     → Funds are immediately forwarded to seller (instant release on acceptance).
 *
 *     OR BUYER calls rejectDeal(dealId)
 *     → Deal moves to REJECTED. No funds move. Deal is over.
 *
 *  3. If the seller wants to cancel before the buyer decides, seller calls
 *     cancelDeal(dealId)  → Deal moves to CANCELLED.
 *
 * ─── Why a Factory? ────────────────────────────────────────────────────────────
 *  The factory is deployed once. Every new sale is just a new Deal entry (struct
 *  stored in a mapping). Gas cost per deal ≈ 1 SSTORE per field — far cheaper
 *  than deploying a new contract per deal.
 */
contract EscrowFactory {

    // ─── State Enum ────────────────────────────────────────────────────────────

    enum DealState {
        AWAITING_DECISION,  // Seller created deal, buyer has not acted yet
        FUNDED,             // Buyer accepted and paid — funds sent to seller
        REJECTED,           // Buyer explicitly rejected the price
        CANCELLED           // Seller cancelled before buyer decided
    }

    // ─── Deal Struct ───────────────────────────────────────────────────────────

    struct Deal {
        address payable seller;
        address         buyer;
        uint256         price;        // in wei
        bytes32         imageHash;    // keccak256(imageBytes) — off-chain proof
        DealState       state;
        uint256         createdAt;
    }

    // ─── Storage ───────────────────────────────────────────────────────────────

    uint256 public dealCount;
    mapping(uint256 => Deal) public deals;

    // ─── Events ────────────────────────────────────────────────────────────────

    event DealCreated(
        uint256 indexed dealId,
        address indexed seller,
        address indexed buyer,
        uint256 price,
        bytes32 imageHash
    );
    event DealAccepted(uint256 indexed dealId, address indexed buyer, uint256 price);
    event DealRejected(uint256 indexed dealId, address indexed buyer);
    event DealCancelled(uint256 indexed dealId, address indexed seller);

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
        require(priceWei > 0,                  "EscrowFactory: price must be > 0");
        require(buyerAddr != address(0),       "EscrowFactory: invalid buyer address");
        require(buyerAddr != msg.sender,       "EscrowFactory: buyer cannot be seller");
        require(imageHash != bytes32(0),       "EscrowFactory: image hash required");

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

    // ─── Buyer Actions ─────────────────────────────────────────────────────────

    /**
     * @notice Buyer accepts the deal and pays the seller.
     *         msg.value MUST equal deal.price exactly.
     *         Funds are transferred immediately to the seller.
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

        // Immediately transfer to seller — no funds remain in the factory
        (bool success, ) = deal.seller.call{value: msg.value}("");
        require(success, "EscrowFactory: ETH transfer to seller failed");

        emit DealAccepted(dealId, msg.sender, msg.value);
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
     * @notice Returns all deal IDs where the caller is the seller.
     *         Off-chain indexing is preferred for large sets; this is a helper.
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
     * @notice Returns all deal IDs where the caller is the buyer.
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

    /// @dev The factory never holds ETH. Reject accidental transfers.
    receive() external payable { revert("EscrowFactory: direct ETH not accepted"); }
    fallback() external payable { revert("EscrowFactory: unknown function"); }
}
