// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
/**
 * @title Escrow Contract
 * @author https://github.com/X-O1
 * @notice Escrow contract that handles the down payment, loan, and sale proccess.
 */

import {IERC721} from "lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";
// interface IERC721 {
//     function transferFrom(address _from, address _to, uint256 _id) external;
// }

contract Escrow {
    // ERRORS
    error Escrow__TransactionFailed();
    // STATE VARIABLES

    address public nftAddress;
    address payable public seller;
    address public inspector;
    address public lender;

    mapping(uint256 _tokenId => bool _isListed) public isListed;
    mapping(uint256 _tokenId => address _buyer) public buyer;
    mapping(uint256 _tokenId => uint256 _price) public purchasePrice;
    mapping(uint256 _tokenId => uint256 _escrowAmount) public escrowAmount;
    mapping(uint256 _tokenId => bool _passed) public inspectionPassed;
    mapping(uint256 _tokenId => mapping(address approver => bool)) public approval;
    mapping(uint256 _tokenId => uint256 _escrowBalance) public escrowBalance;

    // MODIFIERS
    modifier onlySeller() {
        require(msg.sender == seller, "Only seller can call this function");
        _;
    }

    modifier onlyBuyer(uint256 _tokenId) {
        require(msg.sender == buyer[_tokenId], "Only buyer can call this function");
        _;
    }

    modifier onlyInspector() {
        require(msg.sender == inspector, "Only inspector can call this function");
        _;
    }

    modifier onlyLender() {
        require(msg.sender == lender, "Only lender can call this function");
        _;
    }
    // FUNCTIONS

    receive() external payable {}

    constructor(address _nftAddress, address payable _seller, address _inspector, address _lender) {
        nftAddress = _nftAddress;
        seller = _seller;
        inspector = _inspector;
        lender = _lender;
    }

    function listProperty(uint256 _tokenId, address _buyer, uint256 _purchasePrice, uint256 _escrowAmount)
        public
        payable
        onlySeller
    {
        IERC721(nftAddress).transferFrom(msg.sender, address(this), _tokenId);

        isListed[_tokenId] = true;
        buyer[_tokenId] = _buyer;
        purchasePrice[_tokenId] = _purchasePrice;
        escrowAmount[_tokenId] = _escrowAmount;
    }

    function depositDownPayment(uint256 _tokenId) public payable onlyBuyer(_tokenId) {
        require(msg.value == escrowAmount[_tokenId], "Deposit exact amount");
        escrowBalance[_tokenId] += msg.value;
    }

    function lenderDeposit(uint256 _tokenId) public payable onlyLender {
        require(inspectionPassed[_tokenId] == true, "Inspection must pass");
        require(address(this).balance >= escrowAmount[_tokenId], "Down payment from buyer must be deposited first");
        require(msg.value == purchasePrice[_tokenId] - escrowAmount[_tokenId], "Deposit exact amount");

        escrowBalance[_tokenId] += msg.value;
    }

    function updateInspectionStatus(uint256 _tokenId, bool _passed) public onlyInspector {
        inspectionPassed[_tokenId] = _passed;
    }

    function approveSale(uint256 _tokenId) public {
        approval[_tokenId][msg.sender] = true;
    }

    function finalizeSale(uint256 _tokenId) public {
        require(inspectionPassed[_tokenId]);
        require(approval[_tokenId][buyer[_tokenId]]);
        require(approval[_tokenId][seller]);
        require(approval[_tokenId][lender]);
        require(escrowBalance[_tokenId] >= purchasePrice[_tokenId]);
        escrowBalance[_tokenId] -= purchasePrice[_tokenId];

        (bool success,) = payable(seller).call{value: purchasePrice[_tokenId]}("");
        if (!success) {
            revert Escrow__TransactionFailed();
        }

        IERC721(nftAddress).transferFrom(address(this), buyer[_tokenId], _tokenId);
    }

    // VIEW FUNCTIONS
    function getListingStatus(uint256 _tokenId) external view returns (bool _isListed) {
        return isListed[_tokenId];
    }

    function getBuyerAddress(uint256 _tokenId) external view returns (address _buyer) {
        return buyer[_tokenId];
    }

    function getPrice(uint256 _tokenId) external view returns (uint256 _price) {
        return purchasePrice[_tokenId];
    }

    function getEscrowAmount(uint256 _tokenId) external view returns (uint256 _escrowAmount) {
        return escrowAmount[_tokenId];
    }

    function getInspectionStatus(uint256 _tokenId) external view returns (bool _inspectionPassed) {
        return inspectionPassed[_tokenId];
    }

    function getApprovalStatus(uint256 _tokenId) external view returns (bool _saleApproved) {
        return approval[_tokenId][msg.sender];
    }

    function getEscrowEtherBalance(uint256 _tokenId) external view returns (uint256 _contractBalace) {
        return escrowBalance[_tokenId];
    }
}
