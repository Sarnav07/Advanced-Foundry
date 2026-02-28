//SPDX-License-Identifer: MIT
pragma solidity ^0.8.30;

import {NFT} from "../src/NFT.sol";
import {Script} from "../lib/forge-std/src/Script.sol";

contract DeployNFT is Script {
    function run() external returns (NFT) {
        vm.startBroadcast();
        NFT Nft = new NFT();
        vm.stopBroadcast();
        return Nft;
    }
}
