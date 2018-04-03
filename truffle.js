// module.exports = {
//   networks: {
//     local: {
//       host: "localhost",
//       port: 8545,
//       network_id: "*" // Match any network id
//     },
//     staging: {
//       host: "localhost",
//       port: 8000,
//       network_id: "*" // Match any network id
//     }
//   }
// };

module.exports = {
	networks: {
		develop: {
			host: 'localhost',
			port: 7545,
			network_id: '*',
			gas: 4712388, // Default Amount
			gasPrice: 100000000000, // 100 Gwei (Shannon)
			from: "0x627306090abaB3A6e1400e9345bC60c78a8BEf57"
		}
	}
} 
