// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RealEstateNFT is ERC721, Ownable {
    string public name;
    string public description;
    bool public isListed;
    uint256 basePrice;

    constructor(string _name, string _description) public ERC721("MyNFT", "MNFT") {
        name = _name;
        description = _description;
    }

    function createCollectible(
        string memory tokenURI,
        uint256 _basePrice,
        uint256 tokenCounter
    ) public onlyOwner returns (uint256) {
        _safeMint(msg.sender, tokenCounter);
        isListed = false;
        basePrice = _basePrice;
        _setTokenURI(tokenCounter, tokenURI);
    }

    function burn(uint256 tokenId) public {
        require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: burn caller is not owner nor approved");
        _burn(tokenId);
    }

    function transferToken(address to, uint256 tokenId) public onlyOwner {
        require(_exists(tokenId), "ERC721: operator query for nonexistent token");
        _safeTransfer(msg.sender, to, tokenId, "");
    }
}
