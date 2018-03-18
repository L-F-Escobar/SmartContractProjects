module.exports = {
  networks: {
    local: {
      host: "localhost",
      port: 8545,
      network_id: "*" // Match any network id
    },
    staging: {
      host: "localhost",
      port: 8000,
      network_id: "*" // Match any network id
    }
  }
};
