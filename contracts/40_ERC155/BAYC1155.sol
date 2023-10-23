// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.4;

import "./ERC1155.sol";

contract BAYC1155 is ERC1155 {
    uint constant MAX_ID = 10000;

    constructor() ERC1155("BAYC1155", "BAYC1155") {}

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/";
    }

    function mint(address to, uint id, uint amount) external {
        require(id < MAX_ID, "id overflow");
        _mint(to, id, amount, "");
    }

    function mintBatch(
        address to,
        uint[] memory ids,
        uint[] memory amounts
    ) external {
        for (uint i = 0; i < ids.length; i++) {
            require(ids[i] < MAX_ID, "id overflow");
        }
        _mintBatch(to, ids, amounts, "");
    }
}
