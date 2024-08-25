// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract MultiSigWallet{
    address[] public owners;
    uint public required;

    struct Transaction{
        address to;
        uint value;
        bytes data;
        bool executed;
    }

    Transaction[] public transactions;

    mapping(uint => mapping(address => bool)) public confirmations;

    constructor(address[] memory _owners,uint _required){
        require(_owners.length > 0 && _required > 0 && _required <= _owners.length);
        owners = _owners;
        required = _required;
}

    function submitTransaction(address _to, uint _value, bytes memory _data) public {
        uint txIndex = transactions.length;
        transactions.push(Transaction(_to, _value, _data,false));

        confirmTransaction(txIndex);
    }

    function confirmTransaction(uint _txIndex) public {
        require(isOwner(msg.sender));
        require(!confirmations[_txIndex][msg.sender]);

        confirmations[_txIndex][msg.sender] = true;

        if(isconfirmed(_txIndex)){
            executeTransaction(_txIndex);
        }
    }

    function executeTransaction(uint _txIndex) public {
        require(isconfirmed(_txIndex));

        Transaction storage transaction = transactions[_txIndex];
        transaction.executed = true;

        (bool success, ) = transaction.to.call{value: transaction.value}(transaction.data);
        require(success);

    }

    function isconfirmed(uint _txIndex) public view returns(bool){
        uint count = 0;
        for(uint i = 0; i<owners.length; i++){
            if(confirmations[_txIndex][owners[i]]){
                count++;
                if(count == required)
                return true;
        }
        return false;
    }
}

    function isOwner(address _address) private view returns(bool){
        for(uint i = 0; i<owners.length; i++){
            if(owners[i] == _address) {return true;}
            return false;
        }
    }

}