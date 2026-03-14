<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>EscrowChain — Trustless Peer-to-Peer Payments</title>

  <!-- ethers.js v6 -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/ethers/6.7.0/ethers.umd.min.js"></script>

  <!-- Google Fonts -->
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=IBM+Plex+Mono:wght@300;400;500&display=swap" rel="stylesheet" />

  <style>
    /* ── Design tokens ─────────────────────────────────────────── */
    :root {
      --bg:        #080b10;
      --surface:   #0d1117;
      --border:    #1e2633;
      --accent:    #f0b429;
      --accent2:   #3ecf8e;
      --danger:    #f56565;
      --text:      #e2e8f0;
      --muted:     #64748b;
      --font-head: 'Syne', sans-serif;
      --font-mono: 'IBM Plex Mono', monospace;
    }

    /* ── Reset ─────────────────────────────────────────────────── */
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    html { scroll-behavior: smooth; }

    body {
      background: var(--bg);
      color: var(--text);
      font-family: var(--font-mono);
      font-size: 14px;
      min-height: 100vh;
      overflow-x: hidden;
    }

    /* ── Background grid ───────────────────────────────────────── */
    body::before {
      content: '';
      position: fixed;
      inset: 0;
      background-image:
        linear-gradient(rgba(240,180,41,.04) 1px, transparent 1px),
        linear-gradient(90deg, rgba(240,180,41,.04) 1px, transparent 1px);
      background-size: 40px 40px;
      pointer-events: none;
      z-index: 0;
    }

    /* ── Layout ────────────────────────────────────────────────── */
    .wrapper {
      position: relative;
      z-index: 1;
      max-width: 860px;
      margin: 0 auto;
      padding: 40px 24px 80px;
    }

    /* ── Header ────────────────────────────────────────────────── */
    header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-bottom: 56px;
      flex-wrap: wrap;
      gap: 16px;
    }

    .logo {
      font-family: var(--font-head);
      font-weight: 800;
      font-size: 22px;
      letter-spacing: -0.5px;
      color: var(--text);
    }

    .logo span { color: var(--accent); }

    #btn-connect {
      background: transparent;
      border: 1px solid var(--accent);
      color: var(--accent);
      font-family: var(--font-mono);
      font-size: 12px;
      padding: 8px 18px;
      cursor: pointer;
      transition: background .2s, color .2s;
      letter-spacing: .06em;
      text-transform: uppercase;
    }
    #btn-connect:hover { background: var(--accent); color: var(--bg); }

    #wallet-info {
      display: none;
      font-size: 11px;
      color: var(--muted);
      align-items: center;
      gap: 8px;
    }
    #wallet-info .dot {
      width: 8px; height: 8px;
      border-radius: 50%;
      background: var(--accent2);
      animation: pulse 2s infinite;
    }
    @keyframes pulse { 0%,100%{opacity:1} 50%{opacity:.4} }

    /* ── Hero ──────────────────────────────────────────────────── */
    .hero {
      margin-bottom: 52px;
      border-left: 3px solid var(--accent);
      padding-left: 20px;
    }
    .hero h1 {
      font-family: var(--font-head);
      font-size: clamp(28px, 5vw, 48px);
      font-weight: 800;
      line-height: 1.1;
      letter-spacing: -1px;
      color: var(--text);
      margin-bottom: 12px;
    }
    .hero h1 em { font-style: normal; color: var(--accent); }
    .hero p { color: var(--muted); font-size: 13px; line-height: 1.8; max-width: 520px; }

    /* ── Flow diagram ──────────────────────────────────────────── */
    .flow {
      display: flex;
      align-items: center;
      gap: 0;
      margin-bottom: 48px;
      overflow-x: auto;
      padding-bottom: 4px;
    }
    .flow-step {
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 6px;
      min-width: 90px;
    }
    .flow-badge {
      width: 36px; height: 36px;
      border-radius: 50%;
      border: 1px solid var(--border);
      display: flex; align-items: center; justify-content: center;
      font-size: 13px;
      background: var(--surface);
      color: var(--muted);
      transition: border-color .3s, color .3s;
    }
    .flow-label { font-size: 10px; color: var(--muted); text-transform: uppercase; letter-spacing: .08em; }
    .flow-arrow { color: var(--border); font-size: 18px; padding: 0 4px; margin-bottom: 20px; flex-shrink: 0; }

    /* Active step highlight */
    .flow-step.active .flow-badge { border-color: var(--accent); color: var(--accent); }
    .flow-step.done  .flow-badge { border-color: var(--accent2); color: var(--accent2); background: rgba(62,207,142,.08); }

    /* ── Cards ─────────────────────────────────────────────────── */
    .card-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 20px;
    }
    @media (max-width: 600px) { .card-grid { grid-template-columns: 1fr; } }

    .card {
      background: var(--surface);
      border: 1px solid var(--border);
      padding: 28px;
      position: relative;
      overflow: hidden;
      transition: border-color .25s;
    }
    .card:hover { border-color: var(--accent); }
    .card::before {
      content: '';
      position: absolute;
      top: 0; left: 0; right: 0;
      height: 2px;
      background: var(--accent);
      transform: scaleX(0);
      transform-origin: left;
      transition: transform .3s;
    }
    .card:hover::before { transform: scaleX(1); }

    .card-tag {
      font-size: 10px;
      text-transform: uppercase;
      letter-spacing: .1em;
      color: var(--accent);
      margin-bottom: 10px;
      display: block;
    }
    .card h2 {
      font-family: var(--font-head);
      font-size: 18px;
      font-weight: 700;
      margin-bottom: 20px;
      color: var(--text);
    }

    /* ── Form elements ─────────────────────────────────────────── */
    label {
      display: block;
      font-size: 11px;
      text-transform: uppercase;
      letter-spacing: .08em;
      color: var(--muted);
      margin-bottom: 6px;
    }

    input[type="text"],
    input[type="number"] {
      width: 100%;
      background: var(--bg);
      border: 1px solid var(--border);
      color: var(--text);
      font-family: var(--font-mono);
      font-size: 13px;
      padding: 10px 12px;
      margin-bottom: 16px;
      outline: none;
      transition: border-color .2s;
    }
    input:focus { border-color: var(--accent); }
    input::placeholder { color: var(--muted); }

    .btn {
      width: 100%;
      padding: 12px;
      font-family: var(--font-mono);
      font-size: 12px;
      letter-spacing: .08em;
      text-transform: uppercase;
      cursor: pointer;
      border: none;
      transition: opacity .2s, transform .1s;
    }
    .btn:active { transform: scale(.98); }
    .btn:disabled { opacity: .35; cursor: not-allowed; }

    .btn-primary  { background: var(--accent); color: var(--bg); font-weight: 500; }
    .btn-success  { background: var(--accent2); color: var(--bg); font-weight: 500; }
    .btn-danger   { background: var(--danger); color: #fff; font-weight: 500; }

    /* ── Status card ───────────────────────────────────────────── */
    .card-status { grid-column: 1 / -1; }

    .status-row {
      display: flex;
      align-items: baseline;
      justify-content: space-between;
      flex-wrap: wrap;
      gap: 8px;
      padding: 12px 0;
      border-bottom: 1px solid var(--border);
    }
    .status-row:last-child { border-bottom: none; }
    .status-key  { font-size: 11px; color: var(--muted); text-transform: uppercase; letter-spacing: .08em; }
    .status-val  { font-size: 13px; word-break: break-all; color: var(--text); }
    .badge {
      display: inline-block;
      padding: 3px 10px;
      font-size: 11px;
      letter-spacing: .08em;
      text-transform: uppercase;
      border-radius: 2px;
    }
    .badge-created  { background: rgba(240,180,41,.12); color: var(--accent); }
    .badge-funded   { background: rgba(100,130,255,.15); color: #7c8dff; }
    .badge-released { background: rgba(62,207,142,.12); color: var(--accent2); }
    .badge-refunded { background: rgba(245,101,101,.12); color: var(--danger); }

    /* ── Log ───────────────────────────────────────────────────── */
    .log-wrap {
      grid-column: 1 / -1;
      background: var(--surface);
      border: 1px solid var(--border);
      padding: 20px 24px;
    }
    .log-title {
      font-size: 11px;
      text-transform: uppercase;
      letter-spacing: .1em;
      color: var(--muted);
      margin-bottom: 12px;
    }
    #log {
      list-style: none;
      max-height: 180px;
      overflow-y: auto;
      display: flex;
      flex-direction: column-reverse;
      gap: 6px;
    }
    #log li {
      font-size: 12px;
      color: var(--muted);
      padding-left: 14px;
      position: relative;
      line-height: 1.6;
    }
    #log li::before {
      content: '>';
      position: absolute;
      left: 0;
      color: var(--accent);
    }
    #log li.ok   { color: var(--accent2); }
    #log li.err  { color: var(--danger); }
    #log li.info { color: var(--text); }

    /* ── Toast ─────────────────────────────────────────────────── */
    #toast {
      position: fixed;
      bottom: 28px; right: 28px;
      background: var(--surface);
      border: 1px solid var(--border);
      border-left: 3px solid var(--accent);
      padding: 14px 20px;
      font-size: 12px;
      max-width: 320px;
      opacity: 0;
      transform: translateY(12px);
      transition: opacity .3s, transform .3s;
      pointer-events: none;
      z-index: 999;
    }
    #toast.show { opacity: 1; transform: translateY(0); }
    #toast.err  { border-left-color: var(--danger); }
    #toast.ok   { border-left-color: var(--accent2); }

    /* ── Spinner ───────────────────────────────────────────────── */
    .spin {
      display: inline-block;
      width: 12px; height: 12px;
      border: 2px solid transparent;
      border-top-color: currentColor;
      border-radius: 50%;
      animation: spin .6s linear infinite;
      vertical-align: middle;
      margin-right: 6px;
    }
    @keyframes spin { to { transform: rotate(360deg); } }
  </style>
</head>
<body>
<div class="wrapper">

  <!-- ── Header ──────────────────────────────────────────────────── -->
  <header>
    <div class="logo">Escrow<span>Chain</span></div>
    <div id="wallet-info">
      <div class="dot"></div>
      <span id="wallet-addr">—</span>
    </div>
    <button id="btn-connect">Connect Wallet</button>
  </header>

  <!-- ── Hero ────────────────────────────────────────────────────── -->
  <div class="hero">
    <h1>Trustless<br/>peer-to-peer<br/><em>escrow.</em></h1>
    <p>Securely lock ETH in a smart contract on Sepolia. Funds release only when the buyer confirms delivery — no middlemen, no surprises.</p>
  </div>

  <!-- ── State flow ───────────────────────────────────────────────── -->
  <div class="flow">
    <div class="flow-step" id="step-created">
      <div class="flow-badge">①</div>
      <div class="flow-label">Created</div>
    </div>
    <div class="flow-arrow">→</div>
    <div class="flow-step" id="step-funded">
      <div class="flow-badge">②</div>
      <div class="flow-label">Funded</div>
    </div>
    <div class="flow-arrow">→</div>
    <div class="flow-step" id="step-released">
      <div class="flow-badge">③a</div>
      <div class="flow-label">Released</div>
    </div>
    <div class="flow-arrow" style="color: var(--border); padding: 0 8px; margin-bottom:20px">or</div>
    <div class="flow-step" id="step-refunded">
      <div class="flow-badge">③b</div>
      <div class="flow-label">Refunded</div>
    </div>
  </div>

  <!-- ── Cards ────────────────────────────────────────────────────── -->
  <div class="card-grid">

    <!-- Deploy -->
    <div class="card" id="card-deploy">
      <span class="card-tag">Step 1</span>
      <h2>Deploy Contract</h2>
      <label>Seller Address</label>
      <input type="text" id="input-seller" placeholder="0xSeller..." />
      <button class="btn btn-primary" id="btn-deploy">Deploy Escrow</button>
    </div>

    <!-- Load existing -->
    <div class="card" id="card-load">
      <span class="card-tag">Or load existing</span>
      <h2>Connect to Contract</h2>
      <label>Contract Address</label>
      <input type="text" id="input-contract" placeholder="0xContract..." />
      <button class="btn btn-primary" id="btn-load">Load Contract</button>
    </div>

    <!-- Status (hidden until contract loaded) -->
    <div class="card card-status" id="card-status" style="display:none">
      <span class="card-tag">Contract Status</span>
      <h2>Escrow Details</h2>
      <div class="status-row"><span class="status-key">Contract</span><span class="status-val" id="st-address">—</span></div>
      <div class="status-row"><span class="status-key">Buyer</span>  <span class="status-val" id="st-buyer">—</span></div>
      <div class="status-row"><span class="status-key">Seller</span> <span class="status-val" id="st-seller">—</span></div>
      <div class="status-row"><span class="status-key">Amount</span> <span class="status-val" id="st-amount">—</span></div>
      <div class="status-row"><span class="status-key">State</span>  <span class="status-val" id="st-state">—</span></div>
      <div class="status-row"><span class="status-key">Balance</span><span class="status-val" id="st-balance">—</span></div>
    </div>

    <!-- Fund -->
    <div class="card" id="card-fund" style="display:none">
      <span class="card-tag">Buyer · Step 2</span>
      <h2>Fund Escrow</h2>
      <label>Amount (ETH)</label>
      <input type="number" id="input-amount" placeholder="0.01" step="0.001" min="0" />
      <button class="btn btn-primary" id="btn-fund">Deposit ETH</button>
    </div>

    <!-- Actions -->
    <div class="card" id="card-actions" style="display:none">
      <span class="card-tag">Buyer · Step 3</span>
      <h2>Resolve Escrow</h2>
      <p style="color:var(--muted); font-size:12px; margin-bottom:20px; line-height:1.7">
        Confirm delivery to release funds to the seller,<br/>or request a refund if delivery was not made.
      </p>
      <button class="btn btn-success" id="btn-confirm" style="margin-bottom:10px">✓ Confirm Delivery</button>
      <button class="btn btn-danger" id="btn-refund">↩ Request Refund</button>
    </div>

  </div><!-- /card-grid -->

  <!-- ── Activity Log ──────────────────────────────────────────────── -->
  <div class="log-wrap" style="margin-top:20px">
    <div class="log-title">Activity Log</div>
    <ul id="log"></ul>
  </div>

</div><!-- /wrapper -->

<!-- ── Toast ─────────────────────────────────────────────────────── -->
<div id="toast"></div>

<!-- ────────────────────────────────────────────────────────────────
     JavaScript — ethers.js v6 integration
     ────────────────────────────────────────────────────────────────
     IMPORTANT: After deploying Escrow.sol in Remix, paste the ABI
     into ESCROW_ABI below. The ABI is shown in the "Compilation
     Details" panel after compiling.
     ──────────────────────────────────────────────────────────────── -->
<script>
// ── Paste your compiled ABI here ─────────────────────────────────────
const ESCROW_ABI = [
  "constructor(address _seller)",
  "function buyer() view returns (address)",
  "function seller() view returns (address)",
  "function amount() view returns (uint256)",
  "function state() view returns (uint8)",
  "function fund() payable",
  "function confirmDelivery()",
  "function refund()",
  "function getContractInfo() view returns (address, address, uint256, uint8)",
  "function getBalance() view returns (uint256)",
  "function getStateLabel() view returns (string)",
  "event ContractCreated(address indexed buyer, address indexed seller)",
  "event Funded(address indexed buyer, uint256 amount)",
  "event DeliveryConfirmed(address indexed seller, uint256 amount)",
  "event Refunded(address indexed buyer, uint256 amount)"
];

// ── Paste the compiled BYTECODE here (from Remix → Compilation Details → Bytecode → object) ──
// Only needed for deploying from the UI. Leave empty if you deploy via Remix directly.
const ESCROW_BYTECODE = "";

// ─────────────────────────────────────────────────────────────────────
// App state
// ─────────────────────────────────────────────────────────────────────
let provider, signer, contract;
const STATE_LABELS = ["CREATED","FUNDED","RELEASED","REFUNDED"];

// ─── Helpers ─────────────────────────────────────────────────────────

function log(msg, type = "") {
  const li = document.createElement("li");
  li.textContent = msg;
  if (type) li.classList.add(type);
  document.getElementById("log").appendChild(li);
}

let toastTimer;
function toast(msg, type = "") {
  const el = document.getElementById("toast");
  el.textContent = msg;
  el.className = "show" + (type ? " " + type : "");
  clearTimeout(toastTimer);
  toastTimer = setTimeout(() => { el.className = ""; }, 3500);
}

function shortAddr(addr) {
  return addr.slice(0, 6) + "…" + addr.slice(-4);
}

function setLoading(btn, loading) {
  if (loading) {
    btn.dataset.orig = btn.textContent;
    btn.innerHTML = `<span class="spin"></span>Processing…`;
    btn.disabled = true;
  } else {
    btn.innerHTML = btn.dataset.orig || btn.textContent;
    btn.disabled = false;
  }
}

// ─── Connect wallet ───────────────────────────────────────────────────

document.getElementById("btn-connect").addEventListener("click", async () => {
  // Wait up to 2 seconds for the wallet extension to inject window.ethereum
  // (needed when opening as a local file://)
  if (!window.ethereum) {
    await new Promise(resolve => setTimeout(resolve, 1000));
  }
  if (!window.ethereum) {
    toast("No wallet detected. Make sure Rabby is installed and the extension has permission to run on file:// pages.", "err");
    log("window.ethereum not found. See instructions below.", "err");
    log("Fix: In Chrome, go to Extensions → Rabby → Details → turn on 'Allow access to file URLs'", "info");
    return;
  }
  try {
    provider = new ethers.BrowserProvider(window.ethereum);
    await provider.send("eth_requestAccounts", []);
    signer = await provider.getSigner();
    const addr = await signer.getAddress();

    // Check network — Sepolia chainId = 11155111
    const network = await provider.getNetwork();
    if (network.chainId !== 11155111n) {
      toast("Please switch Rabby to the Sepolia testnet.", "err");
      log("Wrong network detected: " + network.name + ". Switch to Sepolia in Rabby.", "err");
      return;
    }

    document.getElementById("btn-connect").style.display = "none";
    document.getElementById("wallet-info").style.display = "flex";
    document.getElementById("wallet-addr").textContent = shortAddr(addr);

    log(`Wallet connected: ${addr}`, "ok");
    toast("Wallet connected!", "ok");
  } catch (e) {
    log("Connection error: " + e.message, "err");
    toast("Connection failed.", "err");
  }
});

// ─── Deploy ───────────────────────────────────────────────────────────

document.getElementById("btn-deploy").addEventListener("click", async () => {
  if (!signer) { toast("Connect your wallet first.", "err"); return; }
  if (!ESCROW_BYTECODE) {
    toast("Add the contract bytecode to ESCROW_BYTECODE in the script.", "err");
    log("ESCROW_BYTECODE is empty — deploy via Remix, then load the address.", "err");
    return;
  }

  const sellerAddr = document.getElementById("input-seller").value.trim();
  if (!ethers.isAddress(sellerAddr)) { toast("Enter a valid seller address.", "err"); return; }

  const btn = document.getElementById("btn-deploy");
  setLoading(btn, true);
  try {
    const factory = new ethers.ContractFactory(ESCROW_ABI, ESCROW_BYTECODE, signer);
    const deployment = await factory.deploy(sellerAddr);
    log(`Deploying… tx: ${deployment.deploymentTransaction().hash}`, "info");
    await deployment.waitForDeployment();
    const addr = await deployment.getAddress();
    log(`Contract deployed at: ${addr}`, "ok");
    toast("Contract deployed!", "ok");
    loadContract(addr);
  } catch (e) {
    log("Deploy error: " + e.message, "err");
    toast("Deployment failed.", "err");
  } finally {
    setLoading(btn, false);
  }
});

// ─── Load existing contract ───────────────────────────────────────────

document.getElementById("btn-load").addEventListener("click", async () => {
  if (!signer) { toast("Connect your wallet first.", "err"); return; }
  const addr = document.getElementById("input-contract").value.trim();
  if (!ethers.isAddress(addr)) { toast("Enter a valid contract address.", "err"); return; }
  loadContract(addr);
});

async function loadContract(addr) {
  try {
    contract = new ethers.Contract(addr, ESCROW_ABI, signer);
    log(`Contract loaded: ${addr}`, "ok");
    toast("Contract loaded.", "ok");
    await refreshStatus();
    listenToEvents();
  } catch (e) {
    log("Load error: " + e.message, "err");
    toast("Failed to load contract.", "err");
  }
}

// ─── Refresh status ───────────────────────────────────────────────────

async function refreshStatus() {
  if (!contract) return;
  try {
    const [buyer, seller, amount, stateNum] = await contract.getContractInfo();
    const balance = await contract.getBalance();
    const stateLabel = STATE_LABELS[Number(stateNum)] || "UNKNOWN";
    const contractAddr = await contract.getAddress();
    const walletAddr = await signer.getAddress();

    document.getElementById("st-address").textContent = contractAddr;
    document.getElementById("st-buyer").textContent   = buyer;
    document.getElementById("st-seller").textContent  = seller;
    document.getElementById("st-amount").textContent  = ethers.formatEther(amount) + " ETH";
    document.getElementById("st-balance").textContent = ethers.formatEther(balance) + " ETH";

    const stateEl = document.getElementById("st-state");
    stateEl.innerHTML = `<span class="badge badge-${stateLabel.toLowerCase()}">${stateLabel}</span>`;

    // Show/hide action cards
    document.getElementById("card-status").style.display  = "block";
    document.getElementById("card-fund").style.display    = (stateLabel === "CREATED")  ? "block" : "none";
    document.getElementById("card-actions").style.display = (stateLabel === "FUNDED")   ? "block" : "none";

    // Update flow diagram
    resetFlow();
    const isBuyer = walletAddr.toLowerCase() === buyer.toLowerCase();
    if (stateLabel === "CREATED")  { markFlow("step-created", "active"); }
    if (stateLabel === "FUNDED")   { markFlow("step-created", "done"); markFlow("step-funded", "active"); }
    if (stateLabel === "RELEASED") { markFlow("step-created","done"); markFlow("step-funded","done"); markFlow("step-released","active"); }
    if (stateLabel === "REFUNDED") { markFlow("step-created","done"); markFlow("step-funded","done"); markFlow("step-refunded","active"); }

    if (!isBuyer && (stateLabel === "CREATED" || stateLabel === "FUNDED")) {
      log("Note: you are connected as the Seller. Buyer actions are restricted to the buyer address.", "info");
    }
  } catch (e) {
    log("Status refresh error: " + e.message, "err");
  }
}

function resetFlow() {
  ["step-created","step-funded","step-released","step-refunded"].forEach(id => {
    document.getElementById(id).classList.remove("active","done");
  });
}
function markFlow(id, cls) {
  document.getElementById(id).classList.add(cls);
}

// ─── Fund ─────────────────────────────────────────────────────────────

document.getElementById("btn-fund").addEventListener("click", async () => {
  if (!contract) { toast("Load a contract first.", "err"); return; }
  const eth = parseFloat(document.getElementById("input-amount").value);
  if (!eth || eth <= 0) { toast("Enter a valid ETH amount.", "err"); return; }

  const btn = document.getElementById("btn-fund");
  setLoading(btn, true);
  try {
    const tx = await contract.fund({ value: ethers.parseEther(eth.toString()) });
    log(`Fund tx sent: ${tx.hash}`, "info");
    await tx.wait();
    log(`Escrow funded with ${eth} ETH ✓`, "ok");
    toast("Escrow funded!", "ok");
    await refreshStatus();
  } catch (e) {
    log("Fund error: " + (e.reason || e.message), "err");
    toast("Funding failed.", "err");
  } finally {
    setLoading(btn, false);
  }
});

// ─── Confirm delivery ─────────────────────────────────────────────────

document.getElementById("btn-confirm").addEventListener("click", async () => {
  if (!contract) return;
  const btn = document.getElementById("btn-confirm");
  setLoading(btn, true);
  try {
    const tx = await contract.confirmDelivery();
    log(`Confirm delivery tx: ${tx.hash}`, "info");
    await tx.wait();
    log("Delivery confirmed — funds released to seller ✓", "ok");
    toast("Funds released to seller!", "ok");
    await refreshStatus();
  } catch (e) {
    log("Confirm error: " + (e.reason || e.message), "err");
    toast("Confirmation failed.", "err");
  } finally {
    setLoading(btn, false);
  }
});

// ─── Refund ───────────────────────────────────────────────────────────

document.getElementById("btn-refund").addEventListener("click", async () => {
  if (!contract) return;
  const btn = document.getElementById("btn-refund");
  setLoading(btn, true);
  try {
    const tx = await contract.refund();
    log(`Refund tx: ${tx.hash}`, "info");
    await tx.wait();
    log("Refund processed — ETH returned to buyer ✓", "ok");
    toast("Refund sent to buyer!", "ok");
    await refreshStatus();
  } catch (e) {
    log("Refund error: " + (e.reason || e.message), "err");
    toast("Refund failed.", "err");
  } finally {
    setLoading(btn, false);
  }
});

// ─── Event listeners (live on-chain events) ───────────────────────────

function listenToEvents() {
  if (!contract) return;
  contract.on("Funded", (buyer, amt) => {
    log(`[EVENT] Funded — buyer: ${shortAddr(buyer)}, amount: ${ethers.formatEther(amt)} ETH`, "ok");
  });
  contract.on("DeliveryConfirmed", (seller, amt) => {
    log(`[EVENT] DeliveryConfirmed — seller: ${shortAddr(seller)}, amount: ${ethers.formatEther(amt)} ETH`, "ok");
  });
  contract.on("Refunded", (buyer, amt) => {
    log(`[EVENT] Refunded — buyer: ${shortAddr(buyer)}, amount: ${ethers.formatEther(amt)} ETH`, "ok");
  });
}

// ─── Init ─────────────────────────────────────────────────────────────
log("EscrowChain ready. Connect your MetaMask wallet to begin.", "info");
</script>
</body>
</html>
