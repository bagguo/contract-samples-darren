// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "../31_ERC20/IERC20.sol";

/**
 * @title ERC20代币时间锁合约。受益人在锁仓一段时间后才能取出代币
 */
contract TokenLocker {
    //beneficiary受益人
    event TokenLockStart(
        address indexed beneficiary,
        address indexed token,
        uint startTime,
        uint lockTime
    );
    event Release(
        address indexed beneficiary,
        address indexed token,
        uint releaseTime,
        uint amount
    );

    //被锁仓ERC20代币合约
    IERC20 public immutable token;
    //受益人地址
    address public immutable beneficiary;
    //锁仓时间(s)
    uint public immutable lockTime;
    uint public immutable startTime;

    /**
     * 部署时间锁合约，初始化代币合约地址，受益人地址和锁仓时间
     */
    constructor(IERC20 token_, address beneficiary_, uint lockTime_) {
        require(lockTime_ > 0, "TokenLock: lock time should greater than 0");

        token = token_;
        beneficiary = beneficiary_;
        lockTime = lockTime_;
        startTime = block.timestamp;

        emit TokenLockStart(
            beneficiary_,
            address(token_),
            block.timestamp,
            lockTime_
        );
    }

    /**
     * 锁仓时间过后，将代币释放给受益人
     */
    function release() public {
        require(
            block.timestamp >= startTime + lockTime,
            "TokenLock: current time is before release time"
        );

        uint amount = token.balanceOf(address(this));
        require(amount > 0, "TokenLock: no tokens to release");
        token.transfer(beneficiary, amount);
        emit Release(msg.sender, address(token), block.timestamp, amount);
    }
}
