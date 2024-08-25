// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract TimedAccess{
    uint256 public accessTime;
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "not the owner");
        _;
    }

    modifier duringAccess() {
        require(block.timestamp < accessTime, "Access expired");
        _;
    }

    function extendAccess(uint256 _extension) public onlyOwner{
        accessTime = block.timestamp + _extension;
    }
}