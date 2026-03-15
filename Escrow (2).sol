// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title Escrow
 * @notice A basic two-party escrow contract for freelancer/buyer transactions.
 * @dev Buyer deploys the contract, specifying the seller address.
 *      Funds move through states: CREATED → FUNDED → RELEASED or REFUNDED.
 */
contract Escrow {

    // ─── State Enum ────────────────────────────────────────────────────────────

    enum State { CREATED, FUNDED, RELEASED, REFUNDED }

    // ─── Storage ───────────────────────────────────────────────────────────────

    address public buyer;
    address public seller;
    uint256 public amount;
    State   public state;

    // ─── Events ────────────────────────────────────────────────────────────────

    event ContractCreated(address indexed buyer, address indexed seller);
    event Funded(address indexed buyer, uint256 amount);
    event DeliveryConfirmed(address indexed seller, uint256 amount);
    event Refunded(address indexed buyer, uint256 amount);

    // ─── Modifiers ─────────────────────────────────────────────────────────────

    modifier onlyBuyer() {
        require(msg.sender == buyer, "Escrow: caller is not the buyer");
        _;
    }

    modifier inState(State _expected) {
        require(state == _expected, "Escrow: invalid contract state for this action");
        _;
    }

    // ─── Constructor ───────────────────────────────────────────────────────────

    /**
     * @param _seller Address of the seller (freelancer) who will receive payment.
     * @notice The deploying wallet automatically becomes the buyer.
     */
    constructor(address _seller) {
        require(_seller != address(0), "Escrow: seller cannot be zero address");
        require(_seller != msg.sender, "Escrow: buyer and seller cannot be the same");

        buyer  = msg.sender;
        seller = _seller;
        state  = State.CREATED;

        emit ContractCreated(buyer, seller);
    }

    // ─── Core Functions ────────────────────────────────────────────────────────

    /**
     * @notice Buyer deposits ETH into escrow. Contract moves to FUNDED state.
     * @dev msg.value must be > 0. Can only be called once (when state == CREATED).
     */
    function fund() external payable onlyBuyer inState(State.CREATED) {
        require(msg.value > 0, "Escrow: must deposit a non-zero amount");
        amount = msg.value;
        state  = State.FUNDED;
        emit Funded(buyer, amount);
    }

    /**
     * @notice Buyer confirms they received the product/service.
     *         Releases escrowed funds to the seller.
     */
    function confirmDelivery() external onlyBuyer inState(State.FUNDED) {
        state = State.RELEASED;
        (bool success, ) = payable(seller).call{value: amount}("");
        require(success, "Escrow: ETH transfer to seller failed");
        emit DeliveryConfirmed(seller, amount);
    }

    /**
     * @notice Buyer requests a refund (e.g. seller did not deliver).
     *         Returns escrowed funds to the buyer.
     */
    function refund() external onlyBuyer inState(State.FUNDED) {
        state = State.REFUNDED;
        (bool success, ) = payable(buyer).call{value: amount}("");
        require(success, "Escrow: ETH refund to buyer failed");
        emit Refunded(buyer, amount);
    }

    // ─── View Functions ────────────────────────────────────────────────────────

    /**
     * @notice Returns a full snapshot of the contract's current state.
     */
    function getContractInfo()
        external
        view
        returns (
            address _buyer,
            address _seller,
            uint256 _amount,
            State   _state
        )
    {
        return (buyer, seller, amount, state);
    }

    /**
     * @notice Returns the current ETH balance held by this contract.
     */
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    /**
     * @notice Human-readable label for the current state.
     */
    function getStateLabel() external view returns (string memory) {
        if (state == State.CREATED)  return "CREATED";
        if (state == State.FUNDED)   return "FUNDED";
        if (state == State.RELEASED) return "RELEASED";
        if (state == State.REFUNDED) return "REFUNDED";
        return "UNKNOWN";
    }
}

