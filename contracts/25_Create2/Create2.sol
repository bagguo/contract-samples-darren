// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Pair {
    address public factory;
    address public token0;
    address public token1;

    constructor() payable {
        factory = msg.sender;
    }

    //called once by the factory when deploy
    function initialize(address _token0, address _token1) external {
        //sufficient check
        require(msg.sender == factory, "UniswapV2:FORBIDDEN");
        token0 = _token0;
        token1 = _token1;
    }
}

contract PairFactory2 {
    // 通过两个代币地址查Pair地址
    mapping(address => mapping(address => address)) public getPair;
    address[] public allPairs; //保存所有Pair地址

    function createPair2(
        address tokenA,
        address tokenB
    ) external returns (address pairAddr) {
        require(tokenA != tokenB, "IDENTICAL_ADDRESSES"); //避免tokenA和TokenB相同产生的冲突
        //用tokenA和tokenB地址计算salt
        //将tokenA和tokenB按大小排序
        (address token0, address token1) = tokenA < tokenB
            ? (tokenA, tokenB)
            : (tokenB, tokenA);
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        //用create2部署新合约
        Pair pair = new Pair{salt: salt}();
        //调用新合约的initialize方法
        pair.initialize(tokenA, tokenB);
        pairAddr = address(pair);
        allPairs.push(pairAddr);
        getPair[tokenA][tokenB] = pairAddr;
        getPair[tokenB][tokenA] = pairAddr;
    }

    function calculateAddr(
        address tokenA,
        address tokenB
    ) public view returns (address predictedAddress) {
        require(tokenA != tokenB, "IDENTICAL_ADDRESS");
        //计算用tokenA和tokenB地址计算salt
        (address token0, address token1) = tokenA < tokenB
            ? (tokenA, tokenB)
            : (tokenB, tokenA);
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        //计算合约地址方法hash()
        predictedAddress = address(
            uint160(
                uint(
                    keccak256(
                        abi.encodePacked(
                            bytes1(0xff),
                            address(this),
                            salt,
                            keccak256(type(Pair).creationCode)
                        )
                    )
                )
            )
        );
    }
}
