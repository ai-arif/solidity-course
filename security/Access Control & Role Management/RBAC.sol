// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

//RBAC -> Role Based Access Control

contract RBAC{
    mapping(bytes32 => mapping(address => bool)) public roles;

    function addRole(bytes32 role, address account) internal {
        roles[role][account] = true;  //set true if the user has this role
    }

    modifier onlyRole(bytes32 role){
        require(roles[role][msg.sender], "Not authorized");
        _;
    }
}