// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Advanced{
    //event in solidity 

    uint public number;

    event Number(address indexed _from,uint value);

    function setNumber(uint _number) public returns(uint){
        number = _number;
        
        emit Number(msg.sender, _number);
        return number;
    }

    //error handling in solidity

// require() is used for input validation and access control, refunds unused gas, and allows custom error messages.
// assert() is for internal consistency checks that should never be false, consumes all gas if it fails, and doesn't allow custom messages.
// revert() is for custom error handling, often used in complex conditions, refunds unused gas, and can be used with or without error messages.

    uint public number1 = 50; 

    function checkNumber(uint _number) public {
        require(number < 100, "Number should be less than 100");

        if(number > 100){
            revert("Number can't be greater than 100");
        }

        number = _number;

        assert(number > 50 && number < 100);
    }

    //Memory vs Storage
    //Storage: Direct HardDrive, Memory: RAM

   
    uint[] public myArray;  // Stored in storage

    function addToArray(uint[] memory newValues) public {
        // newValues is in memory
        for(uint i = 0; i < newValues.length; i++) {
            myArray.push(newValues[i]);  // Writing to storage
        }
    }

    function getArrayLength() public view returns (uint) {
        uint[] memory tempArray = myArray;  // Creates a copy in memory
        return tempArray.length;  // Returns length of the memory array
    }
    //Mapping

    mapping(address => uint)  balances;

    function setBalance(uint _value) public {
        balances[msg.sender] = _value; // Mapping from address to uint
    }



    //Array

    //Fixed Size Array
    uint[5] public fixedSizeArray;

    // //Dynamic size Array
    uint[] public dynamicSizeArray;

    function addToDynamicArray(uint value) public{
        dynamicSizeArray.push(value); // Writing to storage
    }

    //   // Fixed Size Array is stored in memory and Dynamic Size Array is stored on the blockchain

    function updateFixedArray(uint _index,uint _value) public {
        require(_index<5, "Size is not more than 5");
        fixedSizeArray[_index] = _value; // Writing to storage
    }


    //Custom data type where we can put multiple variables

    struct Student{
        address studentAddress;
        uint studentBalance;
        string name;
    }

    Student public student1;
    Student[] public students;

    function createStudent(string memory _name) public {
        student1 = Student(msg.sender, 1, _name);
    }


    //Enum -> User defined pre-set of some constants

    enum Result {pending, failed,  success}

    Result public result;

    function setResult(Result _result) public {
        result = _result; // Writing to storage
    }



}