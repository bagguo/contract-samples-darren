// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.4;

/**
 * @title 利用选择器碰撞调用其他function
 * address().call()
 */
contract SelectorClash {
    bool public solved; //攻击是否成功

    /**
     * require要求本合约才能调用该方法
     * 
     * 函数名沿用自 Poly Network 漏洞合约, epoch: 时代、纪元
     */
    function putCurEpochConPubKeyBytes(bytes memory _bytes) public {
        require(msg.sender == address(this), "Not Owner");
        solved = true;
    }

    //有漏洞，攻击者可以通过改变 _method 变量碰撞函数选择器，调用目标合约并完成攻击
    function executeCrossChainTx(
        bytes memory _method,
        bytes memory _bytes
    ) public returns (bool success) {
        (success, ) = address(this).call(
            abi.encodePacked(
                bytes4(
                    keccak256(abi.encodePacked(_method, "(bytes,bytes,uint64)"))
                ),
                abi.encode(_bytes)
            )
        );
    }

    function secretSlector() external pure returns (bytes4) {
        return bytes4(keccak256("putCurEpochConPubKeyBytes(bytes)"));
    }

    function hackSlector() external pure returns (bytes4) {
        return bytes4(keccak256("f1121318093(bytes,bytes,uint64)"));
    }
}
