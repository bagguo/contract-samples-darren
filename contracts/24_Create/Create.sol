// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
//在合约中创建新合约
contract Pair {
    address public factory;
    address public token0;
    address public token1;

    constructor() payable {
        factory = msg.sender;
    }

    //called once by the factory when deploy
    function initialize(address _token0, address _token1) external {
        require(msg.sender == factory, "UniswapV2: FORBIDDEN"); //sufficient check
        token0 = _token0;
        token1 = _token1;
    }
}

contract PairFactory {
    //通过两个代币地址查Pair地址
            //token0           //token1   //pair contract addr
    mapping(address => mapping(address => address)) public getPair;
    address[] public allPairs; //保存所有Pair地址

    function createPair(
        address tokenA,
        address tokenB
    ) external returns (address pairAddr) {
        //创建新合约
        Pair pair = new Pair();
        //调用新合约的initialize方法
        pair.initialize(tokenA, tokenB);
        //更新地址map
        pairAddr = address(pair);
        allPairs.push(pairAddr);
        getPair[tokenA][tokenB] = pairAddr;
        getPair[tokenB][tokenA] = pairAddr;
    }
}
