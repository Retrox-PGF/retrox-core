// SPDX-License-Identifier: MIT

import "./VotingStrategy.sol";

pragma solidity ^0.8.0;

contract BinaryVotingStrategy is VotingStrategy {
    function vote(uint256 roundNum, uint256 nominationNum, uint256 tokenAllocation) external override {
        require(badgeHolderVoteStatus[roundNum][msg.sender] == 1, "Not eligible to vote");
        require(tokenAllocation==1 || tokenAllocation==0, "Invalid Vote");
        Round storage round = rounds[roundNum];
        Nomination storage nomination = nominations[roundNum][nominationNum];
        if(badgeHolderVotes[msg.sender][roundNum][nominationNum] == 1) {
            nomination.numVotes -= 1;
            round.totalVotes -= 1;
            badgeHolderTokenAmounts[msg.sender][roundNum] -= 1;
        }
        badgeHolderVotes[msg.sender][roundNum][nominationNum] = tokenAllocation;
        round.totalVotes += 1;
        nomination.numVotes += 1;
        badgeHolderTokenAmounts[msg.sender][roundNum] += tokenAllocation;
    }
}
