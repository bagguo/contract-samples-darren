require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-waffle");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.9",
};


const INFURA_API_KEY = "f0f35ed9aa9748ad8a88dd6cdcf590c7";

const GOERLI_PRIVATE_KEY = "0be427806c130f73704b2427e81f41ba1eabded4c9c3f91a74d50d646f52a992";

module.exports = {
  solidity: "0.8.9",
  networks: {
    goerli: {
      url: `https://goerli.infura.io/v3/${INFURA_API_KEY}`,
      accounts: [GOERLI_PRIVATE_KEY]
    }
  }
};