const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");


module.exports = buildModule("BankModule", (m) => {
  
    const Bank = m.contract("Bank", [], );
  
    return { Bank };
  });
  