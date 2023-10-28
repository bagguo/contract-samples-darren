// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.4;

/**
 * @title 整形溢出 Arithmetic Over/Under Flows
 * 预防办法：
 * solidity 0.8.0之前, 在合约中引入SafeMath库，整形溢出会报错
 * solidity 0.8.0后，solidity内置 SafeMath，几乎不存在此类问题。开发者有时为节省gas会用uncheck代码块临时关闭整形溢出检查
 * ，这时程序员自己要确认不会有整形溢出
 */
contract Token {
    mapping(address => uint) balances;
    uint public totalSupply;

    constructor(uint _initialSpuuly) {
        balances[msg.sender] = totalSupply = _initialSpuuly;
    }

    function transfer(address _to, uint _value) public returns (bool) {
        unchecked {
            /**
             * attack:
             * 入参_value > totalSupply时，该行代码整形溢出，总会通过require
             *
             * 复现：
             * 部署 Token 合约，将总供给设为 100。
             * 向另一个账户转账 1000 个代币，可以转账成功。
             * 查询自己账户的余额，发现是一个非常大的数字，约为2^256
             */
            require(balances[msg.sender] - _value >= 0);
            balances[msg.sender] -= _value;
            balances[_to] += _value;
        }
        return true;
    }

    function balanceOf(address _owner) public view returns (uint balance) {
        return balances[_owner];
    }
}
