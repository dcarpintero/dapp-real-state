const Verifier = artifacts.require("PreimageVerifier");
const preimage = require("../contracts/zokrates/code/preimage/proof.json");
const assert = require("chai").assert;

contract("PreimageVerifier", (accounts) => {
  before(async () => {
    verifier = await Verifier.deployed();
  });

  it("should verify valid proof", async () => {
    assert.isTrue(
      await verifier.verifyTx(
        preimage.proof.a,
        preimage.proof.b,
        preimage.proof.c
      )
    );
  });

  it("should *not* verify invalid proof", async () => {
    assert.isFalse(
      await verifier.verifyTx(
        preimage.proof.a,
        preimage.proof.b,
        preimage.proof.a
      )
    );
  });
});
