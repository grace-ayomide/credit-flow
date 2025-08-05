# CreditFlow - Advanced DeFi Credit Protocol

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Clarity Version](https://img.shields.io/badge/Clarity-v3-blue.svg)](https://docs.stacks.co/clarity)
[![Stacks](https://img.shields.io/badge/Stacks-Bitcoin%20L2-orange.svg)](https://stacks.co)

## Overview

CreditFlow is a revolutionary peer-to-peer lending platform that transforms traditional borrowing through intelligent credit assessment and adaptive risk management on Bitcoin's most secure Layer 2 infrastructure. Built on Stacks, CreditFlow eliminates the need for excessive collateralization through sophisticated on-chain reputation systems.

### Key Value Propositions

- **Reduced Collateral Requirements**: Smart credit scoring reduces collateral needs for trustworthy borrowers
- **Dynamic Interest Rates**: Performance-based pricing that rewards good credit behavior
- **Portable Credit History**: Immutable, blockchain-based reputation that follows users across DeFi
- **Bitcoin Security**: Leverages Bitcoin's unmatched security through Stacks Layer 2
- **Transparent & Decentralized**: No intermediaries, algorithmic decision-making

## Architecture & Innovation

### Intelligent Credit Scoring

- **Score Range**: 50-100 scale with dynamic adjustments
- **Performance Tracking**: Automatic score updates based on repayment behavior
- **Risk Assessment**: Lower scores require higher collateral, higher interest rates

### Adaptive Risk Management

- **Collateral Optimization**: Credit score directly impacts collateral requirements
- **Interest Rate Calculation**: Performance-based rate determination
- **Default Protection**: Automated loan marking and penalty systems

### Key Features

✅ **Multi-Loan Portfolio Management** - Support for up to 5 concurrent active loans  
✅ **Reputation-Based Lending** - Credit scores determine loan terms  
✅ **Automated Collateral Release** - Smart contract handles repayment processing  
✅ **Default Resolution** - Transparent penalty system for missed payments  
✅ **Historical Tracking** - Immutable transaction and performance history  
✅ **Admin Controls** - Contract owner can mark overdue loans as defaulted  

## Technical Specifications

### System Parameters

| Parameter | Value | Description |
|-----------|-------|-------------|
| **MIN-SCORE** | 50 | Minimum possible credit score |
| **MAX-SCORE** | 100 | Maximum possible credit score |
| **MIN-LOAN-SCORE** | 70 | Minimum score required for loan eligibility |
| **MAX-ACTIVE-LOANS** | 5 | Maximum concurrent loans per user |
| **MAX-LOAN-DURATION** | 52,560 blocks | ~1 year maximum loan term |

### Credit Score Mechanics

- **Initial Score**: New users start with minimum score (50)
- **Score Improvement**: +2 points per successful loan repayment
- **Score Penalty**: -10 points per loan default
- **Score Bounds**: Enforced minimum (50) and maximum (100) limits

### Financial Calculations

#### Collateral Requirements

```clarity
collateral-ratio = 100 - (score * 50 / 100)
required-collateral = (loan-amount * collateral-ratio) / 100
```

#### Interest Rate Determination

```clarity
base-rate = 10%
interest-rate = base-rate - (score * 5 / 100)
```

## Smart Contract Interface

### Public Functions

#### `initialize-score()`

Creates initial credit profile for new users.

- **Access**: Any user (one-time only)
- **Effect**: Sets credit score to minimum value (50)

#### `request-loan(amount, collateral, duration)`

Requests a new loan with specified parameters.

- **Parameters**:
  - `amount`: Loan principal in STX
  - `collateral`: Collateral amount in STX
  - `duration`: Loan duration in blocks
- **Requirements**:
  - Credit score ≥ 70
  - ≤ 5 active loans
  - Sufficient collateral based on credit score

#### `repay-loan(loan-id, amount)`

Makes payment toward an active loan.

- **Parameters**:
  - `loan-id`: Unique loan identifier
  - `amount`: Payment amount in STX
- **Effects**:
  - Updates loan balance
  - Improves credit score on full repayment
  - Releases collateral when fully paid

#### `mark-loan-defaulted(loan-id)` *(Admin Only)*

Marks an overdue loan as defaulted.

- **Access**: Contract owner only
- **Requirements**: Loan must be past due date
- **Effects**: Applies credit score penalty to borrower

### Read-Only Functions

#### `get-user-score(user)`

Returns comprehensive credit profile for a user.

#### `get-loan(loan-id)`

Returns complete loan details and status.

#### `get-user-active-loans(user)`

Returns list of active loan IDs for a user.

#### `get-system-stats()`

Returns global system statistics.

### Error Codes

| Code | Error | Description |
|------|-------|-------------|
| u1 | ERR-UNAUTHORIZED | Insufficient permissions |
| u2 | ERR-INSUFFICIENT-BALANCE | Insufficient collateral provided |
| u3 | ERR-INVALID-AMOUNT | Invalid loan or payment amount |
| u4 | ERR-LOAN-NOT-FOUND | Loan does not exist |
| u5 | ERR-LOAN-DEFAULTED | Loan has been marked as defaulted |
| u6 | ERR-INSUFFICIENT-SCORE | Credit score too low for loan |
| u7 | ERR-ACTIVE-LOAN | Too many active loans |
| u8 | ERR-NOT-DUE | Loan is not yet overdue |
| u9 | ERR-INVALID-DURATION | Invalid loan duration |
| u10 | ERR-INVALID-LOAN-ID | Invalid loan identifier |

## Development Setup

### Prerequisites

- [Node.js](https://nodejs.org/) (v16+)
- [Clarinet](https://github.com/hirosystems/clarinet) CLI tool
- [Git](https://git-scm.com/)

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/grace-ayomide/credit-flow.git
   cd credit-flow
   ```

2. **Install dependencies**

   ```bash
   npm install
   ```

3. **Verify setup**

   ```bash
   clarinet check
   ```

### Development Commands

```bash
# Run contract syntax check
clarinet check

# Run unit tests
npm test

# Run tests with coverage
npm run test:report

# Watch mode for continuous testing
npm run test:watch

# Start local development environment
clarinet console
```

### Project Structure

```bash
credit-flow/
├── contracts/
│   └── credit-flow.clar          # Main smart contract
├── tests/
│   └── credit-flow.test.ts       # Comprehensive test suite
├── settings/
│   ├── Devnet.toml               # Development network config
│   ├── Testnet.toml              # Testnet configuration
│   └── Mainnet.toml              # Mainnet configuration
├── Clarinet.toml                 # Project configuration
├── package.json                  # Node.js dependencies
└── README.md                     # This file
```

## Testing

The project includes comprehensive unit tests covering all major functionalities:

- Credit score initialization and management
- Loan request validation and processing
- Repayment handling and credit score updates
- Default marking and penalty application
- Edge cases and error conditions

Run the full test suite:

```bash
npm test
```

## Usage Examples

### Basic Loan Workflow

1. **Initialize Credit Profile**

   ```clarity
   (contract-call? .credit-flow initialize-score)
   ```

2. **Request a Loan**

   ```clarity
   (contract-call? .credit-flow request-loan u1000000 u750000 u1440) ;; 1 STX loan, 0.75 STX collateral, 1 day
   ```

3. **Make Payments**

   ```clarity
   (contract-call? .credit-flow repay-loan u1 u500000) ;; Partial payment
   (contract-call? .credit-flow repay-loan u1 u550000) ;; Final payment
   ```

4. **Check Credit Score**

   ```clarity
   (contract-call? .credit-flow get-user-score 'SP1ABC...)
   ```

## Security Considerations

### Auditing Status

⚠️ **This contract has not been audited.** Use at your own risk in production environments.

### Security Features

- **Access Controls**: Admin functions restricted to contract owner
- **Input Validation**: Comprehensive parameter validation
- **Overflow Protection**: Safe arithmetic operations
- **State Consistency**: Atomic operations prevent inconsistent states

### Known Limitations

- Credit scores start at minimum for all new users
- No external credit history integration
- Fixed interest rate calculation algorithm
- Manual default marking required by admin

## Deployment

### Testnet Deployment

```bash
clarinet integrate
```

### Mainnet Deployment

Ensure thorough testing and auditing before mainnet deployment.

## Contributing

We welcome contributions! Please follow these guidelines:

1. Fork the repository
2. Create a feature branch
3. Write comprehensive tests
4. Follow Clarity coding standards
5. Submit a pull request

### Development Standards

- All functions must include comprehensive comments
- Test coverage should exceed 90%
- Follow established naming conventions
- Include proper error handling

## Roadmap

### Phase 1 (Current)

- ✅ Core lending functionality
- ✅ Credit scoring system
- ✅ Basic risk management

### Phase 2 (Planned)

- 🔄 External credit score integration
- 🔄 Liquidation mechanisms
- 🔄 Interest rate optimization

### Phase 3 (Future)

- 📋 Cross-chain compatibility
- 📋 Advanced analytics dashboard
- 📋 Governance token integration

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support & Community

- **Documentation**: [Stacks Documentation](https://docs.stacks.co/)
- **Discord**: [Stacks Discord](https://discord.gg/stacks)
