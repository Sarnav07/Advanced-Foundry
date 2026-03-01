//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {ERC20Permit} from "../lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Permit.sol";
import {ERC20Votes} from "../lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Votes.sol";
import {Nonces} from "../lib/openzeppelin-contracts/contracts/utils/Nonces.sol";

contract Token is ERC20, ERC20Permit, ERC20Votes {
    constructor()
        ERC20("Governance Token", "GT")
        ERC20Permit("Governance Token")
    {}

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }

    function _update(
        address from,
        address to,
        uint256 amount
    ) internal override(ERC20, ERC20Votes) {
        super._update(from, to, amount);
    }

    function nonces(
        address owner
    ) public view override(ERC20Permit, Nonces) returns (uint256) {
        return super.nonces(owner);
    }
}
