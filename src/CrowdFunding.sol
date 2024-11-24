// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {PriceConverter} from "./lib/PriceConverter.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract CrowdFunding {
    using PriceConverter for address;

    error NoAvailableAmount();

    uint256 public constant MINIMUM_USD = 5e18; // 5 USD in Wei
    address public immutable i_owner;
    address public immutable i_priceFeed;

    mapping(address => bool) public s_isFunders;
    mapping(address => uint256) public s_funderToAmount;
    address[] public s_funders;

    event Funded(address indexed funder, uint256 value);
    event Withdrawn(uint256 value);

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    constructor(address _priceFeed) {
        i_owner = msg.sender;
        i_priceFeed = _priceFeed;
    }

    modifier onlyOwner() {
        if (i_owner != msg.sender) {
            revert NoAvailableAmount();
        }
        _;
    }

    function fund() public payable {
        require(i_priceFeed.getConversionRate(msg.value) >= MINIMUM_USD, "no available amount");

        s_funderToAmount[msg.sender] += msg.value;
        bool isFunded = s_isFunders[msg.sender];

        if (!isFunded) {
            s_funders.push(msg.sender);
            s_isFunders[msg.sender] = true;
        }

        emit Funded(msg.sender, msg.value);
    }

    function withdraw() public onlyOwner {
        (bool sent,) = payable(i_owner).call{value: address(this).balance}("");
        require(sent, "Failed to send Ether");

        emit Withdrawn(address(this).balance);
    }

    function getFundersLength() public view returns (uint256) {
        return s_funders.length;
    }

    function getETHUSdPrice() public view returns (uint256) {
        return i_priceFeed.getPrice();
    }

    function getPriceFeedVersion() public view returns (uint256) {
        return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
    }
}