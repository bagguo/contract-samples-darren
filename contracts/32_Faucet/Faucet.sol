// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./IERC20.sol";

contract ERC20 is IERC20 {
    mapping(address => uint) public override balanceOf;
    mapping(address => mapping(address => uint256)) public override allowance;

    uint256 public override totalSupply;

    string public name;
    string public symbol;
    uint8 public decimals = 18; //小数位数

    constructor(string memory name_, string memory symbol_) {
        name = name_;
        symbol = symbol_;
    }

    function transfer(
        address recipient,
        uint amount
    ) external override returns (bool) {
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    //代币授权
    function approve(
        address spender,
        uint amount
    ) external override returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external override returns (bool) {
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    //铸造代币，从`0`地址转账给 调用者地址
    function mint(uint amount) external {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    //销毁代币，从 调用者地址 转账给`0`地址
    function burn(uint amount) external {
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }
}

contract Faucet {
    uint256 public amountAllowed = 100; //每次领100单位代币
    address public tokenContract; //token合约地址
    mapping(address => bool) requestedAddress; //记录领取过代币的地址

    //SendToken事件
    event SendToken(address indexed Receiver, uint256 indexed Amount);

    //部署时设定ERC20代币
    constructor(address _tokenContract) {
        tokenContract = _tokenContract; // set token contract
    }

    function requestTokens() external {
        require(!requestedAddress[msg.sender], "Can't Request Multiple Times!");
        IERC20 token = IERC20(tokenContract); //创建IERC20合约对象
        require(
            token.balanceOf(tokenContract) >= amountAllowed,
            "Faucet Empty!"
        );
        token.transfer(msg.sender, amountAllowed);
        requestedAddress[msg.sender] = true;
        emit SendToken(msg.sender, amountAllowed);
    }
}
