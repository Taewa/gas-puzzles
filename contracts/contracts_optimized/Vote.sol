// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.15;

contract OptimizedVote {
    struct Voter {
        uint8 vote;
        bool voted;
    }

    // Solution: Order of struct matters.
    // This only works with Struct. Function arguments use memory which does not work in this way. 
    struct Proposal {
        bytes32 name;
        uint8 voteCount;
        bool ended;
    }

    mapping(address => Voter) internal voters;

    Proposal[] internal proposals;

    function createProposal(bytes32 _name) external {
        proposals.push(Proposal({voteCount: 0, name: _name, ended: false}));
    }

    function vote(uint8 _proposal) external {
        require(!voters[msg.sender].voted, 'already voted');
        voters[msg.sender].vote = _proposal;
        voters[msg.sender].voted = true;

        // TODO: according to here: https://betterprogramming.pub/the-ultimate-100-point-checklist-before-sending-your-smart-contract-for-audit-af9a5b5d95d0
        // Prefer x = x + y over x += y
        // but why when I applied, why it consumes more gas?
        // proposals[_proposal].voteCount += 1;
        unchecked {
            proposals[_proposal].voteCount++;    
        }
    }

    function getVoteCount(uint8 _proposal) external view returns (uint8) {
        return proposals[_proposal].voteCount;
    }
}
