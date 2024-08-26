// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";


contract CrossChainDataConsumer is ChainlinkClient{
    using Chainlink for Chainlink.Request;

    uint256 public crossChainData;
    address private oracle;
    bytes32 private jobId;
    uint256 private fee;

    constructor() {
        // setPublicChainlinkToken();
        oracle = 0x3A56aE4a2831C3d3514b5D7Af5578E45eBDb7a40;
        jobId = "3b7ca0d48c7a4b2da9268456665d11ae";
        fee = 0.1 * 10 ** 18; // 0.1 LINK
    }

    // function crossChain() public returns(bytes32 requestId){
    //     Chainlink.Request memory request = buildChainlinkRequest(jobId, address(this), this.fulfillCrossChainData.selector);
    //     requestId = sendChainlinkRequestTo(oracle, request, fee);
    // }

    function fulfillCrossChainData(bytes32 requestId, uint256 result) public recordChainlinkFulfillment(requestId) {
        crossChainData = result;
    }
}