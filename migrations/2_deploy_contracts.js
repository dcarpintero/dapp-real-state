//var SolnSquareVerifier = artifacts.require("./SolnSquareVerifier.sol");

const KryptoRealState = artifacts.require("KryptoRealState");
const SquareVerifier = artifacts.require("./SquareVerifier.sol");
const PreimageVerifier = artifacts.require("./PreimageVerifier.sol");

module.exports = function (deployer) {
  deployer.deploy(KryptoRealState);
  deployer.deploy(SquareVerifier);
  deployer.deploy(PreimageVerifier);

  //deployer.deploy(SolnSquareVerifier);
};
