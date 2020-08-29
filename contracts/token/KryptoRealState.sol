// SPDX-License-Identifier: MIT

pragma solidity 0.6.2;

import "./ERC721Metadata.sol";

contract KryptoRealState is ERC721Metadata {
    constructor()
        public
        ERC721Metadata(
            "KryptoRealState",
            "KRS",
            "https://s3-us-west-2.amazonaws.com/udacity-blockchain/capstone/"
        )
    {}

    function mint(address to, uint256 tokenId)
        public
        onlyOwner
        whenNotPaused
        returns (bool)
    {
        super._mint(to, tokenId);
        _setTokenURI(tokenId);

        return true;
    }
}
