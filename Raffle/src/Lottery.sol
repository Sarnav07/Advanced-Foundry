//SPDX-License-Identifer: MIT
pragma solidity ^0.8.30;

contract Lottery {
    error Lottery__moreMoney();
    error Lotter__notEnoughTime();

    uint256 private immutable i_entranceFee;
    address payable[] private s_players;
    uint256 private immutable i_interval;
    uint256 public s_lastTimeStamp;

    event LotteryEntered(address indexed players);

    constructor(uint256 entranceFee) {
        i_entranceFee = entranceFee;
        s_lastTimeStamp=block.timestamp;
    }

    function enterLottery() external payable {
        if (msg.value < i_entranceFee) {
            revert Lottery__moreMoney();
        }

        s_players.push(payable(msg.sender));

        emit LotteryEntered(msg.sender);
    }

    function getWinner() external {
        if ((block.timestamp - s_lastTimeStamp) < i_interval) {
            revert Lotter__notEnoughTime();
        }
    }
}

// Layout of Contract:
// version, imports, errors, interfaces, libraries, contracts, Type declarations, State variables, Events, Modifiers, Functions

// Layout of Functions:
// constructor, receive function (if exists), fallback function (if exists), external, public, internal, private, view & pure functions
