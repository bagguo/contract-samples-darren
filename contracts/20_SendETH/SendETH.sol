// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

//3种方法发送eth
// transfer: 2300 gas, revert
// send: 2300 gas, return bool
// call: all gas, return (bool, data)

error SendFailed();
error CallFailed();

contract SendETH {
    constructor() payable {}

    receive() external payable {}

    function transferETH(address payable _to, uint256 amount) external payable {
        _to.transfer(amount);
    }

    //send() 发送ETH
    function sendETH(address payable _to, uint256 amount) external payable {
        bool success = _to.send(amount);
        if (!success) {
            revert SendFailed();
        }
    }

    // call()发送ETH
    function callETH(address payable _to, uint256 amount) external payable {
        (bool success, ) = _to.call{value: amount}("");
        if (!success) {
            revert CallFailed();
        }
    }
}

contract ReceiveETH {
    event Log(uint amount, uint gas);

    //receive方法，接收eth时触发
    receive() external payable {
        emit Log(msg.value, gasleft());
    }

//返回合约eth余额
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}
