//SPDX-License-Identifer: MIT
pragma solidity ^0.8.30;

import {ERC721} from "../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {
    uint256 private s_tokenCounter;
    mapping(uint256 => string) public s_tokenIdToUri;

    constructor() ERC721("NFT", "SK") {
        s_tokenCounter = 0;
    }

    function mint(string memory tokenURI) public {
        s_tokenIdToUri[s_tokenCounter] = tokenURI;
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenCounter++;
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        return s_tokenIdToUri[tokenId];
    }
}
