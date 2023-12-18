// TokenC.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenC is ERC20 {
    constructor() ERC20("Sakha", "SG") {
        _mint(msg.sender, 300000000000000000000); // Mint 300 tokens for the deployer
    }
}