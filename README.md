# Blockchain-Based Fisheries Catch Certification System

A comprehensive blockchain solution for tracking and certifying fish catches from vessel to market, ensuring sustainability and traceability in the fishing industry.

## Overview

This system provides end-to-end traceability for commercial fishing operations using smart contracts on the Stacks blockchain. It covers the entire supply chain from vessel registration to final market sales.

## System Components

### 1. Vessel Registry Contract (`vessel-registry.clar`)
- **Purpose**: Manages registration and verification of commercial fishing vessels
- **Key Features**:
    - Vessel registration with owner verification
    - License number tracking
    - Vessel activation/deactivation
    - Owner vessel count management

### 2. Catch Documentation Contract (`catch-documentation.clar`)
- **Purpose**: Records and manages fishing catch data
- **Key Features**:
    - Catch recording with GPS coordinates
    - Species-specific catch logging
    - Fishing method documentation
    - Catch verification system

### 3. Species Verification Contract (`species-verification.clar`)
- **Purpose**: Manages fish species identification and validation
- **Key Features**:
    - Verified species database
    - Quota management
    - Seasonal restrictions
    - Protected species tracking

### 4. Sustainability Certification Contract (`sustainability-certification.clar`)
- **Purpose**: Certifies sustainable fishing practices
- **Key Features**:
    - Certificate issuance and management
    - Sustainability scoring system
    - Certificate expiration tracking
    - Performance-based scoring

### 5. Market Traceability Contract (`market-traceability.clar`)
- **Purpose**: Provides fish market traceability from catch to consumer
- **Key Features**:
    - Transaction recording
    - Product chain tracking
    - Ownership transfers
    - Authenticity verification

## Getting Started

### Prerequisites
- Clarinet CLI installed
- Node.js and npm for testing
- Stacks wallet for deployment

### Installation

1. Clone the repository:
   \`\`\`bash
   git clone <repository-url>
   cd fisheries-certification
   \`\`\`

2. Install dependencies:
   \`\`\`bash
   npm install
   \`\`\`

3. Run tests:
   \`\`\`bash
   npm test
   \`\`\`

### Deployment

1. Configure your deployment settings in \`Clarinet.toml\`
2. Deploy contracts:
   \`\`\`bash
   clarinet deploy --testnet
   \`\`\`

## Usage Examples

### Registering a Vessel
\`\`\`clarity
(contract-call? .vessel-registry register-vessel "Fishing Boat 1" "FB001" "Trawler")
\`\`\`

### Recording a Catch
\`\`\`clarity
(contract-call? .catch-documentation record-catch u1 123456 -654321 u1000 "Net Fishing")
\`\`\`

### Adding Species to Catch
\`\`\`clarity
(contract-call? .catch-documentation add-catch-species u1 u0 "Tuna" u500 u10)
\`\`\`

### Creating Market Transaction
\`\`\`clarity
(contract-call? .market-traceability record-transaction u1 'SP2J6ZY48GV1EZ5V2V5RB9MP66SW86PYKKNRV9EJ7 u500 u20 "Harbor Market" false)
\`\`\`

## Data Flow

1. **Vessel Registration**: Fishing vessels register with the system
2. **Catch Recording**: Vessels record their catches with location and species data
3. **Species Verification**: System validates catch against quotas and regulations
4. **Sustainability Scoring**: Vessels earn sustainability scores based on practices
5. **Market Transactions**: Fish sales are recorded with full traceability
6. **Consumer Verification**: End consumers can verify product authenticity

## Benefits

- **Transparency**: Complete visibility of fish supply chain
- **Sustainability**: Enforces fishing quotas and seasonal restrictions
- **Fraud Prevention**: Blockchain immutability prevents data tampering
- **Regulatory Compliance**: Automated compliance checking
- **Consumer Trust**: Verifiable product authenticity

## Testing

The system includes comprehensive tests using Vitest:

\`\`\`bash
npm test
\`\`\`

Tests cover:
- Contract deployment
- Vessel registration
- Catch documentation
- Species verification
- Market transactions
- Traceability chains

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For questions or support, please open an issue in the GitHub repository.
