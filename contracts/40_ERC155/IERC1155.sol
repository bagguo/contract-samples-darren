// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.4;

import "../34_ERC721/IERC165.sol";

/**
 * 允许一个合约包含多个同质化和非同质化代币
 * 
  * func:
 * ERC20 ERC72一个合约都对应一个独立的代币，在1155以前，游戏中每个装备都部署一个合约，
 * 上千种装备就要部署和管理上千个合约，这非常麻烦
 * 
 * ERC721:每个token都有一个tokenId，这些tokenId是同一种token
 * 1155:每个id代表一种token
 * 
 * 每种代币都有一个网址uri来存储它的元数据
 */
interface IERC1155 is IERC165 {
    /**
     * 单类代币转账事件
     * 当`value`个`id`种类的代币被`operator`从`from`转账到`to`时释放
     */
    event TransferSingle(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint id,
        uint value
    );

    /**
     * 多类代币转账事件
     * ids和value为转账的代币种类和数量数组
     */
    event TransferBatch(
        address indexed operator,
        address indexed from,
        address to,
        uint[] ids,
        uint[] values
    );

    /**
     * 批量授权事件
     * 当`account`将代币授权给`operator`时释放
     */
    event ApprovalForAll(
        address indexed account,
        address indexed operator,
        bool approval
    );

    /**
     * 当`id`种类的代币的URI发生变化时释放，`value`为新的URI
     */
    event URI(string value, uint indexed id);

    /**
     * account id种类代币持仓量查询
     */
    function balanceOf(address account, uint id) external view returns (uint);

    function balanceOfBatch(
        address[] calldata accounts,
        uint[] calldata ids
    ) external view returns (uint[] memory);

    /**
     * 批量授权，将调用者的代币授权给operator地址
     * 释放{ApprovalForAll}事件
     */
    function setApprovalForAll(address operator, bool approved) external;

    /**
     * 批量授权查询，如果授权地址operator被account授权，则返回true
     */
    function isApprovedForAll(
        address account,
        address operator
    ) external view returns (bool);

    /**
     * 安全转账，将amount单位id种类的代币从from转账给to
     * 释放{TransferSingle}事件
     * 要求：
     * -如果调用者不是from地址而是授权地址，则需要from的授权
     * - `from`地址必须有足够的持仓
     * -如果接收方是合约，需要实现IERC1155REceiver的onERC1155Received方法，并且返回相应的值
     */
    function safeTransferFrom(
        address from,
        address to,
        uint id,
        uint amount,
        bytes calldata data
    ) external;

    function safeBatchTransferFrom(
        address from,
        address to,
        uint[] calldata ids,
        uint[] calldata amounts,
        bytes calldata data
    ) external;
}
