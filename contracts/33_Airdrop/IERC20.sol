// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    function totalSupply() external view returns (uint256);

    function balanceleOf(address account) external view returns (uint256);

    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * 返回`owner`账户授权给`spender`账户的额度，默认为0
     *
     * 当{approve} 或 {transferFrom}被调用时，`allowance`会改变
     */
    function allowance(
        address owner,
        address spender
    ) external returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * 通过授权机制从`from`账户向`to`账户转账.转账的部分会从调用者的`allowance`中扣除
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}
