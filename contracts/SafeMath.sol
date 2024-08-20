// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library SafeMath{
    function add(uint a, uint b) internal pure returns(uint) {
        uint c = a+b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }
}

contract SafeMathUingLibrary{
    using SafeMath for uint;

    function addTwoNumbers(uint a, uint b) public pure returns(uint){
        return a.add(b);
    }

    //Assembly Call

    function addAssemblyCall(uint x, uint y) public pure returns(uint){
        assembly{
            let result := add(x,y)
            mstore(0x0, result)
            return(0x0, 32)
        }
    }

    //Low-Level Calls

    function makeLowLevelCall(address payable _to, uint _amount, bytes memory _data) public payable returns(bool, bytes memory){
        return _to.call{value: _amount}(_data);
    }
}