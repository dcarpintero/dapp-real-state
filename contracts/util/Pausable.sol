// SPDX-License-Identifier: MIT

pragma solidity 0.6.2;

import "./Ownable.sol";

/**
 * @dev Contract module which allows to implement an emergency stop.
 *
 * This module is used through inheritance. It will make available the
 * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
 * the functions of a contract.
 */
contract Pausable is Ownable {
    bool private _paused;

    /**
     * @dev Makes a function callable only when the contract is not paused.
     */
    modifier whenNotPaused() {
        require(!_paused, "Pausable: expected 'not paused' status");
        _;
    }

    /**
     * @dev Makes a function callable only when the contract is paused.
     */
    modifier whenPaused() {
        require(_paused, "Pausable: expected 'paused' status");
        _;
    }

    /**
     * @dev Emitted when pause is triggered by `account`.
     */
    event Paused(address account);

    /**
     * @dev Emitted when pause is lifted by `account`.
     */
    event Resumed(address account);

    /**
     * @dev Initializes the contract in operational state.
     */
    constructor() internal {
        _paused = false;
    }

    /**
     * @dev Returns true if the contract is paused.
     */
    function isPaused() public view returns (bool) {
        return _paused;
    }

    /**
     * @dev Stops operational state.
     */
    function pause() public virtual whenNotPaused onlyOwner {
        _paused = true;
        emit Paused(msg.sender);
    }

    /**
     * @dev Resumes operational state.
     */
    function resume() public virtual whenPaused onlyOwner {
        _paused = false;
        emit Resumed(msg.sender);
    }
}
