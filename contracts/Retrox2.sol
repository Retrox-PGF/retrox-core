// SPDX-License-Identifier: MIT


// import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "hardhat/console.sol";
import "./Storage.sol";

// initializing the CFA Library
pragma solidity ^0.8.0;

contract RetroxWithModules is Storage {

    function createRound(string memory roundURI, address[] memory badgeHolders, uint256 nominationDuration, uint256 votingDuration) public payable {
        //require(nominationDuration > 0, "Nomination period must be greater than zero");
        //require(votingDuration > 0, "Voting period must be greater than zero");
        require(msg.value >= minRoundCreationThreshold, "Insufficient funds to create a new round");
        rounds[roundCounter].roundURI = roundURI;
        rounds[roundCounter].badgeHolders = badgeHolders;
        rounds[roundCounter].startBlockTimestamp = block.timestamp;
        rounds[roundCounter].fundsCommitted = msg.value;
        rounds[roundCounter].nominationDuration = nominationDuration;
        rounds[roundCounter].votingDuration = votingDuration;

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
        rounds[roundCounter].fundsCommitted += msg.value;
        round.nominationCounter++;
    }

    function castVote(uint256 roundNum, uint256 nominationNum, uint256 tokenAllocation) public {
        address votingStrategy = rounds[roundNum].votingStrategy;
        (bool success,) = votingStrategy.delegatecall(abi.encodeWithSignature("vote(uint256, uint256, uint256)", roundNum, nominationNum, tokenAllocation));
        require(success, "Voting failed");
    }
}