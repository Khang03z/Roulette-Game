// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./PlayerManager.sol";
import "./BetManager.sol";

contract RewardManager {
    PlayerManager public playerManager;
    BetManager public betManager;
    address public owner;

    event RewardDistributed(address indexed player, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can execute this function.");
        _;
    }

    constructor(address payable _playerManager, address _betManager) {
        playerManager = PlayerManager(_playerManager);
        betManager = BetManager(_betManager);
        owner = msg.sender;
    }

    function distributeRewards(uint256 gameID) external onlyOwner {
        uint8 result = betManager.results(gameID);
        require(result >= 0 && result <= 36, "Invalid result for the game.");

        BetManager.Bet[] memory gameBets = betManager.getBets(gameID);

        for (uint256 i = 0; i < gameBets.length; i++) {
            BetManager.Bet memory bet = gameBets[i];
            uint256 reward = 0;

            if (bet.betType == 1) {
                // Chẵn/lẻ: Tỷ lệ 1:1
                if ((result != 0) && (result % 2 == bet.betValue % 2)) {
                    reward = bet.amount * 2;
                }
            } else if (bet.betType == 2) {
                // Đỏ/đen: Tỷ lệ 1:1
                bool isRed = isRedNumber(result);
                if ((bet.betValue == 1 && isRed) || (bet.betValue == 2 && !isRed)) {
                    reward = bet.amount * 2;
                }
            } else if (bet.betType == 3) {
                // 1st12, 2nd12, 3rd12: Tỷ lệ 2:1
                if ((bet.betValue == 1 && result >= 1 && result <= 12) ||
                    (bet.betValue == 2 && result >= 13 && result <= 24) ||
                    (bet.betValue == 3 && result >= 25 && result <= 36)) {
                    reward = bet.amount * 3;
                }
            } else if (bet.betType == 4) {
                // Cược số: Tỷ lệ 35:1
                if (result == bet.betValue) {
                    reward = bet.amount * 36;
                }
            }

            // Phân phối phần thưởng nếu có
            if (reward > 0) {
                playerManager.updateProfit(bet.player, reward);
                emit RewardDistributed(bet.player, reward);
            }
        }
    }

    function isRedNumber(uint8 result) internal pure returns (bool) {
        return (result == 1 || result == 3 || result == 5 || result == 7 ||
                result == 9 || result == 12 || result == 14 || result == 16 || 
                result == 18 || result == 19 || result == 21 || result == 23 || 
                result == 25 || result == 27 || result == 30 || result == 32 || 
                result == 34 || result == 36);
    }

}
