require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

module.exports = {
  solidity: "0.8.18",
  networks: {
    sepolia: {
      url: "https://sepolia.infura.io/v3/a7e37d1584a14dd792994387a2cc359b", // URL của Sepolia
      accounts: [process.env.PRIVATE_KEY], // Lấy private key từ .env
    },
  },
};
