// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "../34_ERC721/IERC165.sol";

/**
 * ERC1155接收合约，要接受ERC1155的安全转账，需要实现这个合约
 */
interface IERC1155Receiver is IERC165 {
    /**
     * 接受ERC1155安全转帐safeTransferFrom
     * 需要返回 0xf23a6e61或 bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))
     */
    function onERC1155Received(
        address operator,
        address from,
        uint id,
        uint value,
        bytes calldata data
    ) external returns (bytes4);

    function onERC1155BatchReceived(
        address operator,
        address from,
        uint[] calldata ids,
        uint[] calldata values,
        bytes calldata data
    ) external returns (bytes4);
}
