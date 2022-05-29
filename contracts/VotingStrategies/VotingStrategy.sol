// SPDX-License-Identifier: MIT

import "../Storage.sol";

pragma solidity ^0.8.0;

abstract contract VotingStrategy is Storage {
    
    function vote(uint256 roundNum, uint256 nominationNum, uint256 tokenAllocation) public virtual;

}
