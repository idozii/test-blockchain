// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {DeployCrowdFunding} from "../script/DeployCrowdFunding.s.sol"; 
import {CrowdFunding} from "../src/CrowdFunding.sol";
import {FundCrowdFunding} from "../script/Interactions.s.sol";

contract InteractionTest is Test {
     CrowdFunding public crowdFunding;
     FundCrowdFunding public _fundCrowdFunding;

     function setUp() external {
          DeployCrowdFunding deployCrowdFunding = new DeployCrowdFunding();
          (crowdFunding, ) = deployCrowdFunding.run();
          _fundCrowdFunding = new FundCrowdFunding();
     }

     function test_can_fundAndWithdraw() public {
          _fundCrowdFunding.fundToCrowdfunding(address(crowdFunding));
     }
}