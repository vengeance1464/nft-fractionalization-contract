// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./RealEstateNFT.sol";

contract NFTManager is Ownable {
    RealEstateNFT[] public contracts;
    mapping(address => mapping(uint => address)) public userNftsMapping;
    mapping(uint256 => address) tokenNftMapping;
    mapping(address => mapping(address => bool)) whiteListedAddresses;
    uint256 tokenCounter;

    function createNFTContract(string name, string description, string tokenUri) public returns (MyNFT) {
        RealEstateNFT nft = new RealEstateNFT(name, description);
        tokenCounter++;
        nft.createCollectible(tokenUri, basePrice, tokenCounter);
        userNftsMapping[msg.sender][tokenCounter] = address(nft);
        tokenNftMapping[tokenCounter] = msg.sender;
        return address(nft);
    }

    function changeNftStatus(uint256 tokenId, bool nftStatus) public {
        require(userNftsMapping[msg.sender][tokenId] == msg.sender, "You are not the owner");
        RealEstateNFT(userNftsMapping[msg.sender][tokenId]).isListed(nftStatus);
    }

    function transferNft(uint256 _tokenId, address _recipient) public {
        require(whiteListedAddresses[msg.sender][_recipient], "The recepient is not whitelisted by you");
        RealEstateNFT(userNftsMapping[msg.sender][tokenId]).transferToken(_recipient, _tokenId);
    }

    function addWhitelistAddress(address _recepient) {
        require(!whiteListedAddresses[msg.sender][_recepient], "You have already whitelisted  this address");
        whiteListedAddresses[msg.sender][_recepient] = true;
    }

    // function buyNFT(uint256 tokenId) payable {
    //     require(tokenId <= tokenCounter, "Token Id does not exists");
    //     require(tokenNftMapping[tokenId] != msg.sender, "Sender is already the owner of this nft");
    //     require(userNftsMapping[tokenNftMapping[tokenId]][tokenId].isListed(), "Nft is not listed");
    //     require(msg.value > 0, "Amount is less than 0");
    //     tokenNftMapping[tokenId].transferToken(msg.sender, tokenId);
    //     tokenNftMapping[tokenId].transfer(msg.value);
    // }
}
