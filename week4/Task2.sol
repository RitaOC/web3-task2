// SPDX-License-Identifier:UNLINCENSED


// to store,send and withdraw ether
pragma solidity >= 0.7.0 < 0.9.0;
contract wallet{
  address public owner;
  uint private ownerFee;

  mapping(address => uint) public balance;

  // emit is used to save gas by storing the paramets on the bl0ckchain directly
  event stored (uint timestamp,address sender,uint amount);
  event Withdraw (uint timestamp,address sender,uint amount);
  event Transfer (uint timestamp,address sender,address receiver, uint amount);
   
  modifier onlyOwner(uint _amount){
    // only the owner can send ether
    require (msg.sender == owner, "Not the Owner");
    _;
  }
   modifier onlyUser(uint _amount){
    // to avoid sending what you dont have
    require( balance[msg.sender] >= _amount,"Insufficient funds");
    _;
  }

  // to be called only once
  constructor(){
   owner = payable(msg.sender) ;
  }

   // storing ether
  receive() external payable{
    // balance[msg.sender] += msg.value;
    ownerFee = msg.value/10;
    balance[msg.sender] += msg.value + (msg.value/10);

    emit stored (block.timestamp,msg.sender,msg.value);
  }

  // withdraw ether
  function withdraw (uint _amount) onlyUser(_amount)external{
    balance[msg.sender] -= _amount;
    payable(msg.sender).transfer(_amount);
    emit Withdraw(block.timestamp,msg.sender,_amount);
  }

  // Transfer ether,updating the balance and allowing only the user pay for the gas fees
  function transfer(uint _amount,address _receiver) onlyUser(_amount) external{
    balance[msg.sender] -= _amount;
    balance[_receiver] -= _amount;
    emit Transfer(block.timestamp,msg.sender,_receiver ,_amount);
  }

  // Owner withdraws their percentage from the contract
  function ownerTransfer() onlyOwner(ownerFee) external{
    payable (msg.sender).transfer(ownerFee);
    ownerFee = 0;
  }

  function getbalance()external view returns (uint){
    return address(this).balance;
  }
  
}
