# EscrowChain — Deployment Guide
## Remix IDE + Sepolia Testnet

---

## Prerequisites

| Tool | Purpose | Link |
|------|---------|-------|
| MetaMask | Browser wallet | metamask.io |
| Sepolia ETH | Test funds | sepoliafaucet.com or cloud.google.com/application/web3/faucet |
| Remix IDE | Write & deploy contract | remix.ethereum.org |
| Etherscan (Sepolia) | Verify & view txs | sepolia.etherscan.io |

---

## Step 1 — Get Sepolia Test ETH

1. Open MetaMask → switch network to **Sepolia Test Network**
   - If Sepolia is not listed: Settings → Networks → Add Network → search "Sepolia"
2. Go to a faucet and request test ETH:
   - https://sepoliafaucet.com  (requires Alchemy login)
   - https://cloud.google.com/application/web3/faucet/ethereum/sepolia  (Google account)
3. Wait ~30 seconds for ETH to arrive in your wallet.

---

## Step 2 — Compile the Contract in Remix

1. Go to **https://remix.ethereum.org**
2. In the File Explorer, create a new file: `Escrow.sol`
3. Paste the entire contents of your `Escrow.sol` file.
4. Click the **Solidity Compiler** tab (left sidebar, looks like `< >`).
5. Set compiler version to **0.8.19** (or any 0.8.x).
6. Click **Compile Escrow.sol**.
7. If successful you will see a green checkmark ✓

### Get the ABI & Bytecode (for the frontend)
- Click **"Compilation Details"** button.
- Copy the **ABI** — paste it into `index.html` inside the `ESCROW_ABI` array.
  - (The human-readable ABI already in `index.html` works out of the box — you only need to replace it if you modify the contract.)
- Copy the **Bytecode → object** field — paste it into `ESCROW_BYTECODE` in `index.html`
  - (Only needed if you want to deploy from the UI rather than from Remix.)

---

## Step 3 — Deploy the Contract

1. Click the **Deploy & Run Transactions** tab in Remix (looks like Ethereum logo + arrow).
2. Under **Environment**, select **"Injected Provider - MetaMask"**.
   - MetaMask will pop up asking to connect — approve it.
   - Confirm it shows **Sepolia** network.
3. Under **Contract**, make sure **Escrow** is selected.
4. In the **Deploy** input field, enter the **seller's wallet address** (the freelancer who will receive payment).
5. Click **Deploy** — MetaMask will ask you to confirm the transaction.
6. Wait for the transaction to confirm (~15 seconds on Sepolia).
7. The deployed contract address appears under **Deployed Contracts** in Remix.
   - **Copy this address** — you'll need it for the frontend.

---

## Step 4 — Verify on Etherscan (Optional but Recommended)

1. Go to https://sepolia.etherscan.io
2. Paste your contract address in the search bar.
3. You should see your deployment transaction.
4. To verify the source code:
   - Click **Contract** tab → **Verify and Publish**
   - Choose: Solidity (Single file), compiler version 0.8.19, MIT license
   - Paste your `Escrow.sol` source code
   - Submit — once verified, users can read/write to the contract directly from Etherscan.

---

## Step 5 — Use the Frontend

1. Open `index.html` in your browser (or serve it with VS Code Live Server).
2. Click **Connect Wallet** — approve in MetaMask (make sure you're on Sepolia).
3. **To deploy a new contract from the UI:**
   - Enter the seller's address → click **Deploy Escrow**
   - (Requires `ESCROW_BYTECODE` to be filled in — see Step 2)
4. **To load an already-deployed contract:**
   - Paste the contract address from Step 3 → click **Load Contract**
5. **Buyer flow:**
   - Enter ETH amount → **Deposit ETH** (funds the escrow)
   - After receiving delivery → **Confirm Delivery** (releases funds to seller)
   - If delivery fails → **Request Refund** (returns ETH to buyer)

---

## Contract State Machine

```
[CREATED] ──(fund())──► [FUNDED] ──(confirmDelivery())──► [RELEASED]
                              └──(refund())──────────────► [REFUNDED]
```

| State | Meaning |
|-------|---------|
| CREATED | Contract deployed, waiting for buyer to deposit |
| FUNDED | ETH locked in contract |
| RELEASED | Seller received payment ✓ |
| REFUNDED | Buyer received refund ✓ |

---

## Common Errors & Fixes

| Error | Fix |
|-------|-----|
| "caller is not the buyer" | Make sure MetaMask is connected with the buyer's address |
| "invalid contract state" | The action isn't valid in the current state (e.g. trying to fund a FUNDED contract) |
| "Must send ETH" | Enter a non-zero amount in the fund field |
| MetaMask shows wrong network | Switch to Sepolia in MetaMask |
| Transaction fails with "gas" error | Make sure you have enough Sepolia ETH for gas fees |

---

## Project Structure

```
/
├── Escrow.sol          ← Smart contract (deploy in Remix)
├── index.html          ← Frontend dApp (open in browser)
└── DEPLOYMENT_GUIDE.md ← This file
```

---

## Testing Checklist

- [ ] Contract compiles without errors in Remix
- [ ] Deployed on Sepolia, address saved
- [ ] Deployment visible on sepolia.etherscan.io
- [ ] Wallet connects in frontend (MetaMask on Sepolia)
- [ ] Contract loads from address
- [ ] Buyer can fund escrow
- [ ] State changes to FUNDED after funding
- [ ] Confirm Delivery releases funds to seller
- [ ] Refund returns ETH to buyer
- [ ] Events appear in the Activity Log

---

*Built with Solidity 0.8.19, ethers.js v6, MetaMask, Sepolia testnet.*
