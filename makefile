-include .env

ANVIL_PRIVATE_KEY := 0x47e179ec197488593b187f80a00eb0da91f1b9d0b13f8733639f19c30a34926a

NETWORK_ARGS := --rpc-url http://localhost:8545 --private-key $(ANVIL_PRIVATE_KEY) --broadcast

ifeq ($(findstring --network sepolia,$(ARGS)),--network sepolia)
	NETWORK_ARGS := --rpc-url $(SEPOLIA_RPC_URL) --account $(ACCOUNT) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv
endif

deploy:
	@forge script script/DeployCrowdfunding.s.sol:DeployCrowdfunding $(NETWORK_ARGS)

fund:
	@forge script script/Interactions.s.sol:FundCrowdfunding $(NETWORK_ARGS)

withdraw:
	@forge script script/Interactions.s.sol:WithdrawCrowdfunding $(NETWORK_ARGS)