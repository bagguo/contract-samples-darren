// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./IERC20.sol";

//向多个地址转账ERC20代币
contract Airdrop {
    mapping(address => uint) failTransferList;

    function multiTransferToken(
        address _token,
        address[] calldata _address,
        uint256[] calldata _amounts
    ) external {
        require(
            _address.length == _amounts.length,
            "Lengths of Addrerss and Amounts NOT EQUAL"
        );
        IERC20 token = IERC20(_token);
        uint _amountSum = getSum(_amounts);
        require(
            token.allowance(msg.sender, address(this)) > _amountSum,
            "Need Approve ERC20 token"
        );

        for (uint i = 0; i < _address.length; i++) {
            token.transferFrom(msg.sender, _address[i], _amounts[i]);
        }
    }

    function multiTransferETH(
        address payable[] calldata _addresses,
        uint256[] calldata _amounts
    ) public payable {
        require(
            _addresses.length == _amounts.length,
            "Length of Addresses and Amounts NOT EQUAL"
        );
        uint _amountSum = getSum(_amounts);
        require(msg.value == _amountSum, "Transfer amount error");
        for (uint i = 0; i < _addresses.length; i++) {

            //_addresses[i].transfer(_amounts[i]);
            (bool success, ) = _addresses[i].call{value: _amounts[i]}("");
            if (!success) {
                failTransferList[_addresses[i]] = _amounts[i];
            }
        }
    }

    function getSum(uint256[] calldata _arr) public pure returns (uint sum) {
        for (uint i = 0; i < _arr.length; i++) sum = sum + _arr[i];
    }
}
