// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract CheckEffectsInteractions{
    mapping(address => uint) public balances;

    //vulnerable withdraw function
    function vulnerableWithdraw(uint amount) public {
        //chekcs
        require(balances[msg.sender] >= amount, "Insufficient balance");

        //interaction before effect
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");

        //effects
        balances[msg.sender] -= amount; //effects after interaction - Vulnerable

    }

    //Right way 

    function withdraw(uint amount) public {
        //checks
        require(balances[msg.sender] >= amount, "Insufficient balance");

        //effects
        balances[msg.sender] -= amount; //effects after interaction - Right way

        //interaction after effect
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed"); 
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

}