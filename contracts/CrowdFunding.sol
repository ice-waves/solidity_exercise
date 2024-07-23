// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;


contract CrowdFunding {

    address public immutable beneficiary; // 受益人
    uint256 public immutable fundingGoal; // 筹资目标数
    uint256 public fundingAmount; //当前已筹到金额

    mapping (address => uint256) public funders; // 资助者-金额
    mapping (address => bool) private fundersInserted ; // 资助名单
    address[] public fundersKey; // length

    bool public AVAILABLED = true; // 状态
    
    constructor(address beneficiary_,uint256 goal_){
        beneficiary = beneficiary_;
        fundingGoal = goal_;
    }

    // 资助，合约关闭后不可捐赠
    function contribute() external payable {
        require(AVAILABLED, "CrowdFunding is closed");

        
        // 检查捐赠金额是否会超过目标金额
        uint256 potentialFundingAmount = fundingAmount + msg.value;
        uint256 refundAmount = 0;

        if (potentialFundingAmount > fundingGoal) {
            refundAmount = potentialFundingAmount - fundingGoal;
            funders[msg.sender] += (msg.value - refundAmount);
            fundingAmount += (msg.value - refundAmount);
        } else {
            funders[msg.sender] += msg.value;
            fundingAmount += msg.value;
        }

        if (!fundersInserted[msg.sender]) {
            fundersInserted[msg.sender] = true;
            fundersKey.push(msg.sender);
        }

        // 超出的金额，退款
        if (refundAmount > 0) {
            payable(msg.sender).transfer(refundAmount);
        }
    }

    function close() external returns(bool) {
        // 1. 检查
        if (fundingAmount < fundingGoal) {
            return false;
        }

        // 2. 修改
        uint256 amount = fundingAmount;
        fundingAmount = 0;
        AVAILABLED = false;

        // 3. 操作
        payable(beneficiary).transfer(amount);
        return true;
    }

    function fundersLength() public view returns(uint256) {
        return fundersKey.length;
    }
}