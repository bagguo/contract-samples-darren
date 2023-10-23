// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.4;

import "./IERC1155.sol";

interface IERC1155MetadataURI is IERC1155 {
    /**
     * 返回第id种类代币的URI
     */
    function uri(uint id) external view returns (string memory);
}
