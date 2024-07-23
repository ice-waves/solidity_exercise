const { ethers } = require("hardhat");

async function main() {
    // 获取用于部署合约的账户
    const [deployer] = await ethers.getSigners();

    // 显示部署账户的地址和余额
    console.log("Deploying contracts with the account:", deployer.address);
    const balance = await deployer.getBalance();
    console.log("Account balance:", balance.toString());

    // 部署 WETH 合约
    const WETH = await ethers.getContractFactory("WETH");
    const weth = await WETH.deploy();

    // 等待合约部署完成
    await weth.deployed();

    // 打印部署后的合约地址
    console.log("WETH deployed to:", weth.address);
}

// 执行部署并捕捉可能的错误
main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });