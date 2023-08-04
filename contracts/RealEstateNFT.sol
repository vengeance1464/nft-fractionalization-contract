// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract RealEstateNFT is ERC721, ERC721URIStorage {
    string public description;
    bool public isListed;
    uint256 basePrice;
    string[] public documents;

    constructor(string memory name, string memory symbol, string memory _description) ERC721(name, symbol) {
        description = _description;
    }

    function createCollectible(
        string memory tokenUri,
        uint256 _basePrice,
        uint256 tokenCounter,
        address sender
    ) public {
        _safeMint(sender, tokenCounter);
        isListed = false;
        basePrice = _basePrice;
        _setTokenURI(tokenCounter, tokenUri);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: burn caller is not owner nor approved");
        _burn(tokenId);
    }

    function transferToken(address sender, address to, uint256 tokenId) public {
        require(_exists(tokenId), "ERC721: operator query for nonexistent token");
        _safeTransfer(sender, to, tokenId, "");
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    // Override supportsInterface
    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function setListed(bool _isListed) public {
        isListed = _isListed;
    }
}
