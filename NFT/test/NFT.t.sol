// SPDX-License-Identifer :MIT
pragma solidity ^0.8.30;

import {Test} from "../lib/forge-std/src/Test.sol";
import {DeployNFT} from "../script/DeployNFT.sol";
import {NFT} from "../src/NFT.sol";

contract TestNFT is Test {
    string public constant MUSK_URI =
        "ipfs://QmbN1jE1vgj2fnGPGwaXsg84CtFQRMMdEXWh5rkKqqahKa/258.json";
    string public NFT_Name = "NFT";
    string public NFT_Symbol = "SK";
    DeployNFT public deployNFT;
    NFT public nft;
    address public USER = makeAddr("user");

    function setUp() external {
        deployNFT = new DeployNFT();
        nft = deployNFT.run();
    }

    function testNameAndSymbol() public {
        assert(
            keccak256(abi.encodePacked(nft.name())) ==
                keccak256(abi.encodePacked(NFT_Name))
        );
        assert(
            keccak256(abi.encodePacked(nft.symbol())) ==
                keccak256(abi.encodePacked(NFT_Symbol))
        );
    }

    function testTokenURI() public {
        vm.prank(USER);
        nft.mint(MUSK_URI);

        assert(
            keccak256(abi.encodePacked(nft.tokenURI(0))) ==
                keccak256(abi.encodePacked(MUSK_URI))
        );
    }

    function testCanMintAndHaveBalance() public {
        vm.prank(USER);
        nft.mint(MUSK_URI);
        assert(nft.balanceOf(USER) == 1);
    }
}
