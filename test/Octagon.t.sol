// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Octagon} from "../src/Octagon.sol";

contract CounterTest is Test {
    Octagon public oct;

    struct Fight {

        address fighter1;
        bool fighter1Paid;
        address fighter2;
        bool fighter2Paid;
        address oracle;
        uint256 wager;
        address winner;
        bool locked;
    }

    function setUp() public {
        oct = new Octagon();
    }

    function testInitalize() public {
        address bob = address(0x1);
        address alice = address(0x2);
        address oracle = address(0x3);
        uint256 wager = 100;
        uint256 _id = oct.initializeFight(bob, alice, oracle, wager);
        Fight memory fight = oct.fights(_id);
        assertEq(fight.fighter1, bob);
        assertEq(fight.fighter2, alice);
        assertEq(fight.oracle, oracle);
        assertEq(fight.wager, wager);
        assertEq(fight.winner, address(0));
        assertEq(fight.locked, false);
        
    }
}
