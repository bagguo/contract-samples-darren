// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Yeye {
    event Log(string msg);

    //定义3个function: hip(), pop(), man(), Log值为Yeye
    function hip() public virtual {
        emit Log("Yeye");
    }

    function pop() public virtual {
        emit Log("Yeye");
    }

    function yeye() public virtual {
        emit Log("Yeye");
    }
}

contract Baba is Yeye {
    //继承两个function: hip()和pop(), 输出改为Baba
    function hip() public virtual override {
        emit Log("Baba");
    }

    function pop() public virtual override {
        emit Log("Baba");
    }

    function baba() public virtual {
        emit Log("Baba");
    }
}

//多继承
contract Erzi is Yeye, Baba {
    //继承两个function: hip(), pop(), 输出改为Erzi
    function hip() public override(Yeye, Baba) {
        emit Log("Erzi");
    }

    function pop() public virtual override(Yeye, Baba) {
        emit Log("Erzi");
    }

    function callParent() public pure {
        Yeye.pop;
    }

    function callParentSuper() public {
        super.pop();
    }
}

//构造函数的继承
abstract contract A {
    uint public a;

    constructor(uint _a) {
        a = _a;
    }
}

//继承时声明父构造函数的参数
contract B is A(1) {}

//在子合约的构造函数中声明构造函数的参数
contract C is A {
    constructor(uint _c) A(_c * _c) {}
}
