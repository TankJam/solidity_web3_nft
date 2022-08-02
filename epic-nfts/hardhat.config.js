require('@nomiclabs/hardhat-waffle');
require("@nomiclabs/hardhat-etherscan");
require("dotenv").config({ path: ".env" });

module.exports = {
  solidity: '0.8.9',
  networks: {
    rinkeby: {
      url: process.env.ALCHEMY_API_KEY_URL,
      accounts: [process.env.RINKEBY_PRIVATE_KEY],
    },
  },
  etherscan: {
    // Your API key for Etherscan
    // Obtain one at https://etherscan.io/
    // 0x533c99FeBbeAd431F3c48562Fb3b112c6F82AA75
    apiKey: process.env.ETHERSCAN_API_KEY,
  }
};