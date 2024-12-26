const { ethers } = require("hardhat");

async function main() {
  // Lấy ví deploy
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);

  // Lấy số dư của ví deploy
  const balance = await ethers.provider.getBalance(deployer.address);
  console.log("Account balance:", ethers.formatEther(balance), "ETH");

  // Deploy PlayerManager
  const PlayerManager = await ethers.getContractFactory("PlayerManager");
  const playerManager = await PlayerManager.deploy(); // Triển khai contract
  await playerManager.waitForDeployment(); // Đảm bảo hợp đồng đã được triển khai
  console.log("PlayerManager deployed to:", playerManager.target);

  // Deploy BetManager
  const BetManager = await ethers.getContractFactory("BetManager");
  const betManager = await BetManager.deploy(playerManager.target); // Truyền địa chỉ PlayerManager
  await betManager.waitForDeployment(); // Đảm bảo hợp đồng đã được triển khai
  console.log("BetManager deployed to:", betManager.target);

  // Deploy RewardManager
  const RewardManager = await ethers.getContractFactory("RewardManager");
  const rewardManager = await RewardManager.deploy(playerManager.target, betManager.target); // Truyền địa chỉ PlayerManager và BetManager
  await rewardManager.waitForDeployment(); // Đảm bảo hợp đồng đã được triển khai
  console.log("RewardManager deployed to:", rewardManager.target);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
