// SPDX-License-Identifier:<SPDX-License>
pragma solidity >= 0.7.0 < 0.9.0;
contract wallet{
  event log(address owner,uint balance);

  constructor(){
    owner = payable(msg.sender);
  }
  receive() external payable{}
  
  modifier errorMessage(){
    require(msg.sender == owner, "Not the Owner");
    _;
    require(_amount <=balance,"Insufficient funds");
    _;
  }

  function withdraw (uint _amount)public{
    payable(msg.sender).transfer(_amount);
    balance -= amount;
  }
}