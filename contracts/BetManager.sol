// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./PlayerManager.sol";  // Giả sử bạn đã có contract PlayerManager

contract BetManager {
    // Cấu trúc lưu trữ thông tin về mỗi cược
    struct Bet {
        address player;      // Địa chỉ người chơi
        uint256 amount;      // Số tiền cược
        uint8 betType;       // Loại cược (1: Chẵn, lẻ, 2: Đen, đỏ, 3: 1st12, 2nd12, 3rd12, 4: số)
        uint256 betValue;    // Giá trị cược (Số nếu betType là số)
    }

    // Các biến công khai
    PlayerManager public playerManager;
    address public owner;  // Chủ sở hữu hợp đồng
    uint256 public currentIDgame;  // ID game hiện tại
    
    // Các mapping để lưu trữ cược và kết quả của các game
    mapping(uint256 => Bet[]) public bets;  // Lưu trữ các cược của từng game theo ID (mảng Bet)
    mapping(uint256 => uint8) public results; // Lưu trữ kết quả của từng game

    // Sự kiện khi người chơi đặt cược và khi kết quả được tạo ra
    event BetPlaced(address indexed player, uint256 amount, uint8 betType, uint256 betValue);
    event ResultGenerated(uint256 gameID, uint8 result);

    // Modifier chỉ cho phép chủ sở hữu thực thi
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can set result");
        _;
    }

    // Constructor khởi tạo contract BetManager với PlayerManager
    constructor(address payable _playerManager) {
        playerManager = PlayerManager(_playerManager);
        owner = msg.sender;
    }

    // Hàm đặt cược
    function placeBet(uint8 betType, uint256 betValue) external payable {
        // Kiểm tra nếu người chơi đã đăng ký
        bool isRegistered = playerManager.checkIsRegistered(msg.sender);
        require(isRegistered, "Player is not registered.");

        // Kiểm tra số tiền cược phải lớn hơn 0
        require(msg.value > 0, "Bet amount must be greater than zero.");

        // Kiểm tra tính hợp lệ của lựa chọn (betValue) tùy theo betType
        if (betType == 1) {  // Cược chẵn/lẻ
            require(betValue == 1 || betValue == 2, "Invalid choice. Choose 1 for Odd or 2 for Even.");
        } else if (betType == 2) {  // Cược màu đỏ/đen
            require(betValue == 1 || betValue == 2, "Invalid choice. Choose 1 for Red or 2 for Black.");
        } else if (betType == 3) {  // Cược 1st12, 2nd12, 3rd12
            require(betValue >= 1 && betValue <= 3, "Invalid choice. Choose between 1, 2, or 3 for 12 sections.");
        } else if (betType == 4) {  // Cược số
            require(betValue >= 0 && betValue <= 36, "Invalid number. Choose a number between 0 and 36.");
        }

        // Tăng ID game
        currentIDgame++;

        // Giảm số dư của người chơi khi đặt cược
        playerManager.decreaseBalance(msg.sender, msg.value);

        // Cập nhật thông tin cược của người chơi cho game hiện tại
        bets[currentIDgame].push(Bet({
            player: msg.sender,
            amount: msg.value,
            betType: betType,
            betValue: betValue
        }));

        // Phát sự kiện BetPlaced
        emit BetPlaced(msg.sender, msg.value, betType, betValue);
    }

    // Hàm truy vấn thông tin cược của người chơi cho một game cụ thể
    function getBetInfo(uint256 gameID, address player) external view returns (uint256 amount, uint8 betType, uint256 betValue) {
        Bet[] memory gameBets = bets[gameID];
        for (uint256 i = 0; i < gameBets.length; i++) {
            if (gameBets[i].player == player) {
                return (gameBets[i].amount, gameBets[i].betType, gameBets[i].betValue);
            }
        }
        revert("Bet not found for the player in this game.");
    }

    // Hàm getter trả về các cược của một game cụ thể
    function getBets(uint256 gameID) external view returns (Bet[] memory) {
        return bets[gameID];
    }

    // Hàm quay vòng quay
    function spinWheel() external onlyOwner {
        // Kết quả ngẫu nhiên từ 0 đến 36
        uint8 result = uint8(uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, currentIDgame))) % 37);
        
        // Lưu trữ kết quả
        results[currentIDgame] = result;

        // Phát sự kiện ResultGenerated
        emit ResultGenerated(currentIDgame, result);

        // Tăng ID game cho vòng quay tiếp theo
        currentIDgame++;
    }
}
