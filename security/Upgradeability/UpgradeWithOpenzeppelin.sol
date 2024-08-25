// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract MyContractV1 is Initializable{
    uint256 public value;

    function initialize(uint256 _value) public initializer{
        value = _value;
    }

    function increment() public {
        value += 1;    
    }

}

contract MyContractV2 is Initializable{
    uint public value;

    function initialize(uint256 _value) public initializer{
        value = _value;
    }

    function increment() public {
        value += 1;
    }

    function decrement() public {
        value -= 1;
    }
}
