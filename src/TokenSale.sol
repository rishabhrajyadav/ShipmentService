// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract TokenSale {
    uint256 private totalSupply;
    uint256 private tokenPrice;
    uint256 private saleDuration;

    mapping(address => uint256) private balance;
    mapping(address => uint256) private weektimer;
    
    constructor(
        uint256 _totalSupply,
        uint256 _tokenPrice,
        uint256 _saleDuration
    ) {
      totalSupply = _totalSupply;
      tokenPrice = _tokenPrice;
      saleDuration = block.timestamp + _saleDuration;
    }

    //This function should allow an address to purchase tokens during the token sale. The address can only purchase tokens once.
    // The function should check if the token sale is active, the amount sent is sufficient to purchase at least one token, and there are enough tokens available for purchase.
    function purchaseToken() public payable {
      uint256 duration  = saleDuration;
      uint256 tSupply = totalSupply;
      uint256 tPrice = tokenPrice;
      require(block.timestamp < duration);
      require(msg.value > tPrice && msg.value <= totalSupply*tPrice && msg.value % tPrice == 0);
      require(balance[msg.sender] == 0);
      
      totalSupply -= msg.value/tPrice;
      balance[msg.sender] = msg.value/tPrice;
    }

    function checkTokenBalance(address buyer) public view returns (uint256) {
        return balance[buyer];
    }

     function checkTokenPrice() public view returns (uint256) {
        return tokenPrice; //in wei
    }

    function saleTimeLeft() public view returns (uint256) {
        uint256 duration  = saleDuration;
        require(block.timestamp < duration);
        return duration - block.timestamp;
    }
    
    function sellTokenBack(uint256 amount) public {
      uint256 bal = 2 * balance[msg.sender]/10;
      require(amount <= bal);
      require(block.timestamp >= weektimer[msg.sender]);

      weektimer[msg.sender] = block.timestamp + 1 weeks;
      
      totalSupply += amount;
      balance[msg.sender] -= amount;
      (bool ok,) = payable(msg.sender).call{value : amount * tokenPrice}("");
      require(ok);
    }

}
