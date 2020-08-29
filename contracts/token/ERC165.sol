// SPDX-License-Identifier: MIT

pragma solidity 0.6.2;

/**
 * @dev Contract module of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * This module is used through inheritance. It will make available the
 * function `supportsInterface`. Derived contracts need only to register
 * support for their own interfaces.
 */
contract ERC165 {
    /*
     * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
     */
    bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;

    /**
     * @dev a mapping of interface id to whether or not it is supported
     */
    mapping(bytes4 => bool) private _supportedInterfaces;

    /**
     * @dev Initializes the contract registering ERC165 interface ID.
     */
    constructor() internal {
        _registerInterface(_INTERFACE_ID_ERC165);
    }

    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section].
     *
     * Time complexity O(1), guaranteed to always use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId)
        external
        view
        returns (bool)
    {
        return _supportedInterfaces[interfaceId];
    }

    /**
     * @dev registers the contract as an implementer of the interface defined by
     * `interfaceId`. Support of the actual ERC165 interface is automatic and
     * registering its interface ID is not required.
     */
    function _registerInterface(bytes4 interfaceId) internal {
        require(interfaceId != 0xffffffff, "ERC165: invalid interface ID");
        _supportedInterfaces[interfaceId] = true;
    }
}
