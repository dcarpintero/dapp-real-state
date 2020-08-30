# Real State Token with Zero Knowledge Proofs

## Project Description

Decentralized application [...].

### ERC721 Token

[...]

### Zero Knowledge Proofs

[...]

### Unit and system tests

- TestKryptoRealState.js
- TestPreimageVerifier.js
- TestSquareVerifier.js

### Dependencies

- Solidity v0.6.2 (solc-js)
- Node v12.17.0
- Web3.js v1.2.1

- Truffle v5.1.30 (core: 5.1.30) - Development framework
- @truffle/hdwallet-provider v1.0.36 - HD Wallet-enabled Web3 provider
- truffle-assertions v0.9.2 - Additional assertions for Truffle tests
- chai v4.2.0 - Assertion library

## Getting Started

Install dependencies

```
npm install
```

Define mnemonic in .secret file

```
.secret
truffle-config.js
```

Launch Ganache with the same mnemonic and initialize 10 accounts with 100 ETH each

```
ganache-cli -m <mnemonic> -a 10 -e 100
```

Compile, test and migrate

```
truffle compile
truffle test
truffle migrate --reset
```
