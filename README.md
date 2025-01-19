# DeFi Lending Protocol

A decentralized lending protocol built on Ethereum that enables users to deposit collateral, borrow assets, and earn interest on deposits.

## Features

- Deposit tokens as collateral
- Borrow against deposited collateral
- Variable interest rates
- Automated health checks
- Liquidation mechanisms
- Support for multiple ERC20 tokens

## Prerequisites

- Node.js >= 16.0.0
- npm >= 7.0.0
- Hardhat

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/defi-lending.git
cd defi-lending
```

2. Install dependencies:
```bash
npm install
```

3. Create a `.env` file in the root directory and add your configuration:
```env
PRIVATE_KEY=your_private_key_here
ETHERSCAN_API_KEY=your_etherscan_api_key_here
INFURA_API_KEY=your_infura_api_key_here
```

## Smart Contracts

- `LendingProtocol.sol`: Main lending protocol implementation
- `TestToken.sol`: ERC20 token for testing purposes

## Development

1. Compile contracts:
```bash
npx hardhat compile
```

2. Run tests:
```bash
npx hardhat test
```

3. Start local node:
```bash
npx hardhat node
```

4. Deploy contracts:
```bash
npx hardhat run scripts/deploy.js --network localhost
```

## Testing

Run the test suite:

```bash
npx hardhat test
npx hardhat coverage
```

## Deployment

1. Update `hardhat.config.js` with your network configuration
2. Deploy to the desired network:
```bash
npx hardhat run scripts/deploy.js --network <network-name>
```

## Security

This project is for educational purposes only. Do not use in production without proper security audits.

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.