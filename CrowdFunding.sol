// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract Crowdfunding {
    address public immutable creator;
    uint256 public immutable goal;
    uint256 public immutable deadline;

    uint256 public totalRaised;
    bool public fundsWithdrawn;

    mapping(address => uint256) public contributions;

    event Contributed(address indexed contributor, uint256 amount);
    event FundsWithdrawn(uint256 amount);
    event Refunded(address indexed contributor, uint256 amount);

    error CampaignEnded();
    error NotCreator();
    error NotEndedYet();
    error GoalNotReached();
    error AlreadyWithdrawn();
    error GoalReached();

    constructor(uint256 _goal, uint256 _duration) {
        creator = msg.sender;
        goal = _goal;
        deadline = block.timestamp + _duration;
    }

    function contribute() external payable {
        if (block.timestamp >= deadline) revert CampaignEnded();
        contributions[msg.sender] += msg.value;
        unchecked {
            totalRaised += msg.value;
        }
        emit Contributed(msg.sender, msg.value);
    }

    function withdrawFunds() external {
        if (msg.sender != creator) revert NotCreator();
        if (block.timestamp <= deadline) revert NotEndedYet();
        if (totalRaised < goal) revert GoalNotReached();
        if (fundsWithdrawn) revert AlreadyWithdrawn();

        fundsWithdrawn = true;
        uint256 amount = address(this).balance;
        payable(creator).transfer(amount);

        emit FundsWithdrawn(amount);
    }

    function refund() external {
        if (block.timestamp <= deadline) revert NotEndedYet();
        if (totalRaised >= goal) revert GoalReached();

        uint256 amount = contributions[msg.sender];
        contributions[msg.sender] = 0;
        payable(msg.sender).transfer(amount);

        emit Refunded(msg.sender, amount);
    }
}

