//SPDX-License-Identifer: MIT
pragma solidity ^0.8.30;

import {
    VRFConsumerBaseV2Plus
} from "../lib/chainlink-brownie-contracts/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {
    VRFV2PlusClient
} from "../lib/chainlink-brownie-contracts/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";

contract Lottery is VRFConsumerBaseV2Plus {
    error Lottery__moreMoney();
    error Lotter__notEnoughTime();
    error Lottery__notSent();
    error Lottery__notOpen();
    error Lottery__upkeepNotNeeded(uint256 amount,uint256 number,bool state);

    enum LotteryState {
        OPEN,
        CALCULATING
    }

    uint256 private immutable i_entranceFee;
    uint256 private immutable i_interval;
    bytes32 private immutable i_keyHash;
    uint256 private immutable i_subscriptionId;
    uint32 private immutable i_callBackGasLimit;
    uint16 private constant REQUEST_CONFRIMATIONS = 3;
    uint32 private constant NUM_WORDS = 1;
    address payable[] private s_players;
    uint256 public s_lastTimeStamp;
    address private s_recentWinner;
    LotteryState private s_lotteryState;

    event LotteryEntered(address indexed players);
    event GotWinner(address indexed winners);

    constructor(
        uint256 entranceFee,
        uint256 interval,
        address vrfCoordinator,
        bytes32 gasLane,
        uint256 subscriptionId,
        uint32 callbackGasLimit
    ) VRFConsumerBaseV2Plus(vrfCoordinator) {
        i_entranceFee = entranceFee;
        i_interval = interval;
        s_lastTimeStamp = block.timestamp;
        i_keyHash = gasLane;
        i_subscriptionId = subscriptionId;
        i_callBackGasLimit = callbackGasLimit;
        s_lotteryState = LotteryState.OPEN;
    }

    function enterLottery() external payable {
        if (msg.value < i_entranceFee) {
            revert Lottery__moreMoney();
        }
        if (s_lotteryState != LotteryState.OPEN) {
            revert Lottery__notOpen();
        }

        s_players.push(payable(msg.sender));

        emit LotteryEntered(msg.sender);
    }

    function checkUpKeep(
        bytes memory /*checkdata*/
    )
        public
        view
        returns (
            bool upkeepNeeded,
            bytes memory /*performData*/
        )
    {
        bool isTimePasses = ((block.timestamp - s_lastTimeStamp) >= i_interval);
        bool isOpen = s_lotteryState == LotteryState.OPEN;
        bool hasMoney = address(this).balance > 0;
        bool hasPlayers = s_players.length > 0;
        upkeepNeeded = isOpen && hasMoney && hasPlayers && isTimePasses;
        return (upkeepNeeded, "");
    }

    function performUpkeep() external {
        (bool upkeepNeeded,) = checkUpKeep("");
        if (!upkeepNeeded) {
            revert Lottery__upkeepNotNeeded(address(this).balance,s_players.length,LotteryState.OPEN);
        }
        if ((block.timestamp - s_lastTimeStamp) < i_interval) {
            revert Lotter__notEnoughTime();
        }
        s_lotteryState = LotteryState.CALCULATING;
        VRFV2PlusClient.RandomWordsRequest memory request = VRFV2PlusClient.RandomWordsRequest({
            keyHash: i_keyHash,
            subId: i_subscriptionId,
            requestConfirmations: REQUEST_CONFRIMATIONS,
            callbackGasLimit: i_callBackGasLimit,
            numWords: NUM_WORDS,
            extraArgs: VRFV2PlusClient._argsToBytes(VRFV2PlusClient.ExtraArgsV1({nativePayment: false}))
        });
        uint256 requestId = s_vrfCoordinator.requestRandomWords(request);
    }

    // function getWinner() external {
    //     if ((block.timestamp - s_lastTimeStamp) < i_interval) {
    //         revert Lotter__notEnoughTime();
    //     }
    //     s_lotteryState = LotteryState.CALCULATING;
    //     VRFV2PlusClient.RandomWordsRequest memory request = VRFV2PlusClient.RandomWordsRequest({
    //         keyHash: i_keyHash,
    //         subId: i_subscriptionId,
    //         requestConfirmations: REQUEST_CONFRIMATIONS,
    //         callbackGasLimit: i_callBackGasLimit,
    //         numWords: NUM_WORDS,
    //         extraArgs: VRFV2PlusClient._argsToBytes(VRFV2PlusClient.ExtraArgsV1({nativePayment: false}))
    //     });
    //     uint256 requestId = s_vrfCoordinator.requestRandomWords(request);
    // }

    function fulfillRandomWords(uint256 requestId, uint256[] calldata randomWords) internal override {
        uint256 indexWinner = randomWords[0] % s_players.length;
        address payable recentWinner = s_players[indexWinner];
        s_recentWinner = recentWinner;
        s_lotteryState = LotteryState.OPEN;
        s_players = new address payable[](0);
        s_lastTimeStamp = block.timestamp;
        (bool success,) = recentWinner.call{value: address(this).balance}("");
        if (!success) {
            revert Lottery__notSent();
        }
        emit GotWinner(s_recentWinner);
    }
}
// Layout of Contract:
// version, imports, errors, interfaces, libraries, contracts, Type declarations, State variables, Events, Modifiers, Functions

// Layout of Functions:
// constructor, receive function (if exists), fallback function (if exists), external, public, internal, private, view & pure functions
