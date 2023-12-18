// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract PriceFetcher {
    AggregatorV3Interface public uniPriceFeed;
    AggregatorV3Interface public daiPriceFeed;

    // Set the Chainlink Price Feed addresses for UNI and DAI on the chosen network
    constructor() {
        // UNI/USD price feed address (replace with the actual address for your network)
        uniPriceFeed = AggregatorV3Interface(0xc59E3633BAAC79493d908e63626716e204A45EdF);
        
        // DAI/USD price feed address (replace with the actual address for your network)
        daiPriceFeed = AggregatorV3Interface(0x14866185B1962B63C3Ea9E03Bc1da838bab34C19);
    }

    // Function to get the latest price of Uni in USD
    function getUniPrice() external view returns (int) {
        (, int price, , ,) = uniPriceFeed.latestRoundData();
        return price;
    }

    // Function to get the latest price of Dai in USD
    function getDaiPrice() external view returns (int) {
        (, int price, , ,) = daiPriceFeed.latestRoundData();
        return price;
    }

    function getAmtSg(uint amountADesired, uint amountBDesired) external view returns (int) {
       (, int priceA, , ,) = uniPriceFeed.latestRoundData();
       (, int priceB, , ,) = daiPriceFeed.latestRoundData();


        int totalUSD = (int(amountADesired / 1e18) * priceA) + (int(amountBDesired / 1e18) * priceB);
        int amtSG = totalUSD / (100 * 1e8);

        return amtSG;
    }
}
