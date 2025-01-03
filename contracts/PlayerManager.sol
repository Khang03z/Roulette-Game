// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PlayerManager {
    struct Player {
        address wallet;
        uint256 balance;
        bool isRegistered;
    }

    address public owner;
    mapping(address => Player) public players;

    event PlayerRegistered(address indexed playerAddress);
    event BalanceUpdated(address indexed playerAddress, uint256 newBalance);
    event Withdraw(address indexed player, uint256 amount);
    event Received(address indexed sender, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function registerPlayer() external {
        require(!players[msg.sender].isRegistered, "Player is already registered.");
        players[msg.sender] = Player(msg.sender, 0, true);
        emit PlayerRegistered(msg.sender);
    }

    function deposit() external payable {
        require(players[msg.sender].isRegistered, "Player is not registered.");
        players[msg.sender].balance += msg.value;
        emit BalanceUpdated(msg.sender, players[msg.sender].balance);
    }

    function updateProfit(address player, uint256 amount, address _check) external  {
        require(_check == owner,"Only owner can Update profit");
        require(players[player].isRegistered, "Player is not registered.");
        players[player].balance += amount;
        emit BalanceUpdated(player, players[player].balance);
    }

    function getBalance(address player) external view returns (uint256) {
        require(players[player].isRegistered, "Player is not registered.");
        return players[player].balance;
    }

    function decreaseBalance(address player, uint256 amount) external {
    require(players[player].isRegistered, "Player is not registered.");
    require(players[player].balance >= amount, "Insufficient balance.");
    players[player].balance -= amount;
    emit BalanceUpdated(player, players[player].balance);
}

    function withdrawBalance(uint256 amount) external {
        require(players[msg.sender].isRegistered, "Player is not registered.");
        require(amount > 0, "Amount must be greater than 0.");
        require(players[msg.sender].balance >= amount, "Insufficient balance.");

        players[msg.sender].balance -= amount;

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed.");

        emit BalanceUpdated(msg.sender, players[msg.sender].balance);
    }

    receive() external payable {
        emit Received(msg.sender, msg.value);
    }

    fallback() external payable {
        emit Received(msg.sender, msg.value);
    }
}
