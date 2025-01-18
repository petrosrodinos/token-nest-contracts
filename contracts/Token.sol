// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract Token is ERC20, Ownable, ERC20Permit {

    mapping(address => uint256) public staked;
    mapping(address => uint256) private stakedFromTS;

    constructor(address initialOwner, uint256 initialSupply, string memory name, string memory symbol)
        ERC20(name, symbol)
        Ownable(initialOwner)
        ERC20Permit("Token")
    {
        _mint(address(this), initialSupply * 10 ** decimals());
    }

    function stake(uint256 amount) external {
        require(amount > 0,"Amount is <=0");
        require(balanceOf(msg.sender)>= amount,"Not Enough Balance");

        _transfer(msg.sender,address(this),amount);

        if(staked[msg.sender]>0){
            claim();
        }

        stakedFromTS[msg.sender] = block.timestamp;
        staked[msg.sender] +=amount;
    }

    function unstake(uint256 amount) external{
        require(amount>0, "Amount is <=0");
        require(staked[msg.sender] >= amount,"Not Enough Balance");

        claim();

        staked[msg.sender] -= amount;

        _transfer(address(this), msg.sender, amount);
    }

    function claim() public{
        require(staked[msg.sender]>0,"staked is <=0");

        uint256 secondsStaked = block.timestamp - stakedFromTS[msg.sender];
        uint256 rewards = staked[msg.sender] * secondsStaked / 3.154e7;
        _mint(msg.sender,rewards);
        stakedFromTS[msg.sender] = block.timestamp;
    }


}
