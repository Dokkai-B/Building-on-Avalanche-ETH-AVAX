/*
CHALLENGE
Your task is to create a ERC20 token and deploy it on the Avalanche network for Degen Gaming. The smart contract should have the following functionality:

1. Minting new tokens: The platform should be able to create new tokens and distribute them to players as rewards. Only the owner can mint tokens.
2. Transferring tokens: Players should be able to transfer their tokens to others.
3. Redeeming tokens: Players should be able to redeem their tokens for items in the in-game store.
4. Checking token balance: Players should be able to check their token balance at any time.
5. Burning tokens: Anyone should be able to burn tokens, that they own, that are no longer needed.
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract DegenToken is ERC20, Ownable, ERC20Burnable {
    struct Item {
        string name;
        uint256 price;
    }

    Item[] public items;

    event TokensRedeemed(address indexed user, string item, uint256 amount);

    constructor() ERC20("Degen", "DGN") Ownable(msg.sender) {
        _mint(msg.sender, 10000 * 10 ** decimals()); // Initial mint
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function decimals() public pure override returns (uint8) {
        return 18; // or set to 0 if you don't want decimals
    }

    function getBalance() external view returns (uint256) {
        return balanceOf(msg.sender);
    }

    function transferTokens(address _receiver, uint256 _value) external {
        require(balanceOf(msg.sender) >= _value, "You do not have enough Degen Tokens");
        transfer(_receiver, _value);
    }

    function burnTokens(uint256 _value) external {
        require(balanceOf(msg.sender) >= _value, "You do not have enough Degen Tokens");
        burn(_value);
    }

    function addItem(string memory itemName, uint256 itemPrice) public onlyOwner {
        items.push(Item(itemName, itemPrice));
    }

    function viewItems() public view returns (Item[] memory) {
        return items;
    }

    function redeemTokens(string memory itemName) public {
        uint256 itemIndex = findItemIndex(itemName);
        Item memory item = items[itemIndex];
        require(balanceOf(msg.sender) >= item.price, "Insufficient tokens to redeem");
        _burn(msg.sender, item.price);
        emit TokensRedeemed(msg.sender, item.name, item.price);
    }

    function findItemIndex(string memory itemName) internal view returns (uint256) {
        for (uint256 i = 0; i < items.length; i++) {
            if (keccak256(abi.encodePacked(items[i].name)) == keccak256(abi.encodePacked(itemName))) {
                return i;
            }
        }
        revert("Item not found");
    }
}

