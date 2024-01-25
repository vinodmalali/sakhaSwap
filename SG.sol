// TokenB.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

interface Ilogic {
    function getAmtSg(string memory tokenAsymbol, uint amountADesired, string memory tokenBsymbol, uint amountBDesired) external view returns (uint);
}

interface IEERC20 {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);
}

contract Sakha is ERC20 {
    address public logic;
    address public owner;

    address public router;

    address public lendingPool;

    constructor() ERC20("SakhaGlobal", "SG") {
        //_mint(msg.sender, 300000000000000000000); // Mint 300 tokens for the deployer
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "Not owner");
        _;
    }

    modifier onlyRouter() {
        require( router == msg.sender || lendingPool == msg.sender, "Not router");
        _;
    }

    function setLogicAddress(address _logic) public onlyOwner {
        logic = _logic;
    }

    function setRouter(address _router) external onlyOwner {
         router = _router;
    }

    function setLendingPool(address _pool) external onlyOwner {
         lendingPool = _pool;
    }

    function reward(address to,address tokenA, address tokenB, uint amountADesired, uint amountBDesired) external onlyRouter {

       string memory tokenAsymbol = IEERC20(tokenA).symbol();
       string memory tokenBsymbol = IEERC20(tokenB).symbol();
        
        uint amtToken = Ilogic(logic).getAmtSg(tokenAsymbol,amountADesired,tokenBsymbol,amountBDesired);
        _mint(to, amtToken* 10 ** 18);
    }

    function getSymbols(address tokenA, address tokenB) external view returns(string memory,string memory) {

       string memory tokenAsymbol = IEERC20(tokenA).symbol();
       string memory tokenBsymbol = IEERC20(tokenB).symbol();

       return (tokenAsymbol,tokenBsymbol);
        
    }
}
