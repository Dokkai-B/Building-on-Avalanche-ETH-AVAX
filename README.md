# DegenToken Smart Contract

## Description
DegenToken is an ERC20 token with minting, burning, and redeeming functionalities. This token will be used in Degen Gaming's ecosystem for rewarding players and enabling them to redeem items in the in-game store.

## Features
- **Minting Tokens**: The contract owner can mint new tokens to a specified address.
- **Transferring Tokens**: Users can transfer tokens to others.
- **Burning Tokens**: Users can burn their tokens.
- **Redeeming Tokens**: Users can redeem their tokens for items in the in-game store.
- **Checking Token Balance**: Users can check their token balance at any time.

## Smart Contract Code

```solidity
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
```

## Deployment

The DegenToken smart contract is deployed on the Avalanche Fuji Testnet. You can view the contract on Snowtrace at the following address:  
[Snowtrace: DegenToken](https://snowtrace.io/address/0x0a4a804a5fe3CF2F2234510A6334b9f4ae8E421a)

## Step-by-Step Deployment Guide

### Install Prerequisites
Make sure you have Node.js installed. You can download it from the [Node.js official site](https://nodejs.org/).

### Install Hardhat
```bash
npm install --save-dev hardhat
```

### Initialize Hardhat Project

```bash
npx hardhat
```

### Install OpenZeppelin Contracts

```bash
npm install @openzeppelin/contracts
```

### Create Smart Contract

Create a file named `DegenToken.sol` in the `contracts` directory and paste the smart contract code provided above.

### Compile the Contract

```bash
npx hardhat compile
```

### Deploy the Contract

Create a deployment script in the `scripts` directory named `deploy.js`:

```javascript
const hre = require("hardhat");

async function main() {
  const DegenToken = await hre.ethers.getContractFactory("DegenToken");
  const degenToken = await DegenToken.deploy();

  await degenToken.deployed();

  console.log("DegenToken deployed to:", degenToken.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
```

### Run the deployment script

```bash
npx hardhat run scripts/deploy.js --network fuji
```

## Interacting with the Contract

### Mint Tokens

Only the owner can mint new tokens.

In Remix, connect to the contract and call the `mint` function with the desired address and amount.

```javascript
await degenToken.mint("0xYourAddress", 1000);
```

### Transfer Tokens

Users can transfer tokens to others.

In Remix, connect to the contract and call the `transferTokens` function with the receiver address and amount.

```javascript
await degenToken.transferTokens("0xReceiverAddress", 100);
```

### Burn Tokens

Users can burn their tokens.

In Remix, connect to the contract and call the `burnTokens` function with the amount.

```javascript
await degenToken.burnTokens(100);
```

### Redeem Tokens

Users can redeem their tokens for items in the in-game store.

In Remix, connect to the contract and call the `redeemTokens` function with the item name.

```javascript
await degenToken.redeemTokens("ItemName"); // Example for redeeming an item by name
```

## Documentation and Help

For more information on using Hardhat, refer to the [Hardhat documentation](https://hardhat.org/docs). If you need help with OpenZeppelin contracts, check the [OpenZeppelin documentation](https://docs.openzeppelin.com/).

If you encounter any issues or have questions, feel free to open an issue on this repository or reach out to the community for support.
