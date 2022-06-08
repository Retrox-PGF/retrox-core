// SPDX-License-Identifier: MIT

import "./DispersalStrategy.sol";

pragma solidity ^0.8.0;

contract RetroactiveDispersalStrategy is DispersalStrategy {
    function disperse(uint roundNum) external override {
        require((block.timestamp - rounds[roundNum].startBlockTimestamp) > (rounds[roundNum].nominationDuration + rounds[roundNum].votingDuration), 'Only disperse the funds after round is completed');
        uint totalNumVotes = rounds[roundNum].totalVotes;
        for(uint i=0; i < rounds[roundNum].nominationCounter; i++){
            uint256 amount = (nominations[roundNum][i].numVotes * rounds[roundNum].fundsCommitted)/totalNumVotes;
            amounts[i] = amount;
            if(amount > minDisperseAmount) {
                (bool sent,) = nominations[roundNum][i].recipient.call{value: amount}("");
                require(sent, 'Failed to send');
            }
        }
    }
}