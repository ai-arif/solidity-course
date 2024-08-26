// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract SimpleBridge{
    mapping(string => bool) public processedTransactions;
    address[] public validators;
    uint256 public requiredSignatures;

    event BridgeTransfer(address from, address to,  uint256 amount, uint256 nonce);

    constructor(address[] memory _validators, uint256 _requiredSignatures){
        validators = _validators;
        requiredSignatures = _requiredSignatures;
    }

    function transferCrossChain(address to, uint256 amount, uint256 nonce, bytes32[] memory signatures) internal{
        bytes32 messageHash = keccak256(abi.encodePacked(msg.sender, to, amount, nonce));
        // require(!processedTransactions[messageHash], "Transaction already processed");

        uint256 signatureCount = 0;

        for(uint256 i = 0; i < signatures.length; i++){
            address signer = recoverSigner(messageHash, signatures[i]);
            if(isValidator(signer)){
                signatureCount++;
            }
        }

        require(signatureCount >= requiredSignatures, "Insufficient valid signatures");

        // processedTransactions[messageHash] = true;

        emit BridgeTransfer(msg.sender, to, amount, nonce);

    }

    function isValidator(address signer) internal view returns(bool){
        for(uint256 i = 0; i<validators.length; i++){
            if(validators[i] == signer){
                return true;
            }
        }
        return false;
    }

    function recoverSigner(bytes32 message, bytes32 signature) internal pure returns(address){

    }
}