// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;


//The Oracle pattern is used when a contract needs to access external data.

contract DataConsumer{
    Oracle public oracle;
    uint public price;

    constructor(address _oracle){
        oracle = Oracle(_oracle);
    }

    function updatePrice() public {
        price = oracle.getPrice("ETH/USD");
    }


}

contract Oracle {
        function getPrice(string memory _pair) public pure returns(uint){
            return 200;
        }
    }