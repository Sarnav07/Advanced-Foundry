//SPDX-License-Identifer: MIT
pragma solidity ^0.8.30;

contract SimpleStorage {
    uint256 favoriteNumber;

    struct Person {
        uint256 number;
        string name;
    }

    mapping(string => uint256) public nameToFavoriteNumber;

    Person[] public person;

    function store(uint256 _fav) public {
        favoriteNumber = _fav;
    }

    function get() public view returns (uint256) {
        return favoriteNumber;
    }

    function addPerson(uint256 _favo, string memory _name) public {
        person.push(Person({number: _favo, name: _name}));
        nameToFavoriteNumber[_name] = _favo;
    }
}
