// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;


contract VulnerableContract{
    mapping(address => uint) public balances;

    function withdraw() public {
        uint amount = balances[msg.sender];
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
        balances[msg.sender] = 0;
    }
}

contract SecureContract{
    mapping(address => uint) public balances;
    bool private locked;

    modifier noReentrant(){
        require(!locked, "No Reentrancy");
        locked = true; 
        _;
        locked = false;
    }

    function withdraw() public noReentrant{
        uint amount = balances[msg.sender];
        balances[msg.sender] = 0;
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
    }
}