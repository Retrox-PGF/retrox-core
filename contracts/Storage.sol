// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Storage {

    uint256 constant tokensPerBadgeHolder = 100;
    uint256 constant minRoundCreationThreshold = 1;
    uint256 constant minNominationThreshold = 1; 
    uint256 constant minDisperseAmount = 1;

    enum RoundState {
        Nominations,
        Voting, 
        Disbursement, 
        Cancelled
    }

    struct Round {
        string roundURI;
        address[] badgeHolders;
        uint256 startBlockTimestamp;
        uint256 fundsCommitted;
        uint256 nominationCounter;
        uint256 totalVotes;
        uint256 nominationDuration;
        uint256 votingDuration;
        address votingStrategy;
    }

    struct Nomination {
        string nominationURI;
        address recipient;
        uint256 numVotes;
    }

    mapping(uint256 => Round) public rounds; 
    mapping(uint256 => mapping (uint256 => Nomination)) public nominations;
    mapping(uint256 => mapping (address => uint256)) public badgeHolderVoteStatus; //0 = inelligible, 1 = eligible, 2 = voted
    mapping(uint256  => uint256) public amounts;
    mapping(uint256 => uint256) public flowRates;
    mapping(address => mapping(uint256 => mapping(uint256 => uint256))) internal badgeHolderVotes;
    mapping(address => mapping(uint256 => uint256)) internal badgeHolderTokenAmounts;

    uint256 internal roundCounter;
 
}