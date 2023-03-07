var  ethers = require('ethers');

//拿到生成的钱包信息
createWallet();

var mnemonic= "peace mouse scrap chase order guess volume unit riot save reopen nation"
getWalletByMnemonic(mnemonic);

const priKey = "0be427806c130f73704b2427e81f41ba1eabded4c9c3f91a74d50d646f52a992";
getWalletByPri(priKey);

function createWallet() {
    console.log("createWallet: ====");

    var wallet = ethers.Wallet.createRandom();

    //获取助记词
    var mnemonic = wallet.mnemonic;
    console.log("mnemonic: ", mnemonic);

    //获取path
    var path = wallet.path;
    console.log("wallet path：", path);

    //获取钱包的私钥
    var privateKey = wallet.privateKey;
    console.log("pri:", privateKey);

    //获取钱包地址
    var address = wallet.address;
    console.log("Address:", address);
}


function getWalletByPri(priKey) {
    //根据私钥找回钱包信息
    console.log("getWalletByPri：====")
    console.log("钱包私钥：",priKey)

    //根据私钥找回钱包地址
    var wallet = new ethers.Wallet(priKey);
    //钱包地址
    var address = wallet.address;
    console.log("钱包地址：",address)
}


function getWalletByMnemonic(mnemonic) {
    //根据助记词找回钱包信息
    console.log("getWalletByMnemonic:====")
    var mnemonic = ethers.Wallet.fromMnemonic(mnemonic);
    var priKey = mnemonic.privateKey;
    console.log("钱包私钥：",priKey)


    //根据私钥找回钱包地址
    var wallet = new ethers.Wallet(priKey);
    //钱包地址
    var address = wallet.address;
    console.log("钱包地址：",address)
}



//bip39操作钱包-----------------------------
const bip39 = require('bip39')//引入依赖
const HDWallet = require('ethereum-hdwallet')

const mnemonic1 = bip39.generateMnemonic(128,null,bip39.wordlists.chiness_simplified)//生成助记词
console.log('助记词' + mnemonic1);

getAddress(mnemonic1)
getAddressFromSameSeed(mnemonic1)

//通过随机助记词生成公私钥、地址
async function getAddress(mnemonic) {
    const seed = await bip39.mnemonicToSeed(mnemonic)//根据助记词生成seed
    const hdWallet = HDWallet.fromSeed(seed)//通过seed获取hdWallet
    const key = hdWallet.derive("m/44' /60' /0/0")//源于，得自。设置地址路径
    console.log("PrivateKey = " + key.getPrivateKey().toString('hex'))//私钥
    console.log("PublicKey = " + key.getPublicKey().toString('hex'))//公钥
    const EthAddress = '0x' + key.getAddress().toString('hex')//地址
    console.log("Eth Address = " + EthAddress)
}

//通过同一个seed获取多个地址
async function getAddressFromSameSeed(mnemonic) {
    const seed = await bip39.mnemonicToSeed(mnemonic)//根据助记词生成seed
    const hdwallet = HDWallet.fromSeed(seed)//通过seed获取hdWallet
    for(var i = 0; i < 10; i++) {
        const key = hdwallet.derive("m/44' /60' /0/0" + i)//源于，得自。设置地址路径
        console.log("========地址" + i + "===========")
        console.log("PrivateKey = " + key.getPrivateKey().toString('hex'))//私钥
        console.log("PublicKey = " + key.getPublicKey().toString('hex'))//公钥
        const EthAddress = '0x' + key.getAddress().toString('hex')//地址
        console.log("Eth Address = " + EthAddress)
    }
    
}

