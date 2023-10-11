// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/**
 * storage: 存在链上，gas消耗多
 * memory: 临时存在内存，gas消耗少
 * calldata: 临时存在内存，gas消耗少。immutable；用来存储函数参数
 */
contract DataStorage{
    //x存储在storage，只有状态变量的存储位置可以省略，默认存储在storage
    uint[] public x = [1,2,3];

    function fStorage() public {
        //声明一个storage的变量xStorage，指向x。修改xStorage也会影响x
        uint[] storage xStorage = x;
        xStorage[0] = 100;
    }

    function fMemory() public view {
        //声明一个memory的变量xMemory, 复制x。修改xMemory不会影响x
        uint[] memory xMemory = x;
        xMemory[0] = 100;
        xMemory[1]=200;
        uint[] memory xMemory2 = x;
        xMemory2[0]=300;
    }

    function fCalldata(uint[] calldata _x) public pure returns(uint[] calldata) {
        //参数为calldata的数组，不能被修改
        //_x[0] = 0 //这样修改会报错
        return(_x);
    }

}

contract Variables {
    uint public x =1;
    uint public y;
    string public z;

    function global() external view returns(address, uint, bytes memory){
        /**
         * msg 全局变量:
         * msg.data 
         * msg.value
         * msg.gas
         * msg.sender
         * msg.sig
         * 
         */
        
        address sender = msg.sender;
        uint blockNum = block.number;
        bytes memory data = msg.data;
        return(sender, blockNum, data);
    }

    function weiUnit() external pure returns(uint) {
        assert(1 gwei == 1e9);
        assert(1 gwei == 1000000000);
        return 1 gwei;
    }

    function etherUnit() external pure returns(uint) {
        assert(1 ether == 1e18);
        assert(1 ether == 100000000000000000);
        return 1 ether;
    }

    function secondsUnit() external pure returns(uint) {
        assert(1 seconds == 1);
        return 1 seconds;
    }

    function minutesUnit() external pure returns(uint) {
        assert(1 minutes == 60);
        assert(1 minutes == 60 seconds);
        return 1 minutes;
    }
}