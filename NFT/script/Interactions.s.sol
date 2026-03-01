//SPDX-License-Identifer : MIT
pragma solidity ^0.8.30;

import {NFT} from "../src/NFT.sol";
import {Script} from "../lib/forge-std/src/Script.sol";
import {DevOpsTools} from "../lib/foundry-devops/src/DevOpsTools.sol";

contract MintNFT is Script {
    string public constant MUSK_URI =
        "ipfs://QmbN1jE1vgj2fnGPGwaXsg84CtFQRMMdEXWh5rkKqqahKa/258.json";

    function run() external {
        address mostRecentlyDeployedNFT = DevOpsTools
            .get_most_recent_deployment("NFT", block.chainid);
        mintNFTOnContract(mostRecentlyDeployedNFT);
    }

    function mintNFTOnContract(address NFTAddress) public {
        vm.startBroadcast();
        NFT(NFTAddress).mint(MUSK_URI);
        vm.stopBroadcast();
    }
}
