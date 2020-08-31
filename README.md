# Decentralized Real State Marketplace

<p align="center">
  <img src="/app/src/logo.jpg">
</p>

## Project Description

- Decentralized application that provides a [digital marketplace](https://rinkeby.opensea.io/storefront/kryptorealstate) for real-state properties.

### Asset Tokenization (ERC721)

- Real-state assets are represented as non-fungible tokens, implemented as in the [ERC721 standard](https://eips.ethereum.org/EIPS/eip-721).

### Minting and Zero Knowledge Proofs (ZKPs)

- In order to mint a new real-state token, a party (the prover) is required to prove to another (the verifier) knowledge of a secret. The application relies on a zero-knowledge Succinct Non-interactive ARguments of Knowledge (ZK-SNARK) scheme, which allows a prover to demonstrate beyond any reasonable doubt to a verifier, that the prover meets said requirement and knows a secret, without revealing what the secret is. As a non-interactive construction, the proof consists of a single message sent from the prover to the verifier.

- Zero-knowledge proofs (ZKPs) are a family of probabilistic protocols, first described by [Goldwasser, Micali and Rackoff](http://people.csail.mit.edu/silvio/Selected%20Scientific%20Papers/Proof%20Systems/The_Knowledge_Complexity_Of_Interactive_Proof_Systems.pdf) in 1985.

#### Generating ZKPs

- A naive proof-of-concept implementation in form of [square](https://github.com/dcarpintero/dapp-real-state/blob/master/contracts/zokrates/code/square/square.zok) knowledge is provided, whereas a more realistic [proof-of-preimage](https://github.com/dcarpintero/dapp-real-state/blob/master/contracts/zokrates/code/preimage/preimage.zok) scheme has also been implemented for proving preimage knowledge of a given hash digest, without revealing what the preimage is.

- ZK-SNARKs consist of three algorithms G, P, V. In a trusted off-chain setup phase, the key generator G takes a secret parameter lambda and a [program C](https://github.com/dcarpintero/dapp-real-state/blob/master/contracts/zokrates/code/preimage/preimage.zok) in order to generate two publicly available keys, namely a proving key pk and a verification key vk. These keys are public parameters that only need to be generated once for a given program C.

- Compilation of program C into an [aritmetic circuit](https://medium.com/@VitalikButerin/quadratic-arithmetic-programs-from-zero-to-hero-f6d558cea649), and generation of the proving and verification key from the resulting aritmetic circuit has been carried out by [ZoKrates](https://github.com/Zokrates/ZoKrates).

```
zokrates compile -i preimage.zok
zokrates setup
```

- As a next step, the prover P takes as input the proving key pk, a public input x and a private witness w. The algorithm generates a proof prf = P(pk, x, w) that the prover knows a witness w and that the witness satisfies the program.

```
zokrates compute-witness -a <x> <w> --output witness
```

- Each resulting proof consists of the three elliptic curve points that make up the zkSNARKs proof.

```
zokrates generate-proof -w witness -j proof
```

- The verifyTx function in the contract accepts these three values, along with an array of public inputs. The contract further computes V(vk, x, prf) which returns true if the proof is correct, and allows to infer that the prover knows a witness w satisfying C(x,w) == true.

```
zokrates export-verifier
```

### Unit and system tests

- TestKryptoRealState.js
- TestPausable.js
- TestPreimageVerifier.js
- TestSquareVerifier.js
- TestProofVerifier.js

### Dependencies

- Solidity v0.6.2 (solc-js)
- Node v12.17.0
- Web3.js v1.2.1
- Zokrates v0.6.1

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

Deployment to Rinkeby

```
truffle migrate --reset --network=rinkeby
```

### OpenSea Marketplace

- https://rinkeby.opensea.io/storefront/kryptorealstate

### Rinkeby Contract Addresses

## ProofVerifierKRS.sol

- Deployment TX: [0x9c7f76f30e27c52511a7d49953533c28369b91ef7a6f8bfc1fd7300937aba487](https://rinkeby.etherscan.io/tx/0x9c7f76f30e27c52511a7d49953533c28369b91ef7a6f8bfc1fd7300937aba487)
- Contract Address: [0x45ba1aBB6D689347888A199986FDC89aEd19eC00](https://rinkeby.etherscan.io/address/0x45ba1aBB6D689347888A199986FDC89aEd19eC00)

## SquareVerifier.sol

- Deployment TX: [0x44ebf1fd04004b737949dc1f0b5982ab73f2a553f25563420a45e84ab66c0eac](https://rinkeby.etherscan.io/tx/0x44ebf1fd04004b737949dc1f0b5982ab73f2a553f25563420a45e84ab66c0eac)
- Contract Address: [0xf1eBb6ED9482d2086bd55f8c227cF1f06655ea05](https://rinkeby.etherscan.io/address/0xf1eBb6ED9482d2086bd55f8c227cF1f06655ea05)

## OpenSea MarketPlace Storefront

## Transaction History

## About Zero Knowledge Proofs (ZKPs)

- [The Knowledge Complexity of Interactive Proof Systems, Goldwasser et al. 1985](http://people.csail.mit.edu/silvio/Selected%20Scientific%20Papers/Proof%20Systems/The_Knowledge_Complexity_Of_Interactive_Proof_Systems.pdf)
- [Building Identity-linked zkSNARKs with ZoKrates, Eberhardt 2019](https://medium.com/zokrates/building-identity-linked-zksnarks-with-zokrates-a36085cdd40)
- [zkSNARKs in a nutshell, C. Reitwiessner 2016](https://blog.ethereum.org/2016/12/05/zksnarks-in-a-nutshell/)

## Credits

- Storefront and listed property images have been designed using resources from Freepik.com.
