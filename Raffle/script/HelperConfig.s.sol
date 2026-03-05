//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script} from "../lib/forge-std/src/Script.sol";
import {VRFCoordinatorV2_5Mock} from "../lib/chainlink-brownie-contracts/contracts/src/v0.8/mocks/VRFCoordinatorV2_5Mock.sol";

abstract contract Constants {
    uint96 public MOCK_BASE_FEE=0.25 ether;
    uint96 public MOCK_GAS_PRICE_LINK = 1e9;
    int256 public MOCK_WEI_PER_LINK=5e16;
    uint256 public constant ETH_SEPOLIA_CHAIN_ID=11155111;
    uint256 public constant LOCAL_CHAIN_ID=31337;
}

contract HelperConfig is Script {
    error HelperConfig__ChainId();
    struct NetworkConfig{
        uint256 entranceFee;
        uint256 interval;
        address vrfCoordinator;
        bytes32 gasLane;
        uint256 callbackGasLimit;
        uint256 subscriptionId;
    }

    NetworkConfig public networkConfig;
    mapping(uint256 chainId=>NetworkConfig) public networkConfigs;

    constructor() {
        networkConfigs[ETH_SEPOLIA_CHAIN_ID]=getSepoliaEthConfig();

    }

    function getConfigByChainId(uint256 chainId) public returns (NetworkConfig memory) {
        if (networkConfigs[chainId].vrfCoordinator != address(0)) {
            return networkConfig[chainId];
        } else if (chainId == LOCAL_CHAIN_ID) {
            return getOrCreateAnvilEthConfig();
        } else {
            revert HelperConfig__ChainId();
        }
    }

    function getConfig() public returns(NetworkConfig memory) {
        return getConfigByChainId(block.chainId);
    }

    function getSepoliaEthConfig() public pure returns(NetworkConfig memory) {
        return NetworkConfig({
            entranceFee:0.001 ether,
            interval :60,
            vrfCoordinator:,
            gasLane:,
            callbackGasLimit:500000,
            subscriptionId:0
        })
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        if (localNetworkConfig.vrfCoordinator != address(0)) {
            return localNetworkConfig;
        }
        vm.startBroadcast();
        VRFCoordinatorV2_5Mock vrfMockCoordinator = new VRFCoordinatorV2_5Mock(MOCK_BASE_FEE,MOCK_GAS_PRICE_LINK,MOCK_WEI_PER_LINK);
        vm.stopBroadcast();

        localNetworkConfig = NetworkConfig({
            entranceFee:0.01 ether,
            internal:60,
            vrfCoordinator:address(vrfCoordinatorMock),
            gasLane:,
            callbackGasLimit:50000,
            subscription:0
        });
        return localNetworkConfig;
    }
}
