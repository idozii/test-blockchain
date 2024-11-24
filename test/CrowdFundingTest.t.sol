// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {CrowdFunding} from "../src/CrowdFunding.sol";
import {MockV3Aggregator} from "@chainlink/contracts/src/v0.8/tests/MockV3Aggregator.sol";

contract CrowdFundingTest is Test {
    CrowdFunding public crowdFunding;
    address public ethPriceFeed;

    address public constant OWNER = address(1);
    uint256 public constant INITIAL_BALANCE = 100 ether;
    uint256 public constant AMOUNT_TO_FUND = 5 ether;
    uint8 public constant DECIMALS = 8;
    int256 public constant PRICE = 3000e8;

    event Funded(address indexed funder, uint256 value);

    function setUp() external {
        MockV3Aggregator mockV3Aggregator = new MockV3Aggregator(DECIMALS, PRICE);
        ethPriceFeed = address(mockV3Aggregator);
        crowdFunding = new CrowdFunding(ethPriceFeed);
        vm.deal(OWNER, INITIAL_BALANCE);
    }

    function test_getETHUSDPrice() public view {
        uint256 price = crowdFunding.getETHUSdPrice();
        assertEq(price, uint256(PRICE) * 1e10);
    }
    
    function test_revert_fund() public {
        vm.expectRevert("no available amount");
        vm.prank(OWNER);
        crowdFunding.fund();    
    }

    function test_can_fund() public {
        uint256 BeforeuserBalance = OWNER.balance;
        uint256 BeforecontractBalance = address(crowdFunding).balance;

        vm.expectEmit();
        emit CrowdFunding.Funded(OWNER, AMOUNT_TO_FUND);
        vm.prank(OWNER);
        crowdFunding.fund{value: AMOUNT_TO_FUND}();

        uint256 AfteruserBalance = OWNER.balance;
        uint256 AftercontractBalance = address(crowdFunding).balance;

        assertEq(BeforeuserBalance - AMOUNT_TO_FUND, AfteruserBalance);
        assertEq(BeforecontractBalance + AMOUNT_TO_FUND, AftercontractBalance);
        assertEq(crowdFunding.s_funderToAmount(OWNER), AMOUNT_TO_FUND);
        assertTrue(crowdFunding.s_isFunders(OWNER));
        assertEq(crowdFunding.s_funders(0), OWNER);
        assertEq(crowdFunding.getFundersLength(), 1);
    }
}
