// SPDX-License-Identifier: AGPL-3.0
pragma solidity 0.8.25;

import { IERC20 } from "forge-std/interfaces/IERC20.sol";

import { PayloadEthereum } from "../../libraries/PayloadEthereum.sol";

import { Ethereum } from "../../address-registry/Ethereum.sol";

/**
 * @title  January 01, 2025 _AGENT_ Ethereum Proposal
 * @notice execute transfer to RECIPIENT
 * @author _AGENT_ 
 * Forum Post: https://forum.sky.money/t/example/
 * Vote Link:  https://vote.sky.money/executive/example
 */
contract Ethereum_20250101 is PayloadEthereum {

    address public constant RECIPIENT = 0x000000000000000000000000000000000000dEaD;

    address public constant ASSET = Ethereum.USDS;

    uint256 public constant AMOUNT = 1_000e18;

    function _execute() internal override {
        require(IERC20(ASSET).transferFrom(Ethereum.ALM_PROXY, RECIPIENT, AMOUNT), "transfer-failed");
    }
}
