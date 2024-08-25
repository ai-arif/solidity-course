// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract GasEfficiency{
    //less efficient
    uint8 smallNumber;
    
    //more gas efficient
    uint256 largeNumber;

    //less efficient
    // i++

    //more efficient
    // ++i

    //less efficient

    uint[] public array;


    // for(uint i = 0; i<array.length; i++){}

    //more efficient

    uint256 length = array.length;
    // for(uint i = 0; i<length; i++){}

    //short circuit evaluation

    // if(firstCondition && secondCondition){}

    //Packing variables
    struct PackedData{
        string name;
        uint256 a;
    }

    //using assembly

    function addAssembly(uint x, uint y) public pure returns(uint){
        assembly{
            let result := add(x, y)
            if lt(result, x){
                revert(0, 0)
            }
            mstore(0x0, result)
            return (0x0, 32)
        }
    }

}