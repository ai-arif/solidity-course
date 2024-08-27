// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract MetaTransaction{
    mapping(address => uint256) public nonces;

    struct MetaData{
        uint256 nonce;
        address from;
        bytes functionSignature;
    }

    function executeMetaTransaction(address userAddress, bytes memory functionSignature, bytes32 sigR, bytes32 sigS, uint8 sigV) public returns (bytes memory){
        MetaData memory metaData = MetaData(nonces[userAddress], userAddress, functionSignature);
        require(verify(userAddress, metaData, sigR, sigS, sigV), "Signature not valid");

        nonces[userAddress]++;

        (bool success, bytes memory returnData) = address(this).call(abi.encodePacked(functionSignature, userAddress));
        require(success, "Function call failed");
        
        return returnData;
    }

    function verify(address signer, MetaData memory metaData, bytes32 sigR, bytes32 sigS, uint8 sigV) internal pure returns (bool){
        return signer == ecrecover(toEthSignedMessageHash(keccak256(abi.encode(metaData))), sigV, sigR, sigS);

    }

    function toEthSignedMessageHash(bytes32 hash) internal pure returns(bytes32){
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
    }
}