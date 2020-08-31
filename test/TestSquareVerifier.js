const Verifier = artifacts.require("SquareVerifier");
const square = require("../contracts/zokrates/code/square/proofs/proof_1.json");
const assert = require("chai").assert;

contract("SquareVerifier", (accounts) => {
  before(async () => {
    verifier = await Verifier.deployed();
  });

  it("should verify valid proof", async () => {
    assert.isTrue(
      await verifier.verifyTx(
        square.proof.a,
        square.proof.b,
        square.proof.c,
        square.inputs
      )
    );
  });

  it("should *not* verify invalid proof", async () => {
    assert.isFalse(
      await verifier.verifyTx(
        square.proof.a,
        square.proof.b,
        square.proof.a,
        square.inputs
      )
    );
  });

  it("should *not* verify invalid input", async () => {
    assert.isFalse(
      await verifier.verifyTx(square.proof.a, square.proof.b, square.proof.a, [
        0x00000000000000000000000000000000000000000000000000000000000000025,
        0x0000000000000000000000000000000000000000000000000000000000000005,
      ])
    );
  });
});
