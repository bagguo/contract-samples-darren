// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title 
 * 中心化/伪中心化风险
 * 解决：
 * 1.使用多签钱包管理国库、控制合约参数，常见的4/7, 6/9多签
 * 2.多签持有人要多样化，分布在创始团队、投资人、社区领袖
 * 3.使用时间锁控制合约，在黑客或项目内鬼盗取资产时，项目方和社区有一些事件应对，将损失最小化
 */
contract Centralization is ERC20, Ownable {
    constructor(
        address initialOwner
    ) Ownable(initialOwner) ERC20("Centralization", "Cent") {
        address exposedAccount = 0xe16C1623c1AA7D919cd2241d8b36d9E79C1Be2A2;
        transferOwnership(exposedAccount);
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }
}
