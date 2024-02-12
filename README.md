# Godzillo: Blockchain-based Home Escrow Service 

## Overview
Godzillo is blockchain infrastructure designed to facilitate secure, transparent, and efficient platform for handling property sales, including down payments, loans, and the entire sale process.

## Features
- **Property Listing**: Sellers can list properties for sale, specifying the buyer, sale price, and required escrow amount.
- **Down Payment Deposits**: Buyers can securely deposit their down payments into escrow, directly through the contract.
- **Loan Contributions**: Lenders can contribute the remaining balance of the purchase price, post-inspection approval.
- **Inspection Approvals**: Designated inspectors can update the status of property inspections, which is crucial for proceeding with the sale.
- **Multi-party Sale Approval**: Sales require the approval of all parties involved - the buyer, the seller, and the lender, ensuring transparency and mutual agreement.
- **Sale Finalization**: Once all conditions are met, the sale is finalized, transferring the property to the buyer and the funds to the seller.

## How to Use
### Setup
1. **Deploy the Contract**: Deploy the Escrow contract to the Ethereum blockchain, specifying the NFT representing the property, the seller, the designated inspector, and the lender.

### Listing a Property
1. **Call `listProperty`**: The seller lists a property by calling `listProperty` with the property's token ID, the designated buyer, the purchase price, and the escrow amount required.

### Making a Down Payment
1. **Call `depositDownPayment`**: The buyer deposits the down payment by calling `depositDownPayment` with the property's token ID.

### Lender's Deposit
1. **Call `lenderDeposit`**: Post-inspection, the lender deposits the remaining balance by calling `lenderDeposit` with the property's token ID.

### Inspection Approval
1. **Call `updateInspectionStatus`**: The inspector updates the property's inspection status by calling `updateInspectionStatus` with the property's token ID and the inspection result.

### Approving the Sale
1. **Call `approveSale`**: Each party (buyer, seller, lender) must call `approveSale` to indicate their approval of the transaction.

### Finalizing the Sale
1. **Call `finalizeSale`**: Once all approvals are in place and funds are secured, any party can call `finalizeSale` to transfer the property and disburse funds.

## Contract Functions
- **Constructor**: Initializes the contract with the NFT address, seller, inspector, and lender.
- **listProperty**: Lists a property for sale.
- **depositDownPayment**: Allows the buyer to deposit the down payment.
- **lenderDeposit**: Allows the lender to deposit the loan amount.
- **updateInspectionStatus**: Updates the inspection status of a property.
- **approveSale**: Records an approval from a party.
- **finalizeSale**: Finalizes the sale, transferring ownership and funds.

## View Functions
- **getListingStatus**: Checks if a property is listed.
- **getBuyerAddress**: Retrieves the designated buyer's address.
- **getPrice**: Retrieves the listed price of a property.
- **getEscrowAmount**: Retrieves the required escrow amount for a property.
- **getInspectionStatus**: Checks the inspection status of a property.
- **getApprovalStatus**: Checks if a party has approved the sale.
- **getEscrowEtherBalance**: Retrieves the total ether held in escrow for a property.

## Security Features
- The contract includes checks to ensure that only authorized parties can perform specific actions (e.g., only the seller can list a property).
- Solidity's `require` statements are used extensively to validate conditions before executing functions, enhancing security and reliability.

## Dependencies
- OpenZeppelin's IERC721 interface for NFT interactions.

## License
This project is licensed under the MIT License.
git