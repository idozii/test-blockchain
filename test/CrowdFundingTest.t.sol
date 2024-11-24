// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {CrowdFunding} from "../src/CrowdFunding.sol";
import {DeployCrowdFunding} from "../script/DeployCrowdFunding.s.sol"; 
import {Ownable} from "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract CrowdFundingTest is Test {
    CrowdFunding public crowdFunding;
    address public ethPriceFeed;

    address public constant OWNER = address(1);
    uint256 public constant INITIAL_BALANCE = 100 ether;
    uint256 public constant AMOUNT_TO_FUND = 5 ether;

    event Funded(address indexed funder, uint256 value);
    event Withdrawn(uint256 value);

    function setUp() external {
        DeployCrowdFunding deployCrowdFunding = new DeployCrowdFunding();
        (crowdFunding, ) = deployCrowdFunding.run();
        vm.deal(OWNER, INITIAL_BALANCE);
    }

    modifier funded () {
        vm.prank(OWNER);
        crowdFunding.fund{value: AMOUNT_TO_FUND}();
        _;
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

    function test_revert_withdraw() public {
        vm.expectRevert(abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, OWNER));
        vm.prank(OWNER);
        crowdFunding.withdraw();
    }
    
    function test_can_withdraw() public funded {
        address owner = crowdFunding.owner();

        uint256 BeforeOwnerBalance = owner.balance;
        uint256 BeforeContractBalance = address(crowdFunding).balance;

        vm.expectEmit();
        emit CrowdFunding.Withdrawn(BeforeContractBalance);
        vm.prank(owner);
        crowdFunding.withdraw();

        uint256 AfterOwnerBalance = owner.balance;
        uint256 AfterContractBalance = address(crowdFunding).balance;

        assertEq(BeforeContractBalance + BeforeOwnerBalance, AfterOwnerBalance);
        assertEq(AfterContractBalance, 0);
    }
}
