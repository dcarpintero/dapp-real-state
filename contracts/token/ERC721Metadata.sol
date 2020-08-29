// SPDX-License-Identifier: MIT

pragma solidity 0.6.2;

import "@openzeppelin/contracts/utils/Strings.sol";
import "./ERC165.sol";
import "./ERC721Enumerable.sol";

contract ERC721Metadata is ERC165, ERC721Enumerable {
    string private _name;
    string private _symbol;
    string private _baseURI;

    // mapping Token ID => Token URI
    mapping(uint256 => string) private _tokenURIs;

    /*
     *     bytes4(keccak256('name()')) == 0x06fdde03
     *     bytes4(keccak256('symbol()')) == 0x95d89b41
     *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
     *
     *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
     */
    bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;

    constructor(
        string memory name,
        string memory symbol,
        string memory baseURI
    ) public {
        _name = name;
        _symbol = symbol;
        _baseURI = baseURI;

        _registerInterface(_INTERFACE_ID_ERC721_METADATA);
    }

    /**
     * @dev Returns the token name.
     */
    function name() external view returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the token symbol.
     */
    function symbol() external view returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the base URI set via {_setBaseURI}.
     */
    function baseURI() external view returns (string memory) {
        return _baseURI;
    }

    /**
     * @dev Returns an URI for a given token ID
     * Throws if the token ID does not exist. It may return an empty string.
     * @param tokenId uint256 ID of the token to query
     */
    function tokenURI(uint256 tokenId) external view returns (string memory) {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        return _tokenURIs[tokenId];
    }

    /**
     * @dev Sets `_tokenURI` for `tokenId`.
     */
    function _setTokenURI(uint256 tokenId) internal virtual {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI set of nonexistent token"
        );
        _tokenURIs[tokenId] = string(
            abi.encodePacked(_baseURI, Strings.toString(tokenId))
        );
    }

    /**
     * @dev Internal function to set the base URI for all token IDs. It is
     * automatically added as a prefix to the value returned in {tokenURI},
     * or to the token ID if {tokenURI} is empty.
     */
    function _setBaseURI(string memory baseURI_) internal virtual {
        _baseURI = baseURI_;
    }
}
