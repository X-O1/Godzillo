// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {RealEstate} from "../contracts/RealEstate.sol";

contract DeployRealEstateNft is Script {
    function run() external returns (RealEstate) {
        vm.startBroadcast();
        RealEstate realEstate = new RealEstate();
        vm.stopBroadcast();

        return realEstate;
    }
}
