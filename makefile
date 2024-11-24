-include .env

fork-test:;
	forge test --fork-url ${SEPOLIA_RPC_URL}

