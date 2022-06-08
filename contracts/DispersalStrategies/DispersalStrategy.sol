// SPDX-License-Identifier: MIT

import "../Storage.sol";

pragma solidity ^0.8.0;

abstract contract DispersalStrategy is Storage {
    function disperse(uint256 roundNum) external virtual;
}