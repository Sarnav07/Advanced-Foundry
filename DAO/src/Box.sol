//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Ownable} from "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract Box is Ownable {
    constructor() Ownable(msg.sender) {}

    uint256 private s_vote;

    event voteChanged(uint256 number);

    function store(uint256 newVote) public onlyOwner {
        s_vote = newVote;
        emit voteChanged(newVote);
    }

    function getVote() external view returns (uint256) {
        return s_vote;
    }
}
