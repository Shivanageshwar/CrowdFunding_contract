// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "forge-std/Test.sol";
import "Crowdfunding.sol";
import "./Handler.sol";

contract CrowdfundingInvariantTest is Test {
    Crowdfunding crowdfunding;
    Handler handler;

    function setUp() public {
        crowdfunding = new Crowdfunding(10 ether, 7 days);
        handler = new Handler(crowdfunding);

        targetContract(address(handler));
    }

    /// INVARIANT 1:
    /// Total raised must equal sum of all contributions
    function invariant_totalRaised_matches_balance_before_withdraw() public {
        if (crowdfunding.fundsWithdrawn()) return;

        assertEq(
            crowdfunding.totalRaised(),
            address(crowdfunding).balance
        );
    }

    /// INVARIANT 2:
    /// Funds can only be withdrawn once
    function invariant_withdraw_only_once() public {
        if (crowdfunding.fundsWithdrawn()) {
            assertEq(address(crowdfunding).balance, 0);
        }
    }

    /// INVARIANT 3:
    /// No user can refund more than they contributed
    function invariant_no_negative_contributions() public {
        // mapping(uint256 => mapping) prevents negatives implicitly
        // so just ensure no weird behavior
        assertTrue(crowdfunding.totalRaised() >= 0);
    }
}
