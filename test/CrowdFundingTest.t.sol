// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {CrowdFunding} from "../src/CrowdFunding.sol";

contract CrowdFundingTest is Test {
    CrowdFunding public crowdFunding;

    address public constant OWNER = address(1);
    uint256 public constant INITIAL_BALANCE = 100 ether;
    uint256 public constant AMOUNT_TO_FUND = 5 ether;

    function setUp() external {
        crowdFunding = new CrowdFunding();
        vm.deal(OWNER, INITIAL_BALANCE);
    }

    function test_can_fund() public {
        uint256 BeforeuserBalance = OWNER.balance;
        uint256 BeforecontractBalance = address(crowdFunding).balance;

        vm.prank(OWNER);
        crowdFunding.fund{value: AMOUNT_TO_FUND}();

        uint256 AfteruserBalance = OWNER.balance;
        uint256 AftercontractBalance = address(crowdFunding).balance;

        assertEq(BeforeuserBalance - AMOUNT_TO_FUND, AfteruserBalance);
        assertEq(BeforecontractBalance + AMOUNT_TO_FUND, AftercontractBalance);
        assertEq(crowdFunding.s_funderToAmount(OWNER), AMOUNT_TO_FUND);
    }
}
