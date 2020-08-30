const Verifier = artifacts.require("ProofVerifierKRS");
const square = require("../contracts/zokrates/code/square/proof.json");
const assert = require("chai").assert;

contract("ProofVerifierKRS", (accounts) => {
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
      console.log(ev);
      return ev;
    });
  });

  it("should mint KRS token", async () => {
    let tx = await verifier.mint(key);

    truffleAssert.eventEmitted(tx, "TokenMinted", (ev) => {
      console.log(ev);
      return ev;
    });
  });
});
