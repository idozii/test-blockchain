//SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "@chainlink/contracts/src/v0.8/tests/MockV3Aggregator.sol";
import {Constant} from "./Constant.sol";

contract HelperConfig is Constant, Script {
error HelperConfig__InvalidChainID();
     struct NetWorkConfig {
          address ethUSDPriceFeed;
     }

     NetWorkConfig public localNetWorkConfig;
     mapping(uint256 chainID => NetWorkConfig) public s_networkConfig;
     
     constructor() {
          s_networkConfig[sepoliaID] = getSepoliaNetWorkConfig();
     }

     function getSepoliaNetWorkConfig() public pure returns(NetWorkConfig memory) {
          return NetWorkConfig({
               ethUSDPriceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
          });
     }

     function getAnvilNetWorkConfig() public returns(NetWorkConfig memory) {
          vm.startBroadcast();
          MockV3Aggregator mockV3Aggregator = new MockV3Aggregator(DECIMALS, PRICE);
          vm.stopBroadcast();
          localNetWorkConfig = NetWorkConfig({
               ethUSDPriceFeed: address(mockV3Aggregator)
          });
          return localNetWorkConfig;
     }

     function getNetWorkConfig(uint256 chainID) public returns(NetWorkConfig memory) {
          if(s_networkConfig[chainID].ethUSDPriceFeed != address(0)) {
               return s_networkConfig[chainID];
          } else if (chainID == anvilID) {
               return getAnvilNetWorkConfig();     
          } else {
               revert HelperConfig__InvalidChainID();
          }
     }
}