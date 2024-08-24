// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract SecureBank{
    mapping(address => uint) public balances;
    uint public totalSupply;

    function deposit() public payable{
        //require() -> in case if it fails, it refunds remaining gas
        require(msg.value > 0, "Amount must be greater than 0"); 

        uint oldBalance = address(this).balance - msg.value;
        balances[msg.sender] += msg.value;

        totalSupply += msg.value;

        //assert() -> it doesn't refund gas, only when are confirmed that it can't be 
        //false or there's no bug then we should use it.
        assert(address(this).balance == oldBalance + msg.value);
    }

    function withdraw(uint amount) public {
        require(amount > 0, "You have not sufficient balance");
        require(balances[msg.sender] >= amount, "insufficient balance");

        if(amount > address(this).balance){
            //revert -> only contain message of error, refund gas
            revert("Contract has insufficient balance");
        }

        balances[msg.sender] -= amount;
        totalSupply -= amount;

        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed"); //check if it was successful

        assert(totalSupply == address(this).balance);
    }
}