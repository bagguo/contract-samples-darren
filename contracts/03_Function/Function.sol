// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract FunctionTypes {
    uint public number = 5;

    /**
     * 可见性：
     * public: 内外部都可见
     * private: 只能从本合约内部访问，继承的合约不能用
     * external: 只能从合约外部访问，但内部可通过this.fun()调用
     * internal: 只能从合约内部访问，继承的合约可以用
     * 
     * 合约中定义的函数需要明确指定可见性，它们没有默认值
     * 状态变量的默认可见性是internal
     * 
     * 函数对链上状态变量的读写：
     * pure:函数不可读、不可写链上的状态变量
     * view: 可读，不可写
     * payable: 可以向合约转eth
     * 
     * 在以太坊中，以下语句被视为修改链上状态：
        1. 写入状态变量。
        2. 释放事件。
        3. 创建其他合约。
        4. 使用 `selfdestruct`.
        5. 通过调用发送以太币。
        6. 调用任何未标记 `view` 或 `pure` 的函数。
        7. 使用低级调用（low-level calls）。
        8. 使用包含某些操作码的内联汇编。
     */
    constructor() payable {} //payable可以给合约发送eth

    //函数类型

    // 合约中定义的函数需要明确指定可见性，它们没有默认值
    // function funName(<parameter types>) {internal | external} [pure | view | payable] [returns (<return types>)]
    //
    // 默认function
    function add() external {
        number = number + 1;
    }

    //pure：函数对链上状态变量不可读，不可写
    function addPure(
        uint256 _number
    ) external pure returns (uint256 new_number) {
        new_number = _number + 1;
    }

    //view:函数对链上状态变量可读不可写
    function addView() external view returns (uint256 new_number) {
        new_number = number + 1;
    }

    //internal:合约内部可调用
    function minus() internal {
        number = number - 1;
    }

    //合约内的函数可以调用内部函数
    function minusCall() external {
        minus();
    }

    //payable: 递钱，能给合约支付eth的函数
    function minusPayable() external payable returns (uint256 balance) {
        minus();
        balance = address(this).balance;
    }
}
