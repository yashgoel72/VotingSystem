# Voting System Smart Contract

This Solidity smart contract implements a decentralized voting system with key features for managing elections on the Ethereum blockchain.

## Features

1. **Voter Registration:**
   - Voters can register to participate in the voting process.

2. **Candidate Addition:**
   - The owner can add new candidates to the election.

3. **Vote Casting:**
   - Registered voters can cast their votes for specific candidates.

4. **Results Calculation:**
   - The contract calculates and stores the total votes cast.
   - It identifies the winning candidate with the highest vote count.

5. **Events Notification:**
   - Events are emitted to notify clients of key contract state changes.
     - `VoterRegistered` when a voter successfully registers.
     - `CandidateAdded` when a new candidate is added.
     - `VoteCasted` when a voter casts their vote.
     - `WinnerAnnounced` when the winner is determined.

## Development Tools

- **Foundry:** Used for Ethereum smart contract development.

  ## Static Analysis and Auditing

- **Slither:** Employed for automatic static analysis, gas optimization, and auditing of the smart contract.
  
- **Gas Optimization (@audit tags):**
  - Gas optimizations are annotated with `@audit` tags for better readability and understanding during code review.

## Deployment

## Contract Deployment

- The contract includes a constructor that initializes the owner.

```solidity
constructor() payable {
    owner = msg.sender;
}
