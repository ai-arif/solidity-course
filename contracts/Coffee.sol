// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Coffee{
    
    struct CoffeeOrder {
        string name;
        string message;
        uint timestamp;
        address from;
    }
        CoffeeOrder[] orders;

        address payable owner;

        constructor(){
            owner = payable (msg.sender);
        }

        function buyCoffee(string calldata name, string calldata message) external payable{
            require(msg.value > 0, "Please send more than 0 ether");
            owner.transfer(msg.value);
            orders.push(CoffeeOrder(name, message, block.timestamp, msg.sender));
        }

        function getOrdersInfo() public view returns (CoffeeOrder[] memory){
            return orders;
        }

    }
