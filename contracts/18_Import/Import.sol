// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

//通过文件相对位置import
import "./Yeye.sol";
//通过`全局符号`导入特定的合约
import {Yeye} from "./Yeye.sol";
//通过网址引用
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol";
//引用openzeppelin合约
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract Import {
    //成功导入Address库
    using Address for address;
    Yeye yeye = new Yeye();

    function test() external {
        yeye.hip();
    }
}
