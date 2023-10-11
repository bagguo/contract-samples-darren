// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "hardhat/console.sol";

/**
 * Solidity中的event是EVM上日志的抽象，具有两个特点：
 * 1.响应：应用程序(ether.js)可以通过RPC接口订阅和监听这些事件，并在前端做响应
 * 1.经济：event是EVM上比较经济的存储数据的方式，每个大概消耗2,000-5,000 gas不等。相比之下，存储一个新的变量至少需要20,000 gas
 */
contract Event {
    // 定义_balances映射变量，记录每个地址的持币数量
    mapping(address => uint256) public _balances;

    // 定义Transfer event，记录transfer交易的转账地址，接收地址和转账数量
    event Transfer(address indexed from, address indexed to, uint256 value);

    // 定义_transfer函数，执行转账逻辑
    function _transfer(address from, address to, uint256 amount) external {
        _balances[from] = 10000000; // 给转账地址一些初始代币

        _balances[from] -= amount; // from地址减去转账数量
        _balances[to] += amount; // to地址加上转账数量

        console.log("Event _transfer finish");
        // 释放事件 emit:排放，散发，发行
        //ethers.js通过RPC接口订阅监听事件
        emit Transfer(from, to, amount);
    }
}

// Test history
// from: 0xff12f3dd9f94c57f0fb5e9346edbc8b4eea51b51
// transaction: https://goerli.etherscan.io/tx/0x726e7c266b4668e961e41be294d8ec3efbb2a31b5b682b3e2b50045c711d4ea0
// event log: https://goerli.etherscan.io/tx/0x726e7c266b4668e961e41be294d8ec3efbb2a31b5b682b3e2b50045c711d4ea0#eventlog
// 来源：https://mirror.xyz/wtfacademy.eth/nGSCuFbPHMo8mL1ErZMUwOZG_OUECzIWEsGhX0a5eOw
