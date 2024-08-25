// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Proxy{
    address public implementation;
    address public admin;

    constructor(address _implementation){
        implementation = _implementation;
        admin = msg.sender;
    }

    function upgradeContract(address newImplementation) external{
        require(admin == msg.sender, "only admin can do this");

        implementation = newImplementation;
    }

    fallback() external { 
        address _imp = implementation;
        assembly{
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(),_imp, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())
            switch result

            case 0 { revert (0, returndatasize())}
            default {return (0, returndatasize())}
        }
    }
}