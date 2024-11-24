//SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "@chainlink/contracts/src/v0.8/tests/MockV3Aggregator.sol";
import {Constant} from "./Constant.sol";

contract HelperConfig is Constant, Script {

     struct NetWorkConfig {
          address ethUSDPriceFeed;
     }

     mapping(uint256 chainID => NetWorkConfig) public s_networkConfig;
     
     constructor() {
          s_networkConfig[sepoliaID] = getSepoliaNetWorkConfig();
          s_networkConfig[anvilID] = getAnvilNetWorkConfig();
     }

     function getSepoliaNetWorkConfig() public pure returns(NetWorkConfig memory) {
          return NetWorkConfig({
               ethUSDPriceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
          });
     }

     function getAnvilNetWorkConfig() public returns(NetWorkConfig memory) {
          MockV3Aggregator mockV3Aggregator = new MockV3Aggregator(DECIMALS, PRICE);
          return NetWorkConfig({
               ethUSDPriceFeed: address(mockV3Aggregator)
          });
     }

     function getNetWorkConfig(uint256 chainID) public view returns(NetWorkConfig memory) {
          return s_networkConfig[chainID];
     }
}