// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Contract quản lý người chơi, bao gồm địa chỉ ví, số dư, và kiểm tra đăng ký.
contract PlayerManager {
    
    // Cấu trúc để lưu trữ thông tin của người chơi
    struct Player {
        address wallet;       // Địa chỉ ví người chơi
        uint256 balance;      // Số dư người chơi trong smart contract
        bool isRegistered;    // Kiểm tra người chơi đã đăng ký chưa
    }

    address public owner;  // Chủ sở hữu hợp đồng

    // Mapping để lưu trữ thông tin người chơi theo địa chỉ ví
    mapping(address => Player) public players;

    // Sự kiện khi người chơi đăng ký hoặc cập nhật số dư
    event PlayerRegistered(address indexed playerAddress);
    event BalanceUpdated(address indexed playerAddress, uint256 newBalance);
    event Withdraw(address indexed player, uint256 amount);

    // Modifier cho phép chỉ chủ sở hữu thực thi các hàm
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can set the result");
        _;
    }

    // Hàm đăng ký người chơi mới
    function registerPlayer() external {
        require(!players[msg.sender].isRegistered, "Player is already registered.");

        // Lưu thông tin người chơi mới vào mapping
        players[msg.sender] = Player({
            wallet: msg.sender,
            balance: 0,
            isRegistered: true
        });

        emit PlayerRegistered(msg.sender);
    }

    // Hàm nạp tiền vào số dư của người chơi
    function deposit() external payable {
        require(players[msg.sender].isRegistered, "Player is not registered.");

        // Cộng số tiền nạp vào số dư của người chơi
        players[msg.sender].balance += msg.value;

        emit BalanceUpdated(msg.sender, players[msg.sender].balance);
    }

    // Hàm cập nhật số dư của người chơi khi thắng
    function updateProfit(address player, uint256 amount) external onlyOwner {
        require(players[player].isRegistered, "Player is not registered.");
        
        // Cập nhật số dư của người chơi
        players[player].balance += amount;
        
        emit BalanceUpdated(player, players[player].balance);
    }

    // Hàm lấy số dư của người chơi
    function getBalance() external view returns (uint256) {
        require(players[msg.sender].isRegistered, "Player is not registered.");
        
        return players[msg.sender].balance;
    }

    // Hàm kiểm tra người chơi đã đăng ký chưa
    function checkIsRegistered(address playerAddress) external view returns (bool) {
        return players[playerAddress].isRegistered;
    }

    // Hàm trừ số dư của người chơi
    function decreaseBalance(address player, uint256 amount) external {
        require(players[player].balance >= amount, "Insufficient balance.");

        // Giảm số dư của người chơi
        players[player].balance -= amount;
    }

    // Hàm rút số dư từ tài khoản người chơi
    function withdrawBalance(uint256 amount) external {
        require(players[msg.sender].isRegistered, "Player is not registered.");
        require(players[msg.sender].balance >= amount, "Insufficient balance.");

        // Giảm số dư và chuyển tiền cho người chơi
        players[msg.sender].balance -= amount;
        payable(msg.sender).transfer(amount);

        emit BalanceUpdated(msg.sender, players[msg.sender].balance);
    }
    receive() external payable{}
    fallback() external payable{}

}
