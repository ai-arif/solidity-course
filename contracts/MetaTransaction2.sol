// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract MetaTransactionReceiver{
    using ECDSA for bytes32;

    mapping(address => uint256) public nonces;


    function executeMetaTransaction(address userAddress, bytes memory functionSignature, bytes32 sigR, bytes32 sigS, 
    uint8 sigV) public returns(bytes memory) {
        bytes32 hash = keccak256(abi.encodePacked(userAddress, nonces[userAddress], functionSignature));
        // bytes32 messageHash = hash.toEthSignedMessageHash();
        // address signer = messageHash.recover(sigR, sigS, sigV);

        // require(signer == userAddress, "Signature does not match");
        // require(signer != address(0), "Invalid signature");

        (bool success, bytes memory returnData) = address(this).call(abi.encodePacked(functionSignature, userAddress));
        require(success, "Function call failed");

        return returnData;
    
    }


    function setUserValue() public view{
        require(msg.sender == address(this), "Direct calls not allowed");
    }

    function toEthSignedMessageHash(bytes32 hash) internal pure returns(bytes32){
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
    }

}    