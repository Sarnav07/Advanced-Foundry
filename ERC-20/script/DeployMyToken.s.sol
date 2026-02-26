//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script} from "../lib/forge-std/src/Script.sol";
import {MyToken} from "../src/MyToken.sol";

contract DeployMyToken is Script {
    uint256 public constant INITIAL_SUPPLY = 100 ether;

    function run() external {
        vm.startBroadcast();
        new MyToken(INITIAL_SUPPLY);
        vm.stopBroadcast();
    }
}
