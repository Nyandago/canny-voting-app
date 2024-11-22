// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    address public admin;
    mapping(address => bool) public voters;
    mapping(uint => Candidate) public candidates;
    uint public candidatesCount;
    uint public totalVotes;

    uint[] public candidateIds;  // Array to store candidate IDs for listing

    constructor() {
        admin = msg.sender;
    }

    // Add a new candidate
    function addCandidate(string memory name) public {
        require(msg.sender == admin, "Only admin can add candidates");
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, name, 0);
        candidateIds.push(candidatesCount);  // Add the new candidate ID to the array
    }

    // Vote for a candidate
    function vote(uint candidateId) public {
        require(!voters[msg.sender], "You have already voted.");
        require(candidateId > 0 && candidateId <= candidatesCount, "Invalid candidate.");

        voters[msg.sender] = true;
        candidates[candidateId].voteCount++;
        totalVotes++;
    }

    // Get the results of the voting
    function getResults() public view returns (string memory, uint) {
        uint winningVoteCount = 0;
        uint winningCandidateId;

        for (uint i = 1; i <= candidatesCount; i++) {
            if (candidates[i].voteCount > winningVoteCount) {
                winningVoteCount = candidates[i].voteCount;
                winningCandidateId = i;
            }
        }

        return (candidates[winningCandidateId].name, winningVoteCount);
    }

    // List all added candidates
    function listCandidates() public view returns (Candidate[] memory) {
        Candidate[] memory allCandidates = new Candidate[](candidateIds.length);
        
        for (uint i = 0; i < candidateIds.length; i++) {
            allCandidates[i] = candidates[candidateIds[i]];
        }

        return allCandidates;
    }
}