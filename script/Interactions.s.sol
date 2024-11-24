//SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "../lib/foundry-devops/src/DevOpsTools.sol";
import {CrowdFunding} from "../src/CrowdFunding.sol";

contract FundCrowdFunding is Script {
     function fundToCrowdfunding(address crowdFunding) public {
          vm.startBroadcast();
          CrowdFunding(payable(crowdFunding)).fund{value: 0.1 ether}();
          vm.stopBroadcast();

          console.log("Funded to CrowdFunding");
     }

     function run() external {
          address contractAddress = DevOpsTools.get_most_recent_deployment("CrowdFunding", block.chainid);
          fundToCrowdfunding(contractAddress);
     }
}

contract WithDrawFunding is Script {
     function withdrawFromCrowdfunding(address crowdFunding) public {
          vm.startBroadcast();
          CrowdFunding(payable(crowdFunding)).withdraw();
          vm.stopBroadcast();

          console.log("Withdraw from CrowdFunding");
     }

     function run() external {
          address contractAddress = DevOpsTools.get_most_recent_deployment("CrowdFunding", block.chainid);
          withdrawFromCrowdfunding(contractAddress);
     }
}