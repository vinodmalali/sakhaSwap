// TokenB.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenB is ERC20 {
    constructor() ERC20("DAI", "DAI") {
        _mint(msg.sender, 3000000000000000000000); // Mint 300 tokens for the deployer
    }
}