const ProofVerifierKRS = artifacts.require("ProofVerifierKRS");
const square_1 = require("../contracts/zokrates/code/square/proofs/proof_1.json");
const square_4 = require("../contracts/zokrates/code/square/proofs/proof_4.json");
const square_9 = require("../contracts/zokrates/code/square/proofs/proof_9.json");
const square_16 = require("../contracts/zokrates/code/square/proofs/proof_16.json");
const square_25 = require("../contracts/zokrates/code/square/proofs/proof_25.json");
const square_36 = require("../contracts/zokrates/code/square/proofs/proof_36.json");
const square_49 = require("../contracts/zokrates/code/square/proofs/proof_49.json");
const square_64 = require("../contracts/zokrates/code/square/proofs/proof_64.json");
const square_81 = require("../contracts/zokrates/code/square/proofs/proof_81.json");
const square_100 = require("../contracts/zokrates/code/square/proofs/proof_100.json");
const truffleAssert = require("truffle-assertions");

contract("ProofVerifierKRS", (accounts) => {
  let squareProofs = [
    square_1,
    square_4,
    square_9,
    square_16,
    square_25,
    square_36,
    square_49,
    square_64,
    square_81,
    square_100,
  ];
  let proofKeys = [];

  before(async () => {
    KRS = await ProofVerifierKRS.deployed();
  });

  it("should validate all submissions", async () => {
    for (let i = 0; i < squareProofs.length; i++) {
      let square = squareProofs[i];

      let tx = await KRS.submitOwnershipProof(
        square.proof.a,
        square.proof.b,
        square.proof.c,
        square.inputs
      );

      truffleAssert.eventEmitted(tx, "ProofVerified", (ev) => {
        console.log("\tproof #" + (i + 1));
        console.log("\t\tkey:" + ev.key);
        console.log("\t\tprover:" + ev.prover);

        proofKeys[i] = ev.key; // workaround to get the proof key
        return ev;
      });
    }
  });

  it("should mint KRS tokens from all submissions", async () => {
    for (let i = 0; i < proofKeys.length; i++) {
      let tx = await KRS.mint(proofKeys[i]);

      truffleAssert.eventEmitted(tx, "TokenMinted", (ev) => {
        console.log("\ttoken #" + (i + 1));
        console.log("\t\tto:" + ev.to);
        console.log("\t\tkey:" + ev.key);
        console.log("\t\ttokenId:" + ev.tokenId);

        return ev.key === proofKeys[i];
      });
    }
  });

  it("should return the total token supply", async function () {
    assert.equal(await KRS.totalSupply(), proofKeys.length);
  });

  it("should return the amount of tokens owned", async function () {
    assert.equal(await KRS.balanceOf(accounts[0]), proofKeys.length);
  });

  it("should transfer token ownership", async function () {
    let tokenId = proofKeys[1];
    let from = accounts[0];
    let to = accounts[1];

    assert.equal(await KRS.ownerOf(tokenId), from);
    assert.equal(await KRS.balanceOf(from), 10);
    assert.equal(await KRS.balanceOf(to), 0);
    await KRS.safeTransferFrom(from, to, tokenId, {
      from: from,
    });
    assert.equal(await KRS.ownerOf(tokenId), to);
    assert.equal(await KRS.balanceOf(from), 9);
    assert.equal(await KRS.balanceOf(to), 1);
  });

  it("should *not* mint KRS token from invalid key", async () => {
    await truffleAssert.reverts(
      KRS.mint("0xffffff"),
      "KryptoRealStateZKP: solution key does not exist"
    );
  });
});
