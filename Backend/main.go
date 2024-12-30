package main

import (
	"encoding/json"
	"fmt"
	"log"
)

// Định nghĩa cấu trúc của ABI
type ABI struct {
	Inputs        []Input   `json:"inputs"`
	StateMutability string   `json:"stateMutability"`
	Type          string   `json:"type"`
	Name          string   `json:"name,omitempty"`
	Outputs       []Output `json:"outputs,omitempty"`
	Anonymous     bool     `json:"anonymous,omitempty"`
}

type Input struct {
	InternalType string `json:"internalType"`
	Name         string `json:"name"`
	Type         string `json:"type"`
	Indexed      bool   `json:"indexed,omitempty"`
}

type Output struct {
	InternalType string `json:"internalType"`
	Name         string `json:"name"`
	Type         string `json:"type"`
}

type ContractData struct {
	Format      string `json:"_format"`
	ContractName string `json:"contractName"`
	SourceName  string `json:"sourceName"`
	ABI         []ABI  `json:"abi"`
	Bytecode    string `json:"bytecode"`
}

func main() {
	// Dữ liệu JSON bạn cung cấp (cần thêm dấu " vào đầu và cuối chuỗi JSON)
	data := `{
		"_format": "hh-sol-artifact-1",
		"contractName": "PlayerManager",
		"sourceName": "contracts/PlayerManager.sol",
		"abi": [
			{
				"inputs": [],
				"stateMutability": "nonpayable",
				"type": "constructor"
			},
			{
				"anonymous": false,
				"inputs": [
					{
						"indexed": true,
						"internalType": "address",
						"name": "playerAddress",
						"type": "address"
					},
					{
						"indexed": false,
						"internalType": "uint256",
						"name": "newBalance",
						"type": "uint256"
					}
				],
				"name": "BalanceUpdated",
				"type": "event"
			}
		],
		"bytecode": "0x608060405234801561001057600080fd5b50336000806101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055506110d4806100606000396000f3fe..."
	}`

	// Giải mã JSON vào cấu trúc Go
	var contractData ContractData
	err := json.Unmarshal([]byte(data), &contractData)
	if err != nil {
		log.Fatalf("Error unmarshalling JSON: %v", err)
	}

	// In thông tin hợp đồng
	fmt.Printf("Contract Name: %s\n", contractData.ContractName)
	fmt.Printf("Source Name: %s\n", contractData.SourceName)
	fmt.Printf("Bytecode: %s\n", contractData.Bytecode)
	fmt.Println("ABI:")
	for _, item := range contractData.ABI {
		fmt.Printf("  - Type: %s, Name: %s, State Mutability: %s\n", item.Type, item.Name, item.StateMutability)
		for _, input := range item.Inputs {
			fmt.Printf("    Input - Name: %s, Type: %s, Internal Type: %s, Indexed: %v\n", input.Name, input.Type, input.InternalType, input.Indexed)
		}
		for _, output := range item.Outputs {
			fmt.Printf("    Output - Name: %s, Type: %s, Internal Type: %s\n", output.Name, output.Type, output.InternalType)
		}
	}
}
