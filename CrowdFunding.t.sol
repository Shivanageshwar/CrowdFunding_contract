// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "forge-std/Test.sol";
import "Crowdfunding.sol";

contract CrowdfundingTest is Test {
    Crowdfunding crowdfunding;

    address creator = address(1);
    address alice = address(2);
    address bob = address(3);

    uint256 constant GOAL = 10 ether;
    uint256 constant DURATION = 7 days;

    function setUp() public {
        vm.prank(creator);
        crowdfunding = new Crowdfunding(GOAL, DURATION);

        vm.deal(alice, 10 ether);
        vm.deal(bob, 10 ether);
    }

    function test_contribute_increases_totalRaised() public {
        vm.prank(alice);
        crowdfunding.contribute{value: 3 ether}();

        assertEq(crowdfunding.totalRaised(), 3 ether);
        assertEq(crowdfunding.contributions(alice), 3 ether);
    }

    function test_cannot_contribute_after_deadline() public {
        vm.warp(block.timestamp + DURATION + 1);

        vm.expectRevert(Crowdfunding.CampaignEnded.selector);
        vm.prank(alice);
        crowdfunding.contribute{value: 1 ether}();
    }

    function test_creator_can_withdraw_after_goal_reached() public {
        vm.prank(alice);
        crowdfunding.contribute{value: 6 ether}();

        vm.prank(bob);
        crowdfunding.contribute{value: 4 ether}();

        vm.warp(block.timestamp + DURATION + 1);

        uint256 creatorBalanceBefore = creator.balance;

        vm.prank(creator);
        crowdfunding.withdrawFunds();

        assertTrue(crowdfunding.fundsWithdrawn());
        assertEq(creator.balance, creatorBalanceBefore + GOAL);
    }

    function test_refund_if_goal_not_reached() public {
        vm.prank(alice);
        crowdfunding.contribute{value: 2 ether}();

        vm.warp(block.timestamp + DURATION + 1);

        uint256 balanceBefore = alice.balance;

        vm.prank(alice);
        crowdfunding.refund();

        assertEq(alice.balance, balanceBefore + 2 ether);
        assertEq(crowdfunding.contributions(alice), 0);
    }

    function test_cannot_refund_if_goal_reached() public {
        vm.prank(alice);
        crowdfunding.contribute{value: GOAL}();

        vm.warp(block.timestamp + DURATION + 1);

        vm.expectRevert(Crowdfunding.GoalReached.selector);
        vm.prank(alice);
        crowdfunding.refund();
    }
}
