// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract owned{
    address public owner;

     constructor(){
        owner == msg.sender;
     }

     modifier onlyOwner(){
        require(msg.sender == owner, "Only owner can do it");
        _;
     }

     function transferOwnership(address newOwner) public onlyOwner() {
        require(newOwner != address(0), "New owner is the zero address");
        owner = newOwner;
     }


}