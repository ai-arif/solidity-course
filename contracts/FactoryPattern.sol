// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

//The Factory pattern is used to create contract instances dynamically.

contract Token{
    string public name;

    constructor(string memory _name){
        name = _name;
    }
}

contract TokenFactory{
    Token[] public tokens;

    function createToken(string memory _name) public {
        Token token = new Token(_name);
        tokens.push(token);
    }
}