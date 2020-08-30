// SPDX-License-Identifier: MIT

pragma solidity 0.6.2;

import "./KryptoRealState.sol";
import "../zokrates/code/square/verifier.sol";

contract KryptoRealStateZKP is KryptoRealState {
    SquareVerifier private squareVerifier;

    struct Solution {
        bytes32 key;
        address prover;
        bool redeemed;
    }
    // Array with all solutions, used for enumeration
    Solution[] private _solutions;

    // Mapping from solution key to the position in the solutions array
    mapping(bytes32 => uint256) private _solutionsIndex;

    modifier onlyProver(bytes32 key) {
        require(
            _solution(key).prover == msg.sender,
            "KryptoRealStateZKP: only the prover can mint a token"
        );
        _;
    }

    event SolutionAdded(bytes32 key, address indexed prover);
    event TokenMinted(address to, bytes32 key, uint256 tokenId);

    constructor(address verifier) public KryptoRealState() {
        squareVerifier = SquareVerifier(verifier);
    }

    /**
     * @dev Submit a candidate solution for verification.
     */
    function submitSolution(
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
            "KryptoRealStateZKP: solution proof is *not* valid for the input"
        );

        _solutions.push(Solution(key, msg.sender, false));
        _solutionsIndex[key] = _solutions.length - 1;

        emit SolutionAdded(key, msg.sender);
    }

    /**
     * @dev Mints token.
     */
    function mintToken(bytes32 key) external onlyProver(key) {
        require(
            !(_solution(key).redeemed),
            "KryptoRealStateZKP: solution has been used already"
        );

        _redeemSolution(key);
        super.mint(msg.sender, uint256(key));
        emit TokenMinted(msg.sender, key, uint256(key));
    }

    function _solution(bytes32 key) internal view returns (Solution memory) {
        uint256 index = _solutionsIndex[key];
        return _solutions[index];
    }

    function _exists(bytes32 key) internal view returns (bool) {
        return _solutionsIndex[key] == 0;
    }

    function _redeemSolution(bytes32 key) internal {
        uint256 index = _solutionsIndex[key];
        _solutions[index].redeemed = true;
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
