// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./PlayerManager.sol"; // Giả sử bạn đã có contract PlayerManager

contract BetManager {
    struct Bet {
        address player;
        uint256 amount;
        uint8 betType;
        uint256 betValue;
    }

    PlayerManager public playerManager;
    address public owner;
    uint256 public currentIDgame = 1;

    uint256 public maxBetAmount = 1 ether;

    mapping(uint256 => Bet[]) public bets;
    mapping(uint256 => uint8) public results;
    mapping(uint256 => address[]) public playerList;

    event BetPlaced(address indexed player, uint256 amount, uint8 betType, uint256 betValue);
    event ResultGenerated(uint256 gameID, uint8 result);
    event WinningsDistributed(address indexed player, uint256 amount, address _owner);

   modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action.");
    _   ;
    }

  constructor(address payable _playerManager) {
        playerManager = PlayerManager(_playerManager);
        owner=msg.sender;
    }

    function placeBet(uint8 betType, uint256 betValue, uint256 betAmount) external {
        require(betAmount > 0 && betAmount <= maxBetAmount, "Invalid bet amount.");

        if (betType == 1) {
            require(betValue == 1 || betValue == 2, "Invalid choice: 1 for Odd, 2 for Even.");
        } else if (betType == 2) {
            require(betValue == 1 || betValue == 2, "Invalid choice: 1 for Red, 2 for Black.");
        } else if (betType == 3) {
            require(betValue >= 1 && betValue <= 3, "Invalid choice: 1, 2, or 3 for sections.");
        } else if (betType == 4) {
            require(betValue >= 0 && betValue <= 36, "Invalid number: 0 to 36.");
        } else {
            revert("Invalid bet type.");
        }

        uint256 playerBalance = playerManager.getBalance(msg.sender);
        require(playerBalance >= betAmount, "Insufficient balance.");

        bets[currentIDgame].push(Bet({
            player: msg.sender,
            amount: betAmount,
            betType: betType,
            betValue: betValue
        }));

        if (!isPlayerInGame(currentIDgame, msg.sender)) {
            playerList[currentIDgame].push(msg.sender);
        }

        playerManager.decreaseBalance(msg.sender,betAmount);
        emit BetPlaced(msg.sender, betAmount, betType, betValue);
    }

    function isPlayerInGame(uint256 gameID, address player) internal view returns (bool) {
        address[] memory players = playerList[gameID];
        for (uint256 i = 0; i < players.length; i++) {
            if (players[i] == player) {
                return true;
            }
        }
        return false;
    }

    function spinWheel() external onlyOwner {
        uint8 result = uint8(uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, currentIDgame))) % 37);
        results[currentIDgame] = result;
        emit ResultGenerated(currentIDgame, result);
        distributeWinnings(currentIDgame, result);
        currentIDgame++;
    }

    function distributeWinnings(uint256 gameID, uint8 result) internal {
    Bet[] memory gameBets = bets[gameID];

    for (uint256 i = 0; i < gameBets.length; i++) {
        Bet memory bet = gameBets[i];
        uint256 winnings = 0;

        // Tính toán tiền thưởng tùy theo loại cược và kết quả
        if (bet.betType == 4 && bet.betValue == result) {
            winnings = bet.amount * 36;
        } else if (bet.betType == 1 && ((result % 2 == 0 && bet.betValue == 2) || (result % 2 != 0 && bet.betValue == 1))) {
            winnings = bet.amount * 2;
        } else if (bet.betType == 2 && ((isRed(result) && bet.betValue == 1) || (!isRed(result) && bet.betValue == 2))) {
            winnings = bet.amount * 2;
        } else if (bet.betType == 3 && ((result >= 1 && result <= 12 && bet.betValue == 1) || (result >= 13 && result <= 24 && bet.betValue == 2) || (result >= 25 && result <= 36 && bet.betValue == 3))) {
            winnings = bet.amount * 3;
        }

        // Nếu có tiền thưởng, cập nhật số dư cho người chơi trong PlayerManager
        if (winnings > 0) {
            playerManager.updateProfit(bet.player, winnings, msg.sender);  // Cập nhật số dư cho người chơi
            emit WinningsDistributed(bet.player, winnings, msg.sender);  // Emit sự kiện phân phối tiền thưởng
        }
    }
}


    function isRed(uint8 number) internal pure returns (bool) {
        uint8[18] memory redNumbers = [1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36];
        for (uint8 i = 0; i < redNumbers.length; i++) {
            if (redNumbers[i] == number) {
                return true;
            }
        }
        return false;
    }

    function getBetInfo(uint256 gameID, address player) external view returns (uint256 amount, uint8 betType, uint256 betValue) {
        Bet[] memory gameBets = bets[gameID];
        for (uint256 i = 0; i < gameBets.length; i++) {
            if (gameBets[i].player == player) {
                return (gameBets[i].amount, gameBets[i].betType, gameBets[i].betValue);
            }
        }
        revert("Bet not found for the player in this game.");
    }

    function getPlayers(uint256 gameID) external view returns (address[] memory) {
        return playerList[gameID];
    }
}
