const KryptoRealState = artifacts.require("KryptoRealState");
const truffleAssert = require("truffle-assertions");
const assert = require("chai").assert;

contract("KryptoRealState", (accounts) => {
  const tokenIDs = [00, 11, 22, 33, 44, 55, 66, 77, 88, 99];
  const contractOwner = accounts[0];
  const nonContractOwner = accounts[9];
  const from = accounts[1];
  const to = accounts[2];

  const TOKEN_NAME = "KryptoRealState";
  const TOKEN_SYMBOL = "KRS";
  const TOKEN_BASE_URI =
    "https://s3-us-west-2.amazonaws.com/udacity-blockchain/capstone/";

  before("setup contract", async () => {
    const contractOwner = accounts[0];
    const nonContractOwner = accounts[1];

    token = await KryptoRealState.deployed();

    for (let i = 0; i < tokenIDs.length; i++) {
      let tokenOwner = accounts[i];
      let tokenID = tokenIDs[i];

      await token.mint(tokenOwner, tokenID, {
        from: contractOwner,
      });
    }
  });

  describe("ERC721 specification", function () {
    describe("metadata", function () {
      it("has contract owner", async function () {
        assert.equal(await token.owner(), contractOwner);
      });

      it("has name", async function () {
        assert.equal(await token.name(), TOKEN_NAME);
      });

      it("has token symbol", async function () {
        assert.equal(await token.symbol(), TOKEN_SYMBOL);
      });

      it("has token base URI", async function () {
        assert.equal(await token.baseURI(), TOKEN_BASE_URI);
      });

      it("has token URI", async function () {
        assert.equal(
          await token.tokenURI(tokenIDs[1]),
          TOKEN_BASE_URI + tokenIDs[1]
        );
      });

      it("has token owner", async function () {
        for (let i = 0; i < tokenIDs.length; i++) {
          let tokenOwner = accounts[i];
          let tokenID = tokenIDs[i];

          assert.equal(await token.ownerOf(tokenID), tokenOwner);
        }
      });
    });

    describe("balanceOf & supply", function () {
      it("returns the total token supply", async function () {
        assert.equal(await token.totalSupply(), tokenIDs.length);
      });

      it("returns the amount of tokens owned by the given address", async function () {
        assert.equal(await token.balanceOf(accounts[1]), 1);
      });
    });

    describe("mint & transfer", function () {
      it("should not mint an already existent tokenId", async () => {
        await truffleAssert.reverts(
          token.mint(accounts[1], tokenIDs[1]),
          "ERC721: token already minted"
        );
      });

      it("should revert mint from *not* contract owner", async function () {
        await truffleAssert.reverts(
          token.mint(nonContractOwner, 111, {
            from: nonContractOwner,
          }),
          "Ownable: caller is not the owner"
        );
      });

      it("should transfer token ownership", async function () {
        let tokenId = tokenIDs[1];

        assert.equal(await token.ownerOf(tokenId), from);

        await token.safeTransferFrom(from, to, tokenIDs[1], {
          from: from,
        });

        assert.equal(await token.ownerOf(tokenId), to);
      });
    });
  });
});
