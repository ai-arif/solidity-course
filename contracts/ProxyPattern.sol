// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract ProxyPattern{
    address public implementation;
    address public admin;

    constructor(address _implementation) {
        implementation = _implementation;
        admin = msg.sender;
    }

    function upgrade(address _newImplementation) external {
        require(msg.sender == admin, "Only admin can call this function");
        implementation = _newImplementation;
    }

    fallback() external {
        address _impl = implementation;

        assembly{
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize())
            let result := delegatecall(gas(), _impl, ptr, calldatasize(), 0, 0)

            let size := returndatasize()
            returndatacopy(ptr, 0, size)

            switch result
            case 0 {revert(ptr, size)}
            default {return(ptr, size)}
        }

     }
}