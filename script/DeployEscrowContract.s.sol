// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {Escrow} from "../contracts/Escrow.sol";

contract DeployEscrowContract is Script {
    address public nftAddress = 0x90193C961A926261B756D1E5bb255e67ff9498A1;
    address payable public seller = payable(0xD5C4414DbD01E76c4AB65Ab994759d2BD160E6E0);
    address public inspector = 0x8834FBeb6F2dF45884166696abA71c9485Fa261E;
    address public lender = 0x8C6825Ad108eed0e4d90826343114506E7512b87;

    function run() external returns (Escrow) {
        vm.startBroadcast();
        Escrow escrow = new Escrow(nftAddress, seller, inspector, lender);
        vm.stopBroadcast();

        return escrow;
    }
}
