// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract C {
    uint public num;
    address public sender;

    function setVars(uint _num) public payable {
        num = _num;
        sender = msg.sender;
    }
}

contract B {
    uint public num;
    address public sender;

    //通过call来调用C的setVars函数，将改变合约C里的状态变量
    function callSetVars(address _addr, uint _num) public {
        (bool success, bytes memory data) = _addr.call(
            abi.encodeWithSignature("setVars(uint256)", _num)
        );
    }

    //通过delegatecall来调用C的setVars()函数，将改变合约B里的状态变量
    //原因：当前上下文环境在B合约中
    function delegatecallSetVars(address _addr, uint _num) external payable {
        (bool success, bytes memory data) = _addr.delegatecall(
            abi.encodeWithSignature("setVars(uint256)", _num)
        );
    }
}
