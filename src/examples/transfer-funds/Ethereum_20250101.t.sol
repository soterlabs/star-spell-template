// SPDX-License-Identifier: AGPL-3.0
pragma solidity 0.8.25;

import { LiquidityLayerTestBase } from "../../test-harness/LiquidityLayerTestBase.sol";

import { IERC20 } from "forge-std/interfaces/IERC20.sol";

import { Ethereum } from "../../address-registry/Ethereum.sol";

import { Ethereum_20250101 as Spell } from "./Ethereum_20250101.sol";

import { ChainIdUtils } from "../../libraries/ChainId.sol";

contract Ethereum_20250101Test is LiquidityLayerTestBase {

    Spell internal SPELL;

    constructor() {
        id = "20250101";
    }

    function _setupAddresses() internal virtual {
        SPELL = Spell(chainData[ChainIdUtils.Ethereum()].payload);
    }

    function setUp() public {
        setupMainnetDomain({ mainnetForkBlock: 24055133 });
        _setupAddresses();

        deal(SPELL.ASSET(), Ethereum.ALM_PROXY, SPELL.AMOUNT());
        vm.startPrank(Ethereum.ALM_PROXY);
        IERC20(SPELL.ASSET()).approve(Ethereum.SUB_PROXY, type(uint256).max);
        vm.stopPrank();
    }

    function test_transferUSDSFromAlmProxyToRecipient() public {
        uint256 recipientBefore = IERC20(SPELL.ASSET()).balanceOf(SPELL.RECIPIENT());
        uint256 proxyBefore = IERC20(SPELL.ASSET()).balanceOf(Ethereum.ALM_PROXY);

        executeMainnetPayload();

        assertEq(
            IERC20(SPELL.ASSET()).balanceOf(SPELL.RECIPIENT()),
            recipientBefore + SPELL.AMOUNT(),
            "recipient-should-receive-amount"
        );
        assertEq(
            IERC20(SPELL.ASSET()).balanceOf(Ethereum.ALM_PROXY),
            proxyBefore - SPELL.AMOUNT(),
            "alm-proxy-balance-should-decrease"
        );
    }

    function test_ETHEREUM_PayloadBytecodeMatches() public {
        _assertPayloadBytecodeMatches(ChainIdUtils.Ethereum());
    }
}
