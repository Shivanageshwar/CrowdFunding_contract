// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "Crowdfunding.sol";
import "forge-std/Test.sol";

contract Handler is Test {
    Crowdfunding public crowdfunding;

    address[] public users;

    constructor(Crowdfunding _crowdfunding) {
        crowdfunding = _crowdfunding;

        users.push(address(10));
        users.push(address(11));
        users.push(address(12));

        for (uint256 i = 0; i < users.length; i++) {
            vm.deal(users[i], 10 ether);
        }
    }

    function contribute(uint256 userIndex, uint256 amount) public {
        address user = users[userIndex % users.length];
        amount = bound(amount, 1 wei, 1 ether);

        if (block.timestamp >= crowdfunding.deadline()) return;

        vm.prank(user);
        crowdfunding.contribute{value: amount}();
    }

    function refund(uint256 userIndex) public {
        if (block.timestamp <= crowdfunding.deadline()) return;
        if (crowdfunding.totalRaised() >= crowdfunding.goal()) return;

        address user = users[userIndex % users.length];
        vm.prank(user);
        crowdfunding.refund();
    }

    function warpTime(uint256 time) public {
        vm.warp(block.timestamp + bound(time, 1, 30 days));
    }
}

