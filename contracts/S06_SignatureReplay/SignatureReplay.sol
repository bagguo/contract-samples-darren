// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

/**
 * 签名重放（Signature Replay）攻击
 * 1.普通重放: 将本该使用一次的签名多次使用
 * 2.跨链重放：将本该在一条链上使用的签名，在另一条链上重复使用
 * 
 */
contract SignatureReplay is ERC20 {
    address public signer;

    constructor() ERC20("SigReplay", "Replay") {
        signer = msg.sender;
    }

    /**
     *
     */
    function badMint(address to, uint amount, bytes memory signature) public {
        bytes32 _msgHash = toEthSignedMessageHash(getMessageHash(to, amount));
        require(verify(_msgHash, signature), "Invalid Signer!");
        _mint(to, amount);
    }

    /**
     * 将to地址(address类型)和 amount(uint256)拼成消息masgHash
     * to: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
     * amount: 1000
     * 对应的消息msgHash: 0xb4a4ba10fbd6886a312ec31c54137f5714ddc0e93274da8746a36d2fa96768be
     */
    function getMessageHash(
        address to,
        uint256 amount
    ) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(to, amount));
    }

    /**
     * @dev 获得以太坊签名消息
     * `hash`:消息哈希
     * 遵从以太坊签名标准：https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
     * 以及`EIP191`:https://eips.ethereum.org/EIPS/eip-191`
     * 添加"\x19Ethereum Signed Message:\n32"字段，防止签名的是可执行交易。
     */
    function toEthSignedMessageHash(
        bytes32 hash
    ) public pure returns (bytes32) {
        // 32 is the length in bytes of hash,
        // enforced by the type signature above
        return
            keccak256(
                abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
            );
    }

    //ECDSA验证
    function verify(
        bytes32 _msgHash,
        bytes memory _signature
    ) public view returns (bool) {
        return ECDSA.recover(_msgHash, _signature) == signer;
    }

    mapping(address => bool) public mintedAddress; //记录已经mint的地址

    function goodMint(address to, uint amount, bytes memory signature) public {
        bytes32 _msgHash = toEthSignedMessageHash(getMessageHash(to, amount));
        require(verify(_msgHash, signature), "Invalid Signer");
        //检查该地址是否mint过
        require(!mintedAddress[to], "Already minted");
        //记录mint过的地址
        mintedAddress[to] = true;
        _mint(to, amount);
    }

    uint nonce;

    function nonceMint(address to, uint amount, bytes memory signature) public {
        bytes32 _msgHash = toEthSignedMessageHash(
            keccak256(abi.encodePacked(to, amount, nonce, block.chainid))
        );
        require(verify(_msgHash, signature), "Invalid Signer!");
        _mint(to, amount);
        nonce++;
    }
}
