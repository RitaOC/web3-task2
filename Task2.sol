// SPDX-License-Identifier:UNLINCENSED
pragma solidity >= 0.7.0 < 0.9.0;
contract wallet{
  address public owner;
  uint public balance;

  constructor(){
   owner = payable(msg.sender) ;
  }
  receive() external payable{
    balance += msg.value;
  }
  
  modifier errorMessage(){
    require (msg.sender == owner, "Not the Owner");
    _;
 
  }

  function withdraw (uint _amount)external errorMessage{
    require( _amount >= balance,"Insufficient funds");
    payable(msg.sender).transfer(_amount);
    balance -= _amount;
  }
  
}