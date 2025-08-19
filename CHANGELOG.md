# Changelog

All notable changes to this project will be documented in this file.

## [1.0.0] - 2024-12-19

### Added
- **Initial Release** - Complete Flutter SDK for Nigerian fintech APIs
- **Paystack Integration** - Full API coverage with payments, transfers, customers, subscriptions
- **Flutterwave Integration** - Complete API support with charges, customers, transfers, virtual accounts
- **Monnify Integration** - OAuth 2.0 authentication with transactions, reserved accounts, transfers
- **Opay Integration** - Payment channels, transactions, recurring payments, refunds
- **Open Banking Integration** - Nigerian Open Banking API standard compliance with savings and accounts
- **Dual Architecture** - Data-only and UI-enabled operations for all providers
- **Security Features** - Signature verification, OAuth 2.0, webhook handling, encryption
- **UI Components** - Material Design 3 payment sheets, forms, dialogs, and management screens
- **Enterprise Features** - Offline support, circuit breaker patterns, enhanced error handling
- **Type Safety** - Complete Dart models with null safety support
- **Production Ready** - Comprehensive error handling and retry mechanisms

### Security
- MD5/SHA-256 signature generation for API security
- OAuth 2.0 implementation for Monnify and Open Banking
- AES-256-CBC encryption for sensitive data
- Webhook signature verification
- Automatic token refresh and management

### Documentation
- Comprehensive README with examples for all providers
- API documentation with detailed usage patterns
- Code examples for both data-only and UI operations
- Migration guides and best practices

### Supported Providers
- Paystack (Payments, Transfers, Customers, Subscriptions, Products)
- Flutterwave (Charges, Customers, Transfers, Virtual Accounts, Orders)
- Monnify (Transactions, Reserved Accounts, Transfers, Banking)
- Opay (Payments, Channels, Recurring, Refunds)
- Open Banking Nigeria (Savings, Accounts, Transactions)

### Technical Features
- Flutter 3.0+ compatibility
- Null safety support
- Material Design 3 UI components
- Offline request queuing
- Circuit breaker pattern implementation
- Enhanced exception handling
- Webhook management system
- Idempotency support
- Pagination handling
- Custom properties support