const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");


module.exports = buildModule("TodoListModule", (m) => {
  
    const TodoList = m.contract("TodoList", []);
  
    return { TodoList };
  });
  