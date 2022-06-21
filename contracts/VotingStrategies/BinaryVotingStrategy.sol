// SPDX-License-Identifier: MIT

import "./VotingStrategy.sol";

pragma solidity ^0.8.0;

contract BinaryVotingStrategy is VotingStrategy {
function vote(uint256 roundNum, uint256 nominationNum, uint256 tokenAllocation) external override {
        // 0 = abstain, 1 = yes, 2 = no
        require(badgeHolderVoteStatus[roundNum][msg.sender] == 1, "Not eligible to vote");
        require(tokenAllocation==1 || tokenAllocation==0 || tokenAllocation == 2, "Invalid Vote");
        Round storage round = rounds[roundNum];
        Nomination storage nomination = nominations[roundNum][nominationNum];
        if(badgeHolderVotes[msg.sender][roundNum][nominationNum] == 1 || badgeHolderVotes[msg.sender][roundNum][nominationNum] == 2) {
            nomination.numVotes -= 1;
            round.totalVotes -= 1;
        }
        badgeHolderVotes[msg.sender][roundNum][nominationNum] = tokenAllocation;
        round.totalVotes += tokenAllocation < 2 ? 1 : 0;
        nomination.numVotes += tokenAllocation < 2 ? 1 : 0;
    }
}
