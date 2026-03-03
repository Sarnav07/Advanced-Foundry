//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "../lib/forge-std/src/Test.sol";
import {SimpleStorage} from "../src/SimpleStorage.sol";
import {DeploySimpleStorage} from "../script/DeploySimpleStorage.s.sol";

contract TestSimpleStorage is Test {
    DeploySimpleStorage public deployer;
    SimpleStorage public simpleStorage;

    function setUp() external {
        deployer = new DeploySimpleStorage();
        simpleStorage = deployer.run();
    }

    function testStoring() public {
        uint256 sto = 18;
        simpleStorage.store(sto);
        assert(sto == simpleStorage.get());
    }

    function testAddingPerson() public {
        string memory _name = "Sarnav";
        uint256 _fav = 18;

        simpleStorage.addPerson(_fav, _name);
        uint256 getNumber = simpleStorage.nameToFavoriteNumber(_name);
        assert(getNumber == _fav);
    }
}
