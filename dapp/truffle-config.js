module.exports = {
  networks: {
      development: {
      host: "0.0.0.0",
      port: 7545,
      network_id: "*",
      },
  },
  contracts_build_directory: "../abi",
  compilers: {
      solc: {
          optimizer: {
          enabled: true,
          runs: 200,
          },
      },
  },
};