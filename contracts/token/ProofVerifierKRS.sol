// SPDX-License-Identifier: MIT

pragma solidity 0.6.2;

import "./KryptoRealState.sol";
import "../zokrates/code/square/verifier.sol";

/**
 * @dev Contract module to mint KryptoRealState tokens. Sellers are
 * entitle to list their properties only upon presenting a valid
 * proof of ownership based on zk-SNARKs.
 *
 * Tokens are implemented as in the ERC721 standard.
 * see https://eips.ethereum.org/EIPS/eip-721
 */
contract ProofVerifierKRS is KryptoRealState {
    SquareVerifier private squareVerifier;

    struct Solution {
        bytes32 key;
        address prover;
        bool redeemable;
        bool exists;
    }
    // Array with all solutions, used for enumeration
    Solution[] private _solutions;

    // Mapping from solution key to the position in the solutions array
    mapping(bytes32 => uint256) private _solutionsIndex;

    event ProofVerified(bytes32 key, address indexed prover);
    event TokenMinted(address to, bytes32 key, uint256 tokenId);

    constructor(address verifier) public KryptoRealState() {
        squareVerifier = SquareVerifier(verifier);
    }

    /**
     * @dev Submit a candidate ownership-proof for validation.
     *
     * The proof consists on the points of the elliptic curve
     * corresponding to the input.
     */
    function submitOwnershipProof(
        uint256[2] calldata a,
        uint256[2][2] calldata b,
        uint256[2] calldata c,
        uint256[2] calldata input
    ) external {
        bytes32 key = keccak256(
            abi.encodePacked(
                a[0],
                a[1],
                b[0][0],
                b[0][1],
                b[1][0],
                b[1][1],
                c[0],
                c[1],
                input[0],
                input[1]
            )
        );
        require(!_exists(key), "KryptoRealStateZKP: solution exists already");

        require(
            _isValidProof(a, b, c, input),
            "KryptoRealStateZKP: solution proof is not valid for that input"
        );

        _solutions.push(Solution(key, msg.sender, true, true));
        _solutionsIndex[key] = _solutions.length - 1;

        emit ProofVerified(key, msg.sender);
    }

    /**
     * @dev Mints a new token if a prover has previously submitted a valid
     * proof of ownership.
     */
    function mint(bytes32 key) external {
        require(
            _exists(key),
            "KryptoRealStateZKP: solution key does not exist"
        );

        require(
            _redeemable(key),
            "KryptoRealStateZKP: solution key is not redeemable"
        );

        require(
            _solution(key).prover == msg.sender,
            "KryptoRealStateZKP: only the prover can mint a token"
        );

        _redeemSolution(key);
        super.mint(msg.sender, uint256(key));
        emit TokenMinted(msg.sender, key, uint256(key));
    }

    function _solution(bytes32 key) internal view returns (Solution memory) {
        uint256 index = _solutionsIndex[key];
        return _solutions[index];
    }

    function _redeemable(bytes32 key) internal view returns (bool) {
        if (_solutions.length == 0) {
            return false;
        }

        uint256 index = _solutionsIndex[key];
        return _solutions[index].redeemable && _solutions[index].key == key;
    }

    function _exists(bytes32 key) internal view returns (bool) {
        if (_solutions.length == 0) {
            return false;
        }

        uint256 index = _solutionsIndex[key];
        return _solutions[index].exists && _solutions[index].key == key;
    }

    function _redeemSolution(bytes32 key) internal {
        uint256 index = _solutionsIndex[key];
        _solutions[index].redeemable = false;
    }

    function _isValidProof(
        uint256[2] memory a,
        uint256[2][2] memory b,
        uint256[2] memory c,
        uint256[2] memory input
    ) internal view returns (bool) {
        return squareVerifier.verifyTx(a, b, c, input);
    }
}
