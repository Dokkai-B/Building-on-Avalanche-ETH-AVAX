## DegenToken Smart Contract

### Description
DegenToken is an ERC20 token with minting and burning functionalities. This token will be used in Degen Gaming's ecosystem for rewarding players and enabling them to redeem items in the in-game store.

### Features
- **Minting Tokens:** The contract owner can mint new tokens to a specified address.
- **Transferring Tokens:** Users can transfer tokens to others.
- **Burning Tokens:** Users can burn their tokens.
- **Redeeming Tokens:** Users can redeem their tokens for items in the in-game store.

### Smart Contract Code
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract DegenToken is ERC20, Ownable, ERC20Burnable {
    event TokensRedeemed(address indexed user, string item, uint256 amount);

    constructor() ERC20("Degen", "DGN") Ownable() {
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

    function redeemTokens(uint256 amount, string memory item) public {
        require(balanceOf(msg.sender) >= amount, "Insufficient tokens to redeem");
        _burn(msg.sender, amount);
        emit TokensRedeemed(msg.sender, item, amount);
    }
}
```

## Deployment

The DegenToken smart contract is deployed on the Avalanche Fuji Testnet. You can view the contract on Snowtrace at the following address:
[Snowtrace: DegenToken](https://testnet.snowtrace.io/address/0x0a4a804a5fe3CF2F2234510A6334b9f4ae8E421a)

## Step-by-Step Deployment Guide

### Install Prerequisites:
Make sure you have Node.js installed. You can download it from [Node.js official site](https://nodejs.org/).

### Install Hardhat:
```bash
npm install --save-dev hardhat
```

### Initialize Hardhat Project:
```bash
npx hardhat
```

### Install OpenZeppelin Contracts:
```bash
npm install @openzeppelin/contracts
```

### Create Smart Contract:
Create a file named `DegenToken.sol` in the `contracts` directory and paste the smart contract code provided above.

### Compile the Contract:
```bash
npx hardhat compile
```

### Deploy the Contract:
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

### Run the deployment script:

```bash
npx hardhat run scripts/deploy.js --network fuji
```

### Interacting with the Contract using Remix

#### Mint Tokens:
Only the owner can mint new tokens.

1. Go to the "Deploy & Run Transactions" tab in Remix.
2. Select the deployed `DegenToken` contract.
3. Under "Deployed Contracts," find the `mint` function.
4. Enter the address you want to mint tokens to and the amount of tokens to mint, then click "transact."

#### Transfer Tokens:
Users can transfer tokens to others.

1. In the "Deployed Contracts" section, find the `transferTokens` function.
2. Enter the receiver's address and the amount of tokens to transfer, then click "transact."

#### Burn Tokens:
Users can burn their tokens.

1. In the "Deployed Contracts" section, find the `burnTokens` function.
2. Enter the amount of tokens you want to burn, then click "transact."

#### Redeem Tokens:
Users can redeem their tokens for items in the in-game store.

1. In the "Deployed Contracts" section, find the `redeemTokens` function.
2. Enter the amount of tokens to redeem and the item name, then click "transact."

### Documentation and Help
For more information on using Hardhat, refer to the [Hardhat documentation](https://hardhat.org/docs). If you need help with OpenZeppelin contracts, check the [OpenZeppelin documentation](https://docs.openzeppelin.com/).

If you encounter any issues or have questions, feel free to open an issue on this repository or reach out to the community for support.
