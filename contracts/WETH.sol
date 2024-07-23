// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

contract WETH {
    string public name = "Wrapped Ether";
    string public symbol = "WETH";
    uint8 public decimals = 18;
    
    // indexed 可以在事件参数上增加indexed属性，
    // 最多可以对三个参数增加这样的属性。加上这个属性，
    // 可以允许你在web3.js或ethes.js中通过对加了这个属性的参数进行值过滤
    event Approvel(address indexed src, address indexed delegateAds, uint256 amount);
    event Transfer(address indexed src, address indexed toAds, uint256 amount);
    event Deposit(address indexed toAds, uint256 amount);
    event Withdraw(address indexed src, uint256 amount);

    // balanceOf: 查询指定地址的 Token 数量
    mapping(address => uint256) public balanceOf;

    // allowance: 查询指定地址对另外一个地址的剩余授权额度
    mapping(address => mapping(address => uint256)) public allowance;

    function deposit() public payable {
        balanceOf[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) public {
        require(balanceOf[msg.sender] >= amount);
        balanceOf[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
        emit Withdraw(msg.sender, amount);
    }

    // 当前合约的总的token数量
    function totalSupply() public view returns (uint256) {
        return address(this).balance;
    }

    // approve: 授权指定地址可以操作调用者的最大 Token 数量。
    function approve(address delegateAds, uint256 amount) public returns (bool) {
        allowance[msg.sender][delegateAds] = amount;
        emit Approvel(msg.sender, delegateAds, amount);
        return true;
    }

    // transfer: 从当前调用者地址发送指定数量的 Token 到指定地址。
    function transfer(address toAds, uint256 amount) public returns (bool) {
        return transferFrom(msg.sender, toAds, amount);
    }

    // transferFrom: 当向另外一个合约地址存款时，对方合约必须调用 transferFrom 才可以把 Token 拿到它自己的合约中。
    function transferFrom(
        address src,
        address toAds,
        uint256 amount
    ) public returns (bool) {
        require(balanceOf[src] >= amount);
        if (src != msg.sender) {
            require(allowance[src][msg.sender] >= amount);
            allowance[src][msg.sender] -= amount;
        }
        balanceOf[src] -= amount;
        balanceOf[toAds] += amount;
        emit Transfer(src, toAds, amount);
        return true;
    }

    fallback() external payable {
        deposit();
    }

    receive() external payable {
        deposit();
    }
}