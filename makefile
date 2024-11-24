-include .env

fork-test:;
	forge test --fork-url ${SEPOLIA_RPC_URL}

deploy-anvil:;
	forge script script/DeployCrowdFunding.s.sol --rpc-url ${ANVIL_RPC_URL} --account idozii4-anvil --broadcast

fund-to-crowdfunding-anvil:;
	forge script script/Interactions.s.sol:FundCrowdFunding --rpc-url ${ANVIL_RPC_URL} --account idozii4-anvil --broadcast
