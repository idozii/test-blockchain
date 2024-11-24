// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {CrowdFunding} from "../src/CrowdFunding.sol";

contract CrowdFundingTest is Script {
    function run() external returns(CrowdFunding) {
        vm.startBroadcast();
        CrowdFunding crowdFunding = new CrowdFunding();
        vm.stopBroadcast();

        return crowdFunding;
    }
}
