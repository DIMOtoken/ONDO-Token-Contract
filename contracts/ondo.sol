// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ONDOToken is ERC20, Ownable {
    uint256 public lastMintedTimestamp;
    uint256 public mintRate = 0; // Default to 0%

    constructor(uint256 initialSupply) ERC20("Ondo", "ONDO") Ownable(msg.sender) {
        _mint(msg.sender, initialSupply);
        lastMintedTimestamp = block.timestamp;
    }

    function setMintRate(uint256 newRate) external onlyOwner {
        require(newRate >= 0 && newRate <= 50, "Rate should be between 0% and 50%");
        mintRate = newRate;
    }

    function mintAnnually() external onlyOwner {
        require(block.timestamp >= lastMintedTimestamp + 365 days, "Can only mint once a year");
        uint256 amountToMint = (totalSupply() * mintRate) / 100;
        _mint(msg.sender, amountToMint);
        lastMintedTimestamp = block.timestamp;
    }

    // Burn function to destroy tokens, restricted to contract owner
    function burn(uint256 amount) external onlyOwner {
        _burn(msg.sender, amount);
    }
}
