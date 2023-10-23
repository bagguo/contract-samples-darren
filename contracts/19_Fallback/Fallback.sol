// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Fallback {
    //receive和fallback的区别
    //receive和fallback都能够用于接收ETH，他们触发的规则如下：
    /* 触发fallback() 还是 receive()?
           接收ETH
              |
         msg.data是空？
            /  \
          是    否
          /      \
receive()存在?   fallback()
        / \
       是  否
      /     \
receive()  fallback   
    */

    //定义事件
    event receivedCalled(address Sender, uint Value);
    event fallbackCalled(address Sender, uint Value, bytes Data);

    //Solidity特殊的回调函数

    //合约接收eth时被触发
    receive() external payable {
        emit receivedCalled(msg.sender, msg.value);
    }

    //在调用合约不存在的函数时被触发。可用于接收ETH，也可以用于代理合约proxy contract。
    fallback() external payable {
        emit fallbackCalled(msg.sender, msg.value, msg.data);
    }
}
