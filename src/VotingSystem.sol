// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract VotingSystem {
    address public owner;

    // Struct to represent a candidate
    struct Candidate {
        string name;
        uint voteCount;
    }

    // Struct to represent a registered voter
    /** @audit Struct Packing:Efficient declaration of variables in struct allowing each struct to take upto two storage slots  */
    struct Voter {              
        bool hasVoted;
        bool isRegistered;
        uint votedCandidateId;
    }

    // Array to store candidate IDs
    uint[] public candidateIds;

    // Mapping to store candidates
    mapping(uint => Candidate) public candidates;
    // Mapping to store voters
    mapping(address => Voter) public voters;

    // Variable to store the total number of votes
    uint public totalVotes;

    // Variable to store the winner
    string public winnerName;
    uint public winnerVoteCount;
    // Events to notify clients of contract state changes
    event VoterRegistered(address indexed voterAddress);
    event CandidateAdded(uint indexed candidateId, string candidateName);
    event VoteCasted(address indexed voterAddress, uint indexed candidateId);
    event WinnerAnnounced(string winnerName , uint indexed winnerVoteCount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }
        /** @audit Constructors can be marked as payable to save deployment gas
Payable functions cost less gas to execute, because the compiler does not have to add extra checks to ensure that no payment is provided. A constructor can be safely marked as payable, because only the deployer would be able to pass funds, and the project itself would not pass any funds.
**/
    constructor() payable{
        owner = msg.sender;
    }

    /**
     * @dev Allows voters to register for voting.
     */
    function registerToVote() external {
        require(!voters[msg.sender].isRegistered, "You are already registered to vote");
        voters[msg.sender].isRegistered = true;

        emit VoterRegistered(msg.sender);
    }

    /**
     * @dev Allows the owner to add a new candidate.
     * @param _name The name of the candidate.
     */
    function addCandidate(string memory _name) external onlyOwner {
        uint candidateId = candidateIds.length + 1;

        candidates[candidateId] = Candidate({
            name: _name,
            voteCount: 0
        });
        candidateIds.push(candidateId);

        emit CandidateAdded(candidateId, _name);
    }

    /**
     * @dev Allows a registered voter to cast a vote for a specific candidate.
     * @param _candidateId The ID of the candidate to vote for.
     */
    function vote(uint _candidateId) external {
        require(voters[msg.sender].isRegistered, "You are not registered to vote");
        require(!voters[msg.sender].hasVoted, "You have already voted");
        require(candidates[_candidateId].voteCount < type(uint).max, "Vote count overflow");

        voters[msg.sender].hasVoted = true;
        voters[msg.sender].votedCandidateId = _candidateId;
        candidates[_candidateId].voteCount++;
        ++totalVotes;                                       // @audit pre-increment costs least gas
        emit VoteCasted(msg.sender, _candidateId);
    }

    /**
     * @dev Returns the count of registered candidates.
     * @return The number of registered candidates.
     */
    function getCandidateCount() external view returns (uint) {
        return candidateIds.length;
    }

    /**
     * @dev Returns the details of a specific candidate.
     * @param _candidateId The ID of the candidate.
     * @return The name and vote count of the candidate.
     */
    function getCandidate(uint _candidateId) external view returns (string memory, uint) {
        return (candidates[_candidateId].name, candidates[_candidateId].voteCount);
    }

    /**
     * @dev Returns the final results including the names and vote counts of all candidates.
     * @return Arrays containing candidate names and their corresponding vote counts.
     */
    function results() external onlyOwner returns(string memory , uint){
        uint candidateCount = candidateIds.length;
        uint _winnerVoteCount = 0;
        string memory _winnerName = "";

        for (uint i ; i < candidateCount; ++i) {            // @audit Optimized For loop
            uint candidateId = candidateIds[i];
            Candidate memory candidate = candidates[candidateId];
            if(_winnerVoteCount < candidate.voteCount)
            {
                _winnerName = candidate.name;
                _winnerVoteCount = candidate.voteCount;
            }
        }
        winnerName = _winnerName;
        winnerVoteCount = _winnerVoteCount;
        emit WinnerAnnounced(winnerName , winnerVoteCount);

        return (winnerName , winnerVoteCount);
    }

    function getWinner() public view returns(string memory , uint){
        return (winnerName , winnerVoteCount);
    }
}
