pragma solidity 0.8.4;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {

  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
  event SellTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
  uint256 public constant tokensPerEth = 100;

  YourToken public yourToken;

  constructor(address tokenAddress) {
    yourToken = YourToken(tokenAddress);
  }


 // ToDo: create a payable buyTokens() function:

  function buyTokens() public payable {
    uint256 amountOfEth = msg.value;
    uint256  amountOfTokens = amountOfEth * tokensPerEth;
    require(amountOfEth > 0, "Send some ETH to buy tokens");
    address buyer = msg.sender;
    require(yourToken.balanceOf(address(this)) >= amountOfTokens, "Vendor does not have enough tokens");
    (bool sent) = yourToken.transfer(msg.sender, amountOfTokens);
    require(sent, "Failure to send PRSM");
    emit BuyTokens(buyer, amountOfEth, amountOfTokens);

  }

  // ToDo: create a withdraw() function that lets the owner withdraw ETH

  function withdraw() public onlyOwner {
    uint256 vendorBalance = address(this).balance;
    require(vendorBalance > 0, "Vendor does not have any ETH to withdraw");

    // Send ETH
    address owner = msg.sender;
    (bool sent, ) = owner.call{value: vendorBalance}("");
    require(sent, "Failed to withdraw");
  }

  // ToDo: create a sellTokens() function:

}
