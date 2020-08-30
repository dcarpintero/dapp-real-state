const Verifier = artifacts.require("ProofVerifierKRS");
const square = require("../contracts/zokrates/code/square/proof.json");
const truffleAssert = require("truffle-assertions");

contract("ProofVerifierKRS", (accounts) => {
  let proofKey;

  before(async () => {
    verifier = await Verifier.deployed();
  });

  it("should validate submission", async () => {
    let tx = await verifier.submitOwnershipProof(
      square.proof.a,
      square.proof.b,
      square.proof.c,
      square.inputs
    );

    truffleAssert.eventEmitted(tx, "ProofVerified", (ev) => {
      console.log("\tProofVerified");
      console.log("\t\tkey:" + ev.key);
      console.log("\t\tprover:" + ev.prover);

      proofKey = ev.key; // workaround to get the proof key

      return ev;
    });
  });

  it("should mint KRS token", async () => {
    let tx = await verifier.mint(proofKey);

    truffleAssert.eventEmitted(tx, "TokenMinted", (ev) => {
      console.log("\tTokenMinted");
      console.log("\t\tto:" + ev.to);
      console.log("\t\tkey:" + ev.key);
      console.log("\t\ttokenId:" + ev.tokenId);

      return ev.key === proofKey;
    });
  });

  it("should *not* mint KRS token from invalid key", async () => {
    await truffleAssert.reverts(
      verifier.mint("0xffffff"),
      "KryptoRealStateZKP: solution key does not exist"
    );
  });
});
