// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "./../../src/CTFs/SideEntranceLenderPool.sol";

contract SideEntranceLenderPoolTest is Test {
    SideEntranceLenderPool public sideEntranceLenderPool;
    FlashLoanEtherReceiver public flashLoanEtherReceiver;

    function setUp() public {
        // Deploy contracts
        sideEntranceLenderPool = new SideEntranceLenderPool();
        sideEntranceLenderPool.deposit{value: 1000 ether}();
        flashLoanEtherReceiver = new FlashLoanEtherReceiver(
            sideEntranceLenderPool
        );
    }

    function testAttack() public {
        flashLoanEtherReceiver.runFlashloan();
        flashLoanEtherReceiver.withdraw();

        _checkSolved();
    }

    function _checkSolved() internal {
        assertTrue(
            address(sideEntranceLenderPool).balance == 0,
            "Challenge Incomplete"
        );
    }
}
