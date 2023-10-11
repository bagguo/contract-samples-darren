require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.9",
};


const INFURA_API_KEY = "f0f35ed9aa9748ad8a88dd6cdcf590c7";

const GOERLI_PRIVATE_KEY = "bb243ac55ea6ad4f6f0b22a43d69d7c874ffe429744a135806540a10e733836e";//account: ganache test open

module.exports = {
  solidity: {
    compilers: [
      { version: "0.4.18" },
      { version: "0.5.16" },
      { version: "0.6.6" },
      { version: "0.8.4" },
      { version: "0.8.9" },
      { version: "0.8.20" }
    ]
  },
  networks: {
    goerli: {
      url: `https://goerli.infura.io/v3/${INFURA_API_KEY}`,
      accounts: [GOERLI_PRIVATE_KEY]
    }
  }
};