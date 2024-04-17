// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Octagon {

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

    mapping(uint256 => Fight) private fights;
    mapping(address => Fight) public userFights;
    uint256 private fightId = 0;

    function initializeFight(address _fighter1, address _fighter2, address _oracle, uint256 _wager) public returns (uint256) {
        require(userFights[_fighter1].wager == 0, "Fighter 1 is already in a fight");
        require(userFights[_fighter2].wager == 0, "Fighter 2 is already in a fight");
        uint256 _fightId = ++fightId;
        fights[_fightId] = Fight(_fighter1, false, _fighter2, false, _oracle, _wager, address(0), false);
        userFights[_fighter1] = fights[_fightId];
        userFights[_fighter2] = fights[_fightId];
    }

    function lockFight(uint256 _fightId) public {
        require(msg.sender == fights[_fightId].oracle, "You are not the oracle");
        require(fights[_fightId].fighter1Paid == true, "Fighter 1 has not paid");
        require(fights[_fightId].fighter2Paid == true, "Fighter 2 has not paid");
        fights[_fightId].locked = true;
    }

    function settleFight(uint256 _fightId, address _winner) public {
        require(msg.sender == fights[_fightId].oracle, "You are not the oracle");
        require(fights[_fightId].locked == true, "The fight is not locked");
        require(fights[_fightId].winner == address(0), "The fight has already been settled");
        fights[_fightId].winner = _winner;
        if (_winner == fights[_fightId].fighter1) {
            payable(fights[_fightId].fighter1).transfer(fights[_fightId].wager * 2);
        } else {
            payable(fights[_fightId].fighter2).transfer(fights[_fightId].wager * 2);
        }
        delete userFights[fights[_fightId].fighter1];
        delete userFights[fights[_fightId].fighter2];
    }


    fallback() external payable {
        require(userFights[msg.sender].wager != 0, "You are not in a fight");
        require(userFights[msg.sender].locked == false, "The fight is locked");
        require(msg.value == userFights[msg.sender].wager, "You must send the correct amount of money");
        if (msg.sender == userFights[msg.sender].fighter1) {
            userFights[msg.sender].fighter1Paid = true;
        } else {
            userFights[msg.sender].fighter2Paid = true;
        }
    }   

}
