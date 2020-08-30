const KryptoRealState = artifacts.require("KryptoRealState");
const SquareVerifier = artifacts.require("./SquareVerifier.sol");
const PreimageVerifier = artifacts.require("./PreimageVerifier.sol");
const ProofVerifierKRS = artifacts.require("./ProofVerifierKRS.sol");

module.exports = function (deployer) {
  deployer.then(async () => {
    await deployer.deploy(KryptoRealState);
    await deployer.deploy(SquareVerifier);
    await deployer.deploy(PreimageVerifier);

    await deployer.deploy(ProofVerifierKRS, SquareVerifier.address);
  });
};
