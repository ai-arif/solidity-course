// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Withdrawal{
    mapping(address => uint) public balances;

    function deposit() public payable{
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        uint amount = balances[msg.sender];
        require(amount > 0, "Insufficient Balances");

        balances[msg.sender] = 0; //Update before balance
        (bool success, ) = msg.sender.call{value: amount}("");

        require(success, "Transfer Failed");
    }
}