// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Advanced{
    //event in solidity 

    uint public number;

    event Number(address indexed _from,uint value);

    function setNumber(uint _number) public returns(uint){
        number = _number;
        
        emit Number(msg.sender, _number);
        return number;
    }
}