// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";

contract EIP712MetaTransaction is EIP712{
    struct MetaTransaction{
        uint256 nonce;
        address from;
        bytes functionSignature;
    }

    mapping(address => uint256) private nonces;

    bytes32 private constant META_TRANSACTION_TYPEHASH = keccak256("MetaTransaction(uint256 nonce,address from,bytes functionSignature)");

    constructor (string memory name, string memory version) EIP712(name, version) {}

    function executeMetaTransaction(address userAddress, bytes memory functionSignature, bytes32 sigR, bytes32 sigS, uint8 sigV) public view returns (bool){
        MetaTransaction memory metaTx = MetaTransaction({
            nonce: nonces[userAddress],
            from: userAddress,
            functionSignature: functionSignature
        });

        bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(META_TRANSACTION_TYPEHASH, metaTx.nonce, metaTx.from, keccak256(metaTx.functionSignature))));

        address signer = ECDSA.recover(digest, sigV, sigR, sigS);
        require(signer == userAddress, "Invalid signature");

        nonces[userAddress]++;

        (bool success, bytes memory returnData) = address(this).call(abi.encodePacked(functionSignature, userAddress));
        require(success, "Function call failed");

        return returnData;

    }


}