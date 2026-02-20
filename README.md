# Flash Loan Arbitrage Bot

This repository contains a professional Solidity smart contract designed to interact with Aave V3 for Flash Loans. It allows a developer to borrow millions in liquidity, execute a series of trades (e.g., across Uniswap or SushiSwap), and repay the loan in a single transaction.

## Features
* **Aave V3 Integration**: Uses the latest `IPool` interfaces for gas-efficient borrowing.
* **Atomic Execution**: If the arbitrage does not result in a profit sufficient to cover the flash loan fee, the entire transaction reverts automatically.
* **Minimalist Design**: All logic is contained in a single contract to reduce deployment costs.
* **Security**: Includes `onlyOwner` modifiers to prevent unauthorized entities from triggering your arbitrage logic.

## Technical Flow
1. **Request**: Contract calls `flashLoanSimple` on the Aave Pool.
2. **Execute**: Aave sends funds and calls `executeOperation` on your contract.
3. **Arbitrage**: Your custom logic swaps Token A for Token B on Exchange 1, and back to Token A on Exchange 2.
4. **Repay**: The contract automatically approves Aave to pull the principal + fee.

## License
MIT
