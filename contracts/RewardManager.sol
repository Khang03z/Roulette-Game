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
        playerManager = PlayerManager(_playerManager); // Gán địa chỉ vào contract PlayerManager
        betManager = BetManager(_betManager);// Gán địa chỉ vào contract BetManager
        owner = msg.sender;
    }

    function distributeRewards(uint256 gameID) external onlyOwner {
        uint8 result = betManager.results(gameID);
        require(result >= 0 && result <= 36, "Invalid result for the game.");

        // Lấy tất cả các cược của game với gameID
        BetManager.Bet[] memory gameBets = betManager.getBets(gameID);
    
        // Kiểm tra xem số đỏ hay đen chỉ một lần
        bool isRed = isRedNumber(result);
    
        // Tối ưu hóa vòng lặp qua các cược
    for (uint256 i = 0; i < gameBets.length; i++) {
        BetManager.Bet memory bet = gameBets[i];
        uint256 reward = calculateReward(bet, result, isRed);
        
        // Nếu có phần thưởng, gửi phần thưởng
        if (reward > 0) {
            playerManager.updateProfit(bet.player, reward);
            emit RewardDistributed(bet.player, reward);
        }
    }
}

function calculateReward(BetManager.Bet memory bet, uint8 result, bool isRed) private pure returns (uint256) {
    uint256 reward = 0;

    // Chẵn/Lẻ
    if (bet.betType == 1) {
        if (result != 0 && result % 2 == bet.betValue % 2) {
            reward = bet.amount * 2;
        }
    } 
    // Đỏ/Đen
    else if (bet.betType == 2) {
        if ((bet.betValue == 1 && isRed) || (bet.betValue == 2 && !isRed)) {
            reward = bet.amount * 2;
        }
    } 
    // 1st12, 2nd12, 3rd12
    else if (bet.betType == 3) {
        if ((bet.betValue == 1 && result >= 1 && result <= 12) ||
            (bet.betValue == 2 && result >= 13 && result <= 24) ||
            (bet.betValue == 3 && result >= 25 && result <= 36)) {
            reward = bet.amount * 3;
        }
    } 
    // Cược số
    else if (bet.betType == 4) {
        if (result == bet.betValue) {
            reward = bet.amount * 36;
        }
    }

    return reward;
}


    function isRedNumber(uint8 result) internal pure returns (bool) {
        return (result == 1 || result == 3 || result == 5 || result == 7 ||
                result == 9 || result == 12 || result == 14 || result == 16 || 
                result == 18 || result == 19 || result == 21 || result == 23 || 
                result == 25 || result == 27 || result == 30 || result == 32 || 
                result == 34 || result == 36);
    }

}
