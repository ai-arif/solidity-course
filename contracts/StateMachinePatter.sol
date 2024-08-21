// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;


contract Escrow{
    enum State {PENDING, DELIVERY, COMPLETED}

    State public currentState;

    address public buyer;
    address public seller;

    constructor(address _buyer, address _seller){
        buyer = _buyer;
        seller = _seller;
        currentState = State.PENDING;
    }

    function deposit() public payable{
        require(currentState == State.PENDING, "Invalid State");
        require(msg.sender == buyer, "Only buyer can call this function");

        currentState = State.DELIVERY;
    }

    function confirmDelivery() public {
        require(currentState == State.DELIVERY, "Invalid State");
        require(msg.sender == buyer, "Only buyer can call this function");

        (bool success, ) = seller.call{value: address(this).balance}("");
        require(success, "Failed to send ether");
        currentState = State.COMPLETED;
    }
}