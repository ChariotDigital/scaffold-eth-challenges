// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


contract Staker {

  ExampleExternalContract public exampleExternalContract;
  uint256 public constant threshold = 1 ether;
  mapping (address => uint256) balances;
  uint256 public deadline = block.timestamp + 30 minutes;
 


  modifier deadlineReached( bool requireReached ) {
    uint256 timeRemaining = timeLeft();
    if( requireReached ) {
      require(timeRemaining == 0, "Deadline is not reached yet");
    } else {
      require(timeRemaining > 0, "Deadline is already reached");
    }
    _;
  }



   modifier stakeNotCompleted() {
    bool completed = exampleExternalContract.completed();
    require(!completed, "staking process already completed");
    _;
  }


  event Stake(address,uint);

  constructor(address exampleExternalContractAddress) public {
      exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
  }

  function stake() public payable deadlineReached(false) stakeNotCompleted  returns (bool) {
    balances[msg.sender] = msg.value;

    emit Stake(msg.sender, msg.value);

    return true;
    
  } 

  function recieve() public payable {
    balances[msg.sender] += msg.value;
  }

  function execute() public stakeNotCompleted deadlineReached(true)  {
    uint256 contractBalance = address(this).balance;

    // check the contract has enough ETH to reach the treshold
    require(contractBalance >= threshold, "Threshold not reached");

    // Execute the external contract, transfer all the balance to the contract
    // (bool sent, bytes memory data) = exampleExternalContract.complete{value: contractBalance}();
    (bool sent,) = address(exampleExternalContract).call{value: contractBalance}(abi.encodeWithSignature("complete()"));
    require(sent, "exampleExternalContract.complete failed");
  } 

  function contractAmt() public returns (uint256) {
    return address(this).balance;
  }

  function timeLeft() public view returns (uint256 timeleft) {
    if( block.timestamp >= deadline ) {
      return 0;
    } else {
      return deadline - block.timestamp;
    }

    
  }

  // Function to allow the sender to withdraw all Ether from this contract.
  function withdraw() public deadlineReached(true) stakeNotCompleted {
      // get the amount of Ether stored in this contract from the current wallet
      uint256 amount = balances[msg.sender];
      require(amount > 0, "You don't have balance to withdraw");
      
      require(amount > 0, "No ETH in from user");
      balances[msg.sender] = 0;

      // send all Ether to owner
      // Owner can receive Ether since the address of owner is payable
      (bool success, ) = msg.sender.call{value: amount}("");
      require(success, "Failed to send Ether");
  }



  // Collect funds in a payable `stake()` function and track individual `balances` with a mapping:
  //  ( make sure to add a `Stake(address,uint256)` event and emit it for the frontend <List/> display )


  // After some `deadline` allow anyone to call an `execute()` function
  //  It should either call `exampleExternalContract.complete{value: address(this).balance}()` to send all the value


  // if the `threshold` was not met, allow everyone to call a `withdraw()` function


  // Add a `withdraw()` function to let users withdraw their balance


  // Add a `timeLeft()` view function that returns the time left before the deadline for the frontend


  // Add the `receive()` special function that receives eth and calls stake()


}
