// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract PriceFetcher {
    using SafeMath for uint256;

    address owner;

    uint public rewardUnit;

    uint public borrowRewardUnit;
    
    uint public repayRewardUnit;

    AggregatorV3Interface public priceFeed;

    mapping (string => address) public symbolToAddr;

    constructor() {
        owner = msg.sender;
    }

    function setChainLinkAdr(string memory _symbol,address _adr) public onlyOwner {
        symbolToAddr[_symbol] = _adr;
    }

    modifier onlyOwner() {
         require(owner == msg.sender, "Not owner");
        _;
    }

    function setRewardUnit(uint _rewardUnit) public onlyOwner {
        rewardUnit = _rewardUnit;
    }

    function setBorrowRewardUnit(uint _borrowRewardUnit) public onlyOwner {
        borrowRewardUnit = _borrowRewardUnit;
    }

    function setRepayRewardUnit(uint _repayRewardUnit) public onlyOwner {
        repayRewardUnit = _repayRewardUnit;
    }

    // Function to get the latest price of Uni in USD
    function getUniPrice() external view returns (int) {
        address assetadr = symbolToAddr['UNI'];
        (, int price, , ,) = AggregatorV3Interface(assetadr).latestRoundData();
        return price;
    }

    // Function to get the latest price of Dai in USD
    function getDaiPrice() external view returns (int) {
        address assetadr = symbolToAddr['DAI'];
        (, int price, , ,) = AggregatorV3Interface(assetadr).latestRoundData();
        return price;
    }

    function getAmtSg(string memory tokenASymbol,uint amountADesired,string memory tokenBSymbol, uint amountBDesired) external view returns (int) {
        address assetAadr = symbolToAddr[tokenASymbol];
        address assetBadr = symbolToAddr[tokenBSymbol];
       (, int priceA, , ,) = AggregatorV3Interface(assetAadr).latestRoundData();
       (, int priceB, , ,) = AggregatorV3Interface(assetBadr).latestRoundData();

        uint256 totalUSD = (amountADesired.div(1e18)).mul(uint256(priceA)).add((amountBDesired.div(1e18)).mul(uint256(priceB)));
        int amtSG = int(totalUSD.div(rewardUnit).div(1e8));

        return amtSG;
    }

    
    function getAmtSgBorrow(string memory tokenSymbol,uint amountDesired) external view returns (int) {
        address assetAadr = symbolToAddr[tokenSymbol];
       (, int priceA, , ,) = AggregatorV3Interface(assetAadr).latestRoundData();
       
        uint256 totalUSD = (amountDesired.div(1e18)).mul(uint256(priceA));
        int amtSG = int(totalUSD.div(borrowRewardUnit).div(1e8));

        return amtSG;
    }

    function getAmtSgRepay(string memory tokenSymbol, uint amountDesired) external view returns (int) {
       address assetAadr = symbolToAddr[tokenSymbol];
       (, int priceA, , ,) = AggregatorV3Interface(assetAadr).latestRoundData();

        uint256 totalUSD = (amountDesired.div(1e18)).mul(uint256(priceA));
        int amtSG = int(totalUSD.div(repayRewardUnit).div(1e8));

        return amtSG;
    }
}
