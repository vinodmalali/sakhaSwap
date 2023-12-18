// TokenB.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

interface Ilogic {
    function getAmtSg(uint amountADesired, uint amountBDesired) external view returns (uint);
}

contract Sakha is ERC20 {
    address logic;
    constructor() ERC20("SakhaGlobal", "SG") {
        //_mint(msg.sender, 300000000000000000000); // Mint 300 tokens for the deployer
        
    }

    function setLogicAddress(address _logic) public {
        logic = _logic;
    }

    function reward(address to,uint amountADesired, uint amountBDesired) external  {
        
        uint amtToken = Ilogic(logic).getAmtSg(amountADesired,amountBDesired);
        _mint(to, amtToken* 10 ** 18);
    }
}