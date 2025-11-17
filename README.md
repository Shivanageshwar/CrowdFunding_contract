# Crowdfunding Smart Contract (Solidity)

This contract implements a simple crowdfunding mechanism where contributors send ETH during a campaign.  
If the goal is reached, the creator can withdraw the raised funds.  
If the goal is not reached by the deadline, contributors can claim refunds.

This contract is focused on clarity, gas efficiency, and safety.

---

## Features

- Supports contributions until the deadline.
- Tracks total amount raised and per-user contributions.
- Creator can withdraw funds only if the goal is reached.
- Users can claim refunds if the campaign fails.
- Uses custom errors for gas optimization.
- Emits events for contributions, withdrawals, and refunds.

---

## Variables

- creator: Address of the campaign creator.
- goal: Target amount required for success.
- deadline: Timestamp when the campaign ends.
- totalRaised: Total ETH raised.
- contributions: Mapping of contributor address to amount.
- fundsWithdrawn: Prevents double withdrawal.

---

## Functions

### contribute()
Allows anyone to send ETH while the campaign is active.  
Updates contribution balance and totalRaised.

### withdrawFunds()
Allows the creator to withdraw all ETH only if:
- Campaign ended.
- Goal reached.
- Funds not withdrawn before.

### refund()
Allows contributors to claim back their contributions if:
- Campaign ended.
- Goal not reached.

---

## Contract Code

(See the contracts folder for the full optimized Crowdfunding.sol implementation.)

---

## Notes and Limitations

- This contract uses block timestamps, which are approximate and not guaranteed to be exact.
- It does not prevent the campaign creator from contributing.
- It does not support partial withdrawals or milestones.
- This contract is intended for educational and demonstration purposes.

---

