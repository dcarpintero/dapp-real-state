//var SquareVerifier = artifacts.require("./SquareVerifier.sol");
//var SolnSquareVerifier = artifacts.require("./SolnSquareVerifier.sol");

const KryptoRealState = artifacts.require("KryptoRealState");

module.exports = function (deployer) {
  deployer.deploy(KryptoRealState);

  //deployer.deploy(SquareVerifier);
  //deployer.deploy(SolnSquareVerifier);
};
