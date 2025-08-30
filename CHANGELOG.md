# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.0] - 2024-01-15

### Added
- **Google Pay Integration** - Complete Android payment processing
  - Payment token requests with device validation
  - Material Design 3 payment buttons and sheets
  - Multi-theme support (dark/light)
  - Comprehensive error handling
- **Apple Pay Integration** - Native iOS payment processing
  - PassKit integration with biometric authentication
  - Multiple button styles following Apple HIG
  - Contact information collection
  - Platform-specific validation
- **PayPal Integration** - Global payment processing
  - OAuth 2.0 authentication with automatic token refresh
  - Multi-currency support (100+ currencies)
  - Itemized billing with breakdown calculations
  - Subscription payment support
- **Opay Demo Screen** - Complete payment channel demonstrations
- **World-class Main Demo Screen** - Professional navigation interface
  - Categorized provider sections
  - Feature highlights and statistics
  - Material Design 3 theming
  - Responsive grid layout

### Enhanced
- **Dual Architecture Pattern** - Consistent data + UI services across all providers
- **Error Handling** - Comprehensive exception types with detailed error codes
- **Logging System** - Professional request/response logging
- **Type Safety** - Complete null safety implementation
- **Documentation** - Extensive API documentation and usage examples

### Fixed
- Provider initialization edge cases
- Memory leaks in HTTP clients
- Widget disposal in demo screens

## [1.1.0] - 2023-12-01

### Added
- **Monnify Provider** - Reserved accounts and bulk transfers
  - OAuth 2.0 authentication
  - Reserved account creation and management
  - Single and bulk transfer operations
  - Transaction splitting capabilities
- **TransactPay Provider** - Encrypted payment processing
  - AES-256-CBC encryption for sensitive data
  - Order creation and management
  - Bank transfer payment options
  - Real-time status checking
- **Open Banking Provider** - Account aggregation services
  - Customer consent management
  - Account information retrieval
  - Transaction history access
  - Balance checking

### Enhanced
- **Security Framework** - Enterprise-grade security features
  - Signature verification for all API requests
  - Automatic token refresh mechanisms
  - Secure credential storage
- **UI Components** - Material Design 3 compliance
  - Payment sheets with animations
  - Loading states and error handling
  - Responsive design patterns

## [1.0.0] - 2023-10-15

### Added
- **Initial Release** - Core SDK architecture
- **Paystack Provider** - Complete payment processing
  - Transaction initialization and verification
  - Transfer recipient management
  - Customer creation and management
  - Subscription handling
  - Webhook signature verification
- **Flutterwave Provider** - Multi-channel payments
  - Charge creation and processing
  - Virtual account management
  - Bank transfer operations
  - Customer management
- **Opay Provider** - Payment channel integration
  - Multiple payment methods (Card, Transfer, USSD)
  - Recurring payment setup
  - Real-time payment status
- **Core Architecture**
  - Dual service pattern (Data + UI)
  - Comprehensive error handling
  - Professional logging system
  - Type-safe models with JSON serialization
- **Example Application** - Comprehensive demo app
  - Provider-specific demo screens
  - Interactive payment flows
  - Error handling demonstrations

### Technical
- **Flutter 3.0+** compatibility
- **Null safety** implementation
- **Material Design 3** UI components
- **Enterprise security** features
- **Offline support** with request queuing
- **Circuit breaker** patterns for resilience

## [0.1.0] - 2023-09-01

### Added
- Initial project setup
- Basic SDK architecture
- Paystack integration prototype
- Example application foundation

---

## Migration Guides

### Migrating to 1.2.0
- No breaking changes
- New providers are additive
- Existing code continues to work

### Migrating to 1.1.0
- Update import statements for new providers
- Review security configuration for enhanced features
- Update example app dependencies

### Migrating to 1.0.0
- Initial stable release
- Follow setup instructions in README.md
- Configure provider credentials

---

## Support

For questions, issues, or contributions:
- [GitHub Issues](https://github.com/chidiebere-edeh/all_fintech_sdk/issues)
- [Documentation](https://pub.dev/documentation/all_fintech_flutter_sdk/latest/)
- [Example App](https://github.com/chidiebere-edeh/all_fintech_sdk/tree/main/example)