// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
contract Mapping {
    mapping(uint => address) public idToAddress; //id映射到地址
    mapping(address => address) public swapPair; //币对的映射，地址到地址

    //规则1. _KeyType不能是自定义的 下面这个例子会报错
    //只允许基本类型、用户定义的值类型、契约类型或枚举作为映射键
    // struct Student{
    //     uint256 id;
    //     uint256 score;
    // }
    // mapping(Student => uint) public testVar;

    function writeMap(uint _Key, address _Value) public {
        idToAddress[_Key ] = _Value;
    }
}