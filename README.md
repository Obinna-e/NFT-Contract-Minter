# circles-nft-minter

Flutter app for programmatically minting Circles NFTs on Polygon. Calls `mint(tokenURI)` on the deployed contract for each token, using a metadata URI pinned to IPFS.

## The project

Part of a three-repository generative NFT system:

- **[generative-circles-nft](https://github.com/Obinna-e/generative-circles-nft)** — Solidity smart contract (ERC-721 on Polygon)
- **[circles-nft-generator](https://github.com/Obinna-e/Nft-Generator)** — Flutter app that generates the PNG art and metadata JSON locally
- **This repo** — calls the deployed contract to mint each token

Pipeline: generate art and metadata → pin both to IPFS → run this app to mint each token with its IPFS metadata URI.

## What the app does

The app loads contract config from `.env`, reads the contract ABI from `assets/abi.json`, connects to a Polygon RPC endpoint via `web3dart`, signs transactions locally with the owner's private key, and calls `mint(tokenURI)` on the contract for each token.

Because the underlying contract uses `onlyOwner` minting, only the wallet that deployed the contract can run this minter against it.

## Tech stack

- Flutter / Dart (SDK `>=2.17.5 <3.0.0`)
- `web3dart ^2.3.1` for chain interaction
- `http ^0.13.4` for RPC calls
- `flutter_dotenv ^5.0.2` for secret loading
- Polygon RPC (mainnet or Mumbai testnet, depending on configuration)

## Configuration

The app expects a `.env` file at the project root with at least:

```
PRIVATE_KEY=0x...     # the contract owner's private key
RPC_URL=https://...   # Polygon RPC endpoint (Infura, Alchemy, etc.)
CONTRACT_ADDRESS=0x...
```

`.env` is gitignored and never committed. The contract ABI lives in `assets/abi.json` and is bundled with the build.

## Security notes

- `.env` is gitignored from initial setup; no private keys are or have been committed.
- For anyone forking this, use a fresh wallet and never reuse a mainnet-funded private key for testing. Treat this as artist-tool tooling, not as production wallet infrastructure.
- Modern equivalent of this pattern is WalletConnect or a dedicated key-management service (AWS KMS, GCP Cloud HSM) rather than `.env` with a raw private key, even for personal projects.

## Known limitations

Part of a 2020 to 2022 exploration, kept for portfolio context. Things a current rewrite would do differently:

- **Private key in `.env` is fragile.** Fine for a single-owner artist-mint workflow but not how I'd build it today. WalletConnect or a separate signer service would be the modern approach.
- **No batch minting.** Each token is a separate `mint()` transaction. A v2 of the contract with a `mintBatch` function would cut gas significantly for a 10-piece drop, even on Polygon.
- **No IPFS upload built in.** The user has to pin the JSON files (output of [circles-nft-generator](https://github.com/Obinna-e/Nft-Generator)) separately before running this app. A modern rewrite would integrate a pinning SDK.
- **State management.** Likely plain `StatefulWidget` + `setState`. Riverpod would be the current choice.
- **No tests.** Flutter scaffold only.

## License

Unlicense (public domain).
