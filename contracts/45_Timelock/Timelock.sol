// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.4;

/**
 * @title 时间锁和时间锁合约。代码由Compound的Timelock合约简化而来
 * func: 将智能合约的某些功能锁定一段时间
 * example:假如一个黑客黑了Uniswap的多签，准备提走金库的钱，但金库合约加了2天锁定期的时间锁，
 * 那么黑客从创建提钱的交易，到实际把钱提走，需要2天的等待期。在这一段时间，
 * 项目方可以找应对办法，投资者可以提前抛售代币减少损失。
 */
contract Timelock {
    //交易取消事件
    event CancelTransaction(
        bytes32 indexed tcHash,
        address indexed target,
        uint value,
        string signature,
        bytes data,
        uint executeTime
    );
    //交易执行事件
    event ExecuteTransaction(
        bytes32 indexed txHash,
        address indexed target,
        uint value,
        string signature,
        bytes data,
        uint executeTime
    );
    //交易创建并进入队列 事件
    event QueueTransaction(
        bytes32 indexed txHash,
        address indexed target,
        uint value,
        string signature,
        bytes data,
        uint executeTime
    );
    //修改管理员地址的事件
    event NewAdmin(address indexed newAdmin);

    //状态变量
    address public admin; //管理员地址
    uint public constant GRACE_PERIOD = 7 days; //交易有效期，过期的交易作废
    uint public delay; //交易锁定时间(s)
    //txHash到bool，记录所有在时间锁队列中的交易
    mapping(bytes32 => bool) public queuedTransactions;

    modifier onlyOwner() {
        require(msg.sender == admin, "Timelock: Caller not Timelock");
        _;
    }

    modifier onlyTimelock() {
        require(msg.sender == address(this), "Timelock: Caller not Timelock");
        _;
    }

    constructor(uint delay_) {
        delay = delay_;
        admin = msg.sender;
    }

    /**
     * 改变管理员地址，调用者必须是Timelock合约
     */
    function changeAdmin(address newAdmin) public onlyTimelock {
        admin = newAdmin;

        emit NewAdmin(newAdmin);
    }

    /**
     * 创建交易并添加到时间锁队列中
     * @param target 目标合约地址
     * @param value 发送eth数额
     * @param signature 要调用的函数签名(function signature)
     * @param data call data, 里面是一些参数
     * @param executeTime 交易执行的区块链时间戳
     *
     * 要求：executeTime 大于 当前区块链时间戳 + delay
     */
    function queueTransaction(
        address target,
        uint256 value,
        string memory signature,
        bytes memory data,
        uint executeTime
    ) public onlyOwner returns (bytes32) {
        require(
            executeTime >= getBlockTimestamp() + delay,
            "Timelock: queueTransaction: Estimated execution block must satisfy delay."
        );
        //计算交易的唯一识别符：一堆东西的hash
        bytes32 txHash = getTxHash(target, value, signature, data, executeTime);
        queuedTransactions[txHash] = true;

        emit QueueTransaction(
            txHash,
            target,
            value,
            signature,
            data,
            executeTime
        );
    }

    function cancelTransaction(
        address target,
        uint value,
        string memory signature,
        bytes memory data,
        uint executeTime
    ) public onlyOwner {
        bytes32 txHash = getTxHash(target, value, signature, data, executeTime);
        //检查：交易在时间锁队列中
        require(
            queuedTransactions[txHash],
            "Timelock: cancelTransaction: Transaction hasn't been queued"
        );
        //将交易移除队列
        queuedTransactions[txHash] = false;

        emit CancelTransaction(
            txHash,
            target,
            value,
            signature,
            data,
            executeTime
        );
    }

    function executeTransaction(
        address target,
        uint value,
        string memory signature,
        bytes memory data,
        uint executeTime
    ) public payable onlyOwner returns (bytes memory) {
        bytes32 txHash = getTxHash(target, value, signature, data, executeTime);
        require(
            queuedTransactions[txHash],
            "Timelock: executeTransaction: Transaction hasn't been queued."
        );
        require(
            getBlockTimestamp() >= executeTime,
            "Timelock: executeTransaction: Transaction hasn't surpassed time lock."
        );
        require(
            getBlockTimestamp() <= executeTime + GRACE_PERIOD,
            "Timelock: executeTransaction: Transaction is stale."
        );
        queuedTransactions[txHash] = false;

        bytes memory callData;
        if (bytes(signature).length == 0) {
            callData = data;
        } else {
            callData = abi.encodePacked(
                bytes4(keccak256(bytes(signature))),
                data
            );
        }
        //利用call执行交易
        (bool success, bytes memory returnData) = target.call{value: value}(
            callData
        );
        require(
            success,
            "Timelock: executeTransaction: Transaction execution reverted."
        );

        emit ExecuteTransaction(
            txHash,
            target,
            value,
            signature,
            data,
            executeTime
        );

        return returnData;
    }

    function getBlockTimestamp() public view returns (uint) {
        return block.timestamp;
    }

    /**
     * 创建交易的识别符
     */
    function getTxHash(
        address target,
        uint value,
        string memory signature,
        bytes memory data,
        uint executeTime
    ) public pure returns (bytes32) {
        return
            keccak256(abi.encode(target, value, signature, data, executeTime));
    }
}
