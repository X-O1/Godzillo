// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";

import {Escrow} from "../../contracts/Escrow.sol";
import {RealEstate} from "../../contracts/RealEstate.sol";
import {DeployEscrowContract} from "../../script/DeployEscrowContract.s.sol";
import {DeployRealEstateNft} from "../../script/DeployRealEstateNft.s.sol";

contract EscrowTest is Test {
    RealEstate realEstate;
    Escrow escrow;

    address public realEstateContract = 0x90193C961A926261B756D1E5bb255e67ff9498A1;
    address public escrowContract = 0xA8452Ec99ce0C64f20701dB7dD3abDb607c00496;
    string public tokenURI = "https://ipfs.io/ipfs/QmTudSYeM7mz3PkYEWXWqPjomRPHogcMFSq7XAvsvsgAPS";

    address payable public SELLER = payable(makeAddr("Seller"));
    address public BUYER = makeAddr("Buyer");
    address public INSPECTOR = makeAddr("Inspector");
    address public LENDER = makeAddr("Lender");
    address public APPRAISER = makeAddr("Appraiser");

    function setUp() external {
        DeployRealEstateNft deployRealEstate = new DeployRealEstateNft();
        realEstate = deployRealEstate.run();

        DeployEscrowContract deployEscrowContract = new DeployEscrowContract();
        escrow = deployEscrowContract.run();

        // escrow = new Escrow(realEstateContract, SELLER, INSPECTOR, LENDER);

        vm.deal(SELLER, 10 ether);
        vm.deal(BUYER, 10 ether);
        vm.deal(INSPECTOR, 10 ether);
        vm.deal(LENDER, 10 ether);
        vm.deal(APPRAISER, 10 ether);
        vm.deal(0xA8452Ec99ce0C64f20701dB7dD3abDb607c00496, 1 ether);
    }

    function testMintingNft() public {
        vm.prank(SELLER);
        realEstate.mint(tokenURI);

        vm.prank(SELLER);
        realEstate.mint(tokenURI);
    }

    function testListingProperty() public {
        vm.prank(SELLER);
        realEstate.mint(tokenURI);

        vm.prank(SELLER);
        realEstate.approve(escrowContract, 1);

        vm.prank(SELLER);
        escrow.listProperty(1, BUYER, 1 ether, 0.01 ether);
    }

    function testListingStatusUpdates() public {
        vm.prank(SELLER);
        realEstate.mint(tokenURI);

        vm.prank(SELLER);
        realEstate.approve(escrowContract, 1);

        vm.prank(SELLER);
        escrow.listProperty(1, BUYER, 1 ether, 0.5 ether);
    }

    function testDepositingDownPayment() public {
        vm.prank(SELLER);
        realEstate.mint(tokenURI);

        vm.prank(SELLER);
        realEstate.approve(escrowContract, 1);

        vm.prank(SELLER);
        escrow.listProperty(1, BUYER, 1 ether, 0.5 ether);

        vm.prank(BUYER);
        escrow.depositDownPayment{value: 0.5 ether}(1);

        assertEq(escrow.getEscrowEtherBalance(1), 0.5 ether);
    }

    function testInpectorUpdates() public {
        vm.prank(SELLER);
        realEstate.mint(tokenURI);

        vm.prank(SELLER);
        realEstate.approve(escrowContract, 1);

        vm.prank(SELLER);
        escrow.listProperty(1, BUYER, 1 ether, 0.5 ether);

        vm.prank(INSPECTOR);
        escrow.updateInspectionStatus(1, true);

        assertEq(escrow.getInspectionStatus(1), true);

        vm.prank(INSPECTOR);
        escrow.updateInspectionStatus(1, false);

        assertEq(escrow.getInspectionStatus(1), false);
    }

    function testApprovingSale() public {
        vm.prank(SELLER);
        realEstate.mint(tokenURI);

        vm.prank(SELLER);
        realEstate.approve(escrowContract, 1);

        vm.prank(SELLER);
        escrow.listProperty(1, BUYER, 1 ether, 0.5 ether);

        vm.prank(INSPECTOR);
        escrow.updateInspectionStatus(1, true);

        vm.prank(LENDER);
        escrow.approveSale(1);

        vm.prank(LENDER);
        assertEq(escrow.getApprovalStatus(1), true);
    }

    function testFinalizingSale() public {
        vm.prank(SELLER);
        realEstate.mint(tokenURI);

        vm.prank(SELLER);
        realEstate.approve(escrowContract, 1);

        vm.prank(SELLER);
        escrow.listProperty(1, BUYER, 1 ether, 0.5 ether);

        vm.prank(BUYER);
        escrow.depositDownPayment{value: 0.5 ether}(1);

        vm.prank(INSPECTOR);
        escrow.updateInspectionStatus(1, true);

        vm.prank(LENDER);
        escrow.lenderDeposit{value: 0.5 ether}(1);

        vm.prank(LENDER);
        escrow.approveSale(1);

        vm.prank(SELLER);
        escrow.approveSale(1);

        vm.prank(BUYER);
        escrow.approveSale(1);

        vm.prank(LENDER);
        escrow.finalizeSale(1);

        assertEq(realEstate.ownerOf(1), BUYER);

        assertEq(escrow.getEscrowEtherBalance(1), 0 ether);
    }
}
