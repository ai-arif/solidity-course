// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract MyContract is AccessControl{
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant MODERATOR_ROLE = keccak256("MODERATOR_ROLE");

    constructor(){
        // _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function adminFunction() public onlyRole(ADMIN_ROLE) {
        //function body
    }

    function moderatorFunction() public onlyRole(MODERATOR_ROLE) {
        //function body
    }
}