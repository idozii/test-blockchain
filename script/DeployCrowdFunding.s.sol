//SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {CrowdFunding} from "../src/CrowdFunding.sol";

contract DeployCrowdFunding is Script {
     CrowdFunding public crowdFunding;
     HelperConfig public helperConfig;
     function run() external returns(CrowdFunding, HelperConfig) {
          helperConfig = new HelperConfig();
          address ethUSDPriceFeed = helperConfig.getNetWorkConfig(block.chainid).ethUSDPriceFeed;
          vm.startBroadcast();
          crowdFunding = new CrowdFunding(ethUSDPriceFeed);
          vm.stopBroadcast();

          return (crowdFunding, helperConfig);
     }
}