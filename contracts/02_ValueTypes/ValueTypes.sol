// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract ValueTypes {
    //bool
    bool public _bool = true;

    //int
    int public _int = -1;
    uint public _uint = 1;
    uint256 public _number = 20220330;

    //address
    address public _address = 0x7A58c0Be72BE218B41C608b7Fe7C5bB630736C71;
    address payable public _address1 = payable(_address); //payabe address, 可转账，查余额
    //地址类型的成员
    uint256 public balance = _address1.balance; //balance of address

    //固定长度的字节数组
    bytes32 public _byte32 = "MiniSolidity"; //bytes32:0x4d696e69536f6c69646974790000000000000000000000000000000000000000
    bytes1 public _byte = _byte32[0];

    //Enum
    //将uint 0,1,2表示为Buy,Hold,Sell
    enum ActionSet {
        Buy,
        Hold,
        Sell
    }
    //创建enum变量 action
    ActionSet action = ActionSet.Buy;

    //enum可以和uint显示的转换
    function enumToUint() external view returns (uint) {
        return uint(action);
    }
}
