//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script} from "../lib/forge-std/Script.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";
import {Lottery} from "../src/Lottery.sol";

contract DeployLottery is Script {
    function run() public {
    }

    function deployContract() public returns(Lottery,HelperConfig) {
        HelperConfig helperConfig = new HelperConfig();
        HelperConfig.NetworkConfig memory config = helperConfig.getConfig();

        vm.startBroadcast();
        Lottery lottery = new Lottery(
            config.entranceFee,
            config.interval,
            config.vrfCoordinator,
            config.gasLane,
            config.subscriptionId,
            config.callbackGasLimit
        );
        vm.stopBroadcast();
        return (lottery,helperConfig);
    }
}