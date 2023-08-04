// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./RealEstateNFT.sol";

contract NFTManager is Ownable {
    RealEstateNFT[] public contracts;
    mapping(address => mapping(uint => address)) public userNftsMapping;
    mapping(uint256 => address) tokenNftMapping;
    mapping(address => bool) whiteListedAddresses; //make this array  mapping adress
    uint256 tokenCounter;
    event NftCreate(address indexed _from, uint256 _id);

    function createNFTContract(
        string memory name,
        string memory symbol,
        string memory description,
        string memory tokenUri,
        uint256 basePrice
    ) public {
        RealEstateNFT nft = new RealEstateNFT(name, symbol, description);
        tokenCounter++;
        nft.createCollectible(tokenUri, basePrice, tokenCounter, msg.sender);
        userNftsMapping[msg.sender][tokenCounter] = address(nft);
        tokenNftMapping[tokenCounter] = msg.sender;
        emit NftCreate(msg.sender, tokenCounter);
    }

    function changeNftStatus(uint256 tokenId, bool nftStatus) public {
        require(tokenNftMapping[tokenId] == msg.sender, "You are not the owner");
        RealEstateNFT(userNftsMapping[msg.sender][tokenId]).setListed(nftStatus);
    }

    function transferNft(uint256 _tokenId, address _recipient) public {
        require(whiteListedAddresses[_recipient], "The recepient is not whitelisted by you");
        require(tokenNftMapping[_tokenId] == msg.sender, "you dont own this NFT");
        RealEstateNFT(userNftsMapping[msg.sender][_tokenId]).transferToken(msg.sender, _recipient, _tokenId);
        userNftsMapping[_recipient][_tokenId] = userNftsMapping[msg.sender][_tokenId];
        tokenNftMapping[_tokenId] = _recipient;
        delete userNftsMapping[msg.sender][_tokenId];
    }

    function addWhitelistAddress(address _whitelistedAddress) public onlyOwner {
        require(!whiteListedAddresses[_whitelistedAddress], "You have already whitelisted  this address");
        whiteListedAddresses[_whitelistedAddress] = true;
    }

    function removeWhitelistAddress(address _whitelistedAddress) public onlyOwner {
        require(whiteListedAddresses[_whitelistedAddress], "This address s not whitelisted");
        whiteListedAddresses[_whitelistedAddress] = false;
    }

    //API for reading NFT details and whitelisted addresses

    // function buyNFT(uint256 tokenId) payable {
    //     require(tokenId <= tokenCounter, "Token Id does not exists");
    //     require(tokenNftMapping[tokenId] != msg.sender, "Sender is already the owner of this nft");
    //     require(userNftsMapping[tokenNftMapping[tokenId]][tokenId].isListed(), "Nft is not listed");
    //     require(msg.value > 0, "Amount is less than 0");
    //     tokenNftMapping[tokenId].transferToken(msg.sender, tokenId);
    //     tokenNftMapping[tokenId].transfer(msg.value);
    // }
}
