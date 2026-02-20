// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IFlashLoanSimpleReceiver} from "@aave/core-v3/contracts/flashloan/interfaces/IFlashLoanSimpleReceiver.sol";
import {IPoolAddressesProvider} from "@aave/core-v3/contracts/flashloan/interfaces/IPoolAddressesProvider.sol";
import {IPool} from "@aave/core-v3/contracts/interfaces/IPool.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title FlashLoanArbitrage
 * @dev Contract for executing Aave V3 Flash Loans to perform arbitrage.
 */
contract FlashLoanArbitrage is IFlashLoanSimpleReceiver {
    address private immutable owner;
    IPoolAddressesProvider public immutable ADDRESSES_PROVIDER;
    IPool public immutable POOL;

    constructor(address _addressProvider) {
        ADDRESSES_PROVIDER = IPoolAddressesProvider(_addressProvider);
        POOL = IPool(IPoolAddressesProvider(_addressProvider).getPool());
        owner = msg.sender;
    }

    /**
     * @dev Trigger the flash loan.
     */
    function requestFlashLoan(address _token, uint256 _amount) public {
        require(msg.sender == owner, "Only owner");
        
        bytes memory params = ""; // Add custom arbitrage data here
        uint16 referralCode = 0;

        POOL.flashLoanSimple(
            address(this),
            _token,
            _amount,
            params,
            referralCode
        );
    }

    /**
     * @dev Logic executed by Aave after sending the loan.
     */
    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external override returns (bool) {
        // 1. ARBITRAGE LOGIC GOES HERE
        // Example: Swap asset on Uniswap for Profit

        // 2. Ensure we have enough to repay principal + fee
        uint256 amountToRepay = amount + premium;
        IERC20(asset).approve(address(POOL), amountToRepay);

        return true;
    }

    function getPool() external view override returns (IPool) {
        return POOL;
    }

    receive() external payable {}
}
