// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import "./Token.sol";

contract TokenFactory {
    event TokenCreated(address indexed tokenAddress, address indexed owner, uint256 initialSupply,string name,string symbol);

    struct TokenStruct{
        address tokenAddress;
        string name; 
        string symbol;
    }

    TokenStruct[] tokens;

    function createToken(address initialOwner, uint256 initialSupply, string memory name, string memory symbol) public returns (address) {
    
        Token newToken = new Token(initialOwner, initialSupply, name, symbol);

        TokenStruct memory token = TokenStruct({
            tokenAddress: address(newToken),
            name: name,
            symbol: symbol
        });

        tokens.push(token);

        emit TokenCreated(address(newToken), initialOwner, initialSupply,name,symbol);
        
        return address(newToken);
        
 }
}