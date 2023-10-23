// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.4;

library Address {
    /**
     * 利用extcodesize判断一个地址是否为合约地址
     * extcodesize > 0 的地址一定是合约地址，但是合约在构造函数时候 extcodesize 为0
     */
    function isContract(address account) internal view returns (bool) {
        uint size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }
}
