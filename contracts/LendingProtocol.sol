// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract LendingProtocol is ReentrancyGuard, Ownable {
    // State variables
    mapping(address => mapping(address => uint256)) public deposits; // user => token => amount
    mapping(address => mapping(address => uint256)) public borrows; // user => token => amount
    mapping(address => uint256) public collateralFactors; // token => collateral factor (in basis points)
    mapping(address => bool) public supportedTokens;
    
    uint256 public constant COLLATERAL_FACTOR_DECIMALS = 10000; // 100% = 10000
    uint256 public constant INTEREST_RATE_DECIMALS = 10000;
    uint256 public borrowInterestRate = 500; // 5% APR

    // Events
    event Deposit(address indexed user, address indexed token, uint256 amount);
    event Withdraw(address indexed user, address indexed token, uint256 amount);
    event Borrow(address indexed user, address indexed token, uint256 amount);
    event Repay(address indexed user, address indexed token, uint256 amount);

    constructor() {
        // Constructor logic here
    }

    // Add a new supported token with its collateral factor
    function addSupportedToken(address token, uint256 collateralFactor) external onlyOwner {
        require(collateralFactor <= COLLATERAL_FACTOR_DECIMALS, "Invalid collateral factor");
        supportedTokens[token] = true;
        collateralFactors[token] = collateralFactor;
    }

    // Deposit tokens as collateral
    function deposit(address token, uint256 amount) external nonReentrant {
        require(supportedTokens[token], "Token not supported");
        require(amount > 0, "Amount must be greater than 0");

        IERC20(token).transferFrom(msg.sender, address(this), amount);
        deposits[msg.sender][token] += amount;

        emit Deposit(msg.sender, token, amount);
    }

    // Withdraw deposited tokens
    function withdraw(address token, uint256 amount) external nonReentrant {
        require(amount > 0, "Amount must be greater than 0");
        require(deposits[msg.sender][token] >= amount, "Insufficient deposit");
        require(_isHealthy(msg.sender), "Unhealthy position");

        deposits[msg.sender][token] -= amount;
        IERC20(token).transfer(msg.sender, amount);

        emit Withdraw(msg.sender, token, amount);
    }

    // Borrow tokens
    function borrow(address token, uint256 amount) external nonReentrant {
        require(supportedTokens[token], "Token not supported");
        require(amount > 0, "Amount must be greater than 0");
        
        borrows[msg.sender][token] += amount;
        require(_isHealthy(msg.sender), "Insufficient collateral");

        IERC20(token).transfer(msg.sender, amount);
        
        emit Borrow(msg.sender, token, amount);
    }

    // Repay borrowed tokens
    function repay(address token, uint256 amount) external nonReentrant {
        require(amount > 0, "Amount must be greater than 0");
        require(borrows[msg.sender][token] >= amount, "Amount exceeds debt");

        IERC20(token).transferFrom(msg.sender, address(this), amount);
        borrows[msg.sender][token] -= amount;

        emit Repay(msg.sender, token, amount);
    }

    // Calculate account health
    function _isHealthy(address user) internal view returns (bool) {
        uint256 totalCollateralValue = 0;
        uint256 totalBorrowValue = 0;

        // Calculate total collateral value
        address[] memory tokens = _getSupportedTokens();
        for (uint256 i = 0; i < tokens.length; i++) {
            address token = tokens[i];
            if (deposits[user][token] > 0) {
                uint256 collateralValue = (deposits[user][token] * collateralFactors[token]) / COLLATERAL_FACTOR_DECIMALS;
                totalCollateralValue += collateralValue;
            }
            if (borrows[user][token] > 0) {
                totalBorrowValue += borrows[user][token];
            }
        }

        return totalCollateralValue >= totalBorrowValue;
    }

    // Helper function to get all supported tokens
    function _getSupportedTokens() internal view returns (address[] memory) {
        // Implementation needed - return array of supported token addresses
        // This is a simplified version
        address[] memory tokens = new address[](1);
        return tokens;
    }

    // Get account information
    function getAccountInfo(address user) external view returns (
        uint256 totalCollateralValue,
        uint256 totalBorrowValue,
        bool isHealthy
    ) {
        totalCollateralValue = 0;
        totalBorrowValue = 0;

        address[] memory tokens = _getSupportedTokens();
        for (uint256 i = 0; i < tokens.length; i++) {
            address token = tokens[i];
            if (deposits[user][token] > 0) {
                uint256 collateralValue = (deposits[user][token] * collateralFactors[token]) / COLLATERAL_FACTOR_DECIMALS;
                totalCollateralValue += collateralValue;
            }
            if (borrows[user][token] > 0) {
                totalBorrowValue += borrows[user][token];
            }
        }

        isHealthy = totalCollateralValue >= totalBorrowValue;
    }
}