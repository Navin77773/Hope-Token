// SPDX-License-Identifier: MIT
pragma solidity ^ 0.8.17;

import {ERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract HopeToken is ERC20Capped,ERC20Burnable{
    address payable owner;
    uint decimal = 1e18;
    uint256 initialSupply=7000000*decimal;
    uint blockReward;
    
    constructor(uint cap,uint reward) ERC20("HopeToken","HPT")ERC20Capped(cap*decimal){
        owner = payable(msg.sender);
        _mint(msg.sender,initialSupply); //initial supply = 21 Millions
        blockReward = reward;
    }

    modifier onlyOwner{
        require(msg.sender==owner,"only owner can call this function");
        _;
    }
    
    function _mint(address account, uint256 amount) internal virtual override(ERC20Capped, ERC20) {
        require(ERC20.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
        super._mint(account, amount);
    }

    function setBlockReward(uint reward) public onlyOwner{
        blockReward=reward*decimal;
    }
    
    function _mintMinerReward() internal {
        _mint(block.coinbase,blockReward); //block.coinbase - address of the miner who mined the block
    }
    
    function _beforeTokenTransfer(address from,address to,uint value) internal virtual override{
        if(from != address(0) && to !=block.coinbase && block.coinbase != address(0)){ // condition 1 checks if address is valid , condition 2 avoids infinate loop for reward for reward.
             _mintMinerReward();
        }
        super._beforeTokenTransfer(from,to,value);
    }

    function destroy() public onlyOwner{
        selfdestruct(owner);
    }
}