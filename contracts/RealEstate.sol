// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
/**
 * @title Real Estate Nft
 * @author https://github.com/X-O1
 * @notice This contract handles the creation of NFTs that represent individual real estate properties.
 */

import {ERC721} from "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {ERC721URIStorage} from "lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract RealEstate is ERC721URIStorage {
    uint256 private s_tokenIds;

    constructor() ERC721("Real Estate", "REAL") {}

    function incrementTokenId() public {
        s_tokenIds += 1;
    }

    function decreaseTokenId() public {
        s_tokenIds -= 1;
    }

    function mint(string memory tokenURI) public returns (uint256) {
        incrementTokenId();

        uint256 newItemId = s_tokenIds;
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);

        return newItemId;
    }

    function totalSupply() public view returns (uint256) {
        return s_tokenIds;
    }
}
