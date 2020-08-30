const KryptoRealState = artifacts.require("KryptoRealState");
const assert = require("chai").assert;
const expect = require("chai").expect;
const truffleAssert = require("truffle-assertions");

contract("Pausable", (accounts) => {
  const contractOwner = accounts[0];

  before("setup contract", async () => {
    token = await KryptoRealState.deployed();
  });

  describe("Pausable", function () {
    describe("operational status", function () {
      it("should reject mint operation if paused", async function () {
        await token.pause();
        await truffleAssert.reverts(
          token.mint(contractOwner, 111, {
            from: contractOwner,
          }),
          "Pausable: expected 'not paused' status"
        );
      });
    });
  });
});
