package main

import (
	"fmt"
	"log"
	"strings"

	"github.com/ethereum/go-ethereum/accounts/abi"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/ethclient"
	"github.com/ethereum/go-ethereum/crypto"
	"github.com/ethereum/go-ethereum/rpc"
	"github.com/ethereum/go-ethereum"
	"github.com/ethereum/go-ethereum/accounts/abi"
	"github.com/ethereum/go-ethereum/rpc"
	"github.com/ethereum/go-ethereum/bind"
)

const (
	infuraURL         = "http://127.0.0.1:8545" // Địa chỉ node Ethereum (Hardhat)
	playerManagerAddr = "0x5FbDB2315678afecb367f032d93F642f64180aa3" // Địa chỉ hợp đồng PlayerManager
	playerManagerABI  = `[{"constant":false,"inputs":[],"name":"registerPlayer","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"amount","type":"uint256"}],"name":"withdrawBalance","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"getBalance","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"}]`
	privateKey        = "0xYourPrivateKeyHere" // Private Key của bạn (để gửi giao dịch)
)

func main() {
	// Kết nối tới Ethereum node
	client, err := ethclient.Dial(infuraURL)
	if err != nil {
		log.Fatalf("Failed to connect to the Ethereum client: %v", err)
	}

	// Đọc ABI của hợp đồng
	contractABI, err := abi.JSON(strings.NewReader(playerManagerABI))
	if err != nil {
		log.Fatalf("Failed to parse contract ABI: %v", err)
	}

	// Tạo đối tượng địa chỉ hợp đồng
	contractAddress := common.HexToAddress(playerManagerAddr)

	// Tạo đối tượng private key (ví dụ từ ví hoặc thông qua một biến môi trường)
	privateKey, err := crypto.HexToECDSA(privateKey)
	if err != nil {
		log.Fatalf("Failed to load private key: %v", err)
	}

	// Tạo một đối tượng transactor
	auth := bind.NewKeyedTransactor(privateKey)

	// Tạo một đối tượng hợp đồng
	contract, err := bind.NewBoundContract(contractAddress, contractABI, client, client, client)
	if err != nil {
		log.Fatalf("Failed to bind contract: %v", err)
	}

	// Gọi hàm registerPlayer
	tx, err := contract.Transact(auth, "registerPlayer")
	if err != nil {
		log.Fatalf("Failed to call registerPlayer: %v", err)
	}
	fmt.Printf("Transaction sent: %s\n", tx.Hash().Hex())
}
