# Classroom Polls dApp

This project is a decentralized classroom polling application. It is different
from the week 1--4 `HelloWorld` exercise: anyone can create a poll, every wallet
can vote at most once, and the vote totals are stored in the smart contract.
The poll creator can close a poll early; otherwise it closes when its deadline
is reached.

## Files

- `contracts/ClassroomPoll.sol` contains the contract.
- `test/ClassroomPoll.ts` tests poll creation, voting, one-vote-per-wallet, and closing.
- `ignition/modules/ClassroomPoll.ts` is the Hardhat deployment module.
- `index.html` is the browser frontend using the week 4 ethers.js pattern.

## Run locally

From this directory:

```powershell
npm install
npx hardhat build
npx hardhat test
```

To use the frontend with a local Hardhat node:

1. Run `npx hardhat node` in one terminal.
2. Deploy with `npx hardhat ignition deploy ignition/modules/ClassroomPoll.ts --network localhost`.
3. Ensure `ethers.umd.min.js` is present in this directory.
4. Serve this directory with any local static server and open it through `http://localhost`.

The browser frontend is configured for Sepolia and does not read contracts
deployed to the local Hardhat network.

The contract is not deployed by this task. Do not put real private keys in the
repository. For Sepolia, configure `SEPOLIA_RPC_URL` and `SEPOLIA_PRIVATE_KEY`
only in local environment variables before using Hardhat's deployment command.

## Sepolia testnet and transaction fees

The frontend reads the configured Sepolia deployment automatically, so polls
appear without connecting MetaMask or entering a contract address. Clicking a
vote option prompts for wallet connection if needed. Connect MetaMask on Sepolia
to create or close polls. If you deploy your own copy to Sepolia, enter its
address in the optional contract-address override. A local Hardhat address
(often starting with `0x5FbDB`) is not a Sepolia contract address.

Sepolia transactions pay their network fee in **SepoliaETH**. The fee currency
is determined by the selected blockchain; it cannot be changed to another
token through this app. SepoliaETH is test currency and cannot pay fees on
Ethereum mainnet. For Hardhat deployment, set `SEPOLIA_RPC_URL` and
`SEPOLIA_PRIVATE_KEY` in your local PowerShell session, then run:

```powershell
npx hardhat ignition deploy ignition/modules/ClassroomPoll.ts --network sepolia
```

Never put a private key in source code or commit it to a repository. The
browser frontend uses the connected MetaMask account to pay for poll creation,
votes, and closing polls.

## Using the frontend

Polls load automatically from the configured Sepolia deployment. Click an
option to connect MetaMask and vote; MetaMask must confirm the transaction.
Connect MetaMask on Sepolia to create or close a poll. The results and deadlines
are read from the contract.
