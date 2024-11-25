// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {DeployCrowdFunding} from "../script/DeployCrowdFunding.s.sol"; 
import {CrowdFunding} from "../src/CrowdFunding.sol";
import {WithDrawFunding} from "../script/Interactions.s.sol";

contract InteractionTest is Test {
     CrowdFunding public crowdFunding;
     WithDrawFunding public _fundCrowdFunding;

     address public constant USER = address(0);
     uint256 public constant INIT_BALANCE = 100 ether;
     uint256 public constant AMOUNT = 5 ether;

     function setUp() external {
          DeployCrowdFunding deployCrowdFunding = new DeployCrowdFunding();
          (crowdFunding, ) = deployCrowdFunding.run();
          _fundCrowdFunding = new WithDrawFunding();
          vm.deal(USER, INIT_BALANCE);
     }

     function test_can_fundAndWithdraw() public {
          address owner = crowdFunding.owner();
          uint256 beforeUserBalance = USER.balance;
          uint256 beforeOwnerBalance = owner.balance;

          vm.prank(USER);
          crowdFunding.fund{value: AMOUNT}();

          _fundCrowdFunding.withdrawFromCrowdfunding(address(crowdFunding));

          uint256 afterUserBalance = USER.balance;
          uint256 afterOwnerBalance = owner.balance;

          assertEq(beforeUserBalance - AMOUNT, afterUserBalance);
          assertEq(beforeOwnerBalance + AMOUNT, afterOwnerBalance);
          assertEq(address(crowdFunding).balance, 0);
     }
}