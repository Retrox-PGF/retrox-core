// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./Storage.sol";

interface VotingStrategy {
    function vote(uint256 roundNum, uint256 nominationNum, uint256 tokenAllocation) external;
}

interface DispersalStrategy { 
    function disperse(uint256 roundNum) external;
}

contract Retrox2 is Storage {
    function createRound(string memory roundURI, address votingStrategy, address dispersalStrategy, address[] memory badgeHolders, uint256 nominationDuration, uint256 votingDuration) public payable {
        //require(nominationDuration > 0, "Nomination period must be greater than zero");
        //require(votingDuration > 0, "Voting period must be greater than zero");
        require(msg.value >= minRoundCreationThreshold, "Insufficient funds to create a new round");
        rounds[roundCounter].roundURI = roundURI;
        rounds[roundCounter].badgeHolders = badgeHolders;
        rounds[roundCounter].startBlockTimestamp = block.timestamp;
        rounds[roundCounter].fundsCommitted = msg.value;
        rounds[roundCounter].nominationDuration = nominationDuration;
        rounds[roundCounter].votingDuration = votingDuration;
        rounds[roundCounter].votingStrategy = votingStrategy;
        rounds[roundCounter].dispersalStrategy = dispersalStrategy;
        for (uint256 i = 0; i < badgeHolders.length; i++) {
            badgeHolderVoteStatus[roundCounter][badgeHolders[i]] = 1;
        }
        roundCounter++;
    }

    function nominate(uint256 roundNum, string memory nominationURI, address recipient) public payable {
        require(msg.value >= minNominationThreshold, "Insufficient funds to nominate");
        //require((block.timestamp - rounds[roundNum].startBlockTimestamp) <= rounds[roundNum].nominationDuration, "Nomination period finished");
        Round storage round = rounds[roundNum];
        nominations[roundNum][round.nominationCounter].nominationURI = nominationURI;
        nominations[roundNum][round.nominationCounter].recipient = recipient;
        rounds[roundNum].fundsCommitted += msg.value;
        round.nominationCounter++;
    }

    function castVotes(uint256 roundNum, uint256[] memory tokenAllocations) public {
        for(uint256 i=0; i<tokenAllocations.length; i++) {
            castVote(roundNum, i, tokenAllocations[i]);
        }
    }

    function castVote(uint256 roundNum, uint256 nominationNum, uint256 tokenAllocation) public {
        address votingStrategy = rounds[roundNum].votingStrategy;
        require(isContract(votingStrategy), "Voting strategy is not a contract");
        (bool success,) = votingStrategy.delegatecall(abi.encodeWithSelector(VotingStrategy.vote.selector, roundNum, nominationNum, tokenAllocation));
        require(success, "Voting failed");
    }

    function disperseFunds(uint roundNum) public {
        address dispersalStrategy = rounds[roundNum].dispersalStrategy;
        require(isContract(dispersalStrategy), "Dispersal strategy is not a contract");
        (bool success,) = dispersalStrategy.delegatecall(abi.encodeWithSelector(DispersalStrategy.disperse.selector, roundNum));
        require(success, "Dispersal failed");
    }

    function getNextRoundNum() public view returns (uint256) {
        return roundCounter;
    }

    function getRoundData(uint256 roundNum) public view returns (Round memory round) {
        return rounds[roundNum];
    }

    function getNominationData(uint256 roundNum, uint256 nominationNum) public view returns (Nomination memory nomination) {
        return nominations[roundNum][nominationNum];
    }

    function isContract(address _address) internal view returns (bool) {
        uint256 size;
        assembly { size := extcodesize(_address) }
        return size > 0;
    }
}