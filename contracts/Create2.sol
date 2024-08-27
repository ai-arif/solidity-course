// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Create2{
    function deploy(bytes32 salt, bytes memory bytecode) public returns(address){
        address addr;

        assembly{
            addr := create2(0, add(bytecode, 0x20), mload(bytecode), salt)
        }

        require(addr != address(0), "Create2 Failed");
        return addr;

    }

}