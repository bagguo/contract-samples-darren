// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/**
继承树：
    God
   /   \
 Adam  Eve
   \   /
   people
 */
contract God {
    event Log(string message);

    function foo() public virtual {
        emit Log("God.foo called");
    }

    function bar() public virtual {
        emit Log("God.bar called");
    }
}

contract Adam is God {
    function foo() public virtual override {
        emit Log("Adam.bar called");
    }

    function bar() public virtual override {
        emit Log("Adam.bar called");
        super.bar();
    }
}

contract Eve is God {
    function foo() public virtual override {
        emit Log("Eve.foo called");
    }

    function bar() public virtual override {
        emit Log("Eve.bar called");
    }
}

contract people is Adam, Eve {
    function foo() public override(Adam, Eve) {
        emit Log("people.foo called");
    }

    function bar() public override(Adam, Eve) {
        emit Log("people.bar called");
    }
}
