# All Fintech Flutter SDK 🚀

[![pub package](https://img.shields.io/pub/v/all_fintech_flutter_sdk.svg)](https://pub.dev/packages/all_fintech_flutter_sdk)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev)

**The most comprehensive Flutter SDK for Nigerian fintech APIs** - Integrate payments, banking, and financial services with a single, unified interface.

## 🌟 Why Choose All Fintech SDK?

- **🎯 One SDK, Multiple Providers** - Paystack, Flutterwave, Monnify, Opay, Open Banking
- **🔒 Enterprise Security** - OAuth 2.0, signature verification, webhook handling
- **🎨 Beautiful UI Components** - Material Design 3 payment sheets and forms
- **⚡ Production Ready** - Offline support, error handling, circuit breaker patterns
- **📱 Type Safe** - Complete Dart models with null safety
- **🔄 Dual Architecture** - Data-only operations OR UI-enabled components

## 🚀 Quick Start

### Installation

```yaml
dependencies:
  all_fintech_flutter_sdk: ^1.0.0
```

### Basic Setup

```dart
import 'package:all_fintech_flutter_sdk/all_fintech_flutter_sdk.dart';

// Initialize SDK
final sdk = AllFintechSDK.initialize(
  provider: FintechProvider.paystack,
  apiKey: 'your-api-key',
  publicKey: 'your-public-key', // Optional for some providers
  isLive: false, // Set to true for production
);
```

## 💳 Payment Examples

### Paystack Integration

```dart
// Data-only payment
final transaction = await sdk.paystack.data.initializeTransaction(
  TransactionRequest(
    email: 'customer@example.com',
    amount: 50000, // Amount in kobo (₦500.00)
    reference: 'unique-reference-${DateTime.now().millisecondsSinceEpoch}',
  ),
);

// UI-enabled payment sheet
await sdk.paystack.ui.showPaymentSheet(
  context: context,
  email: 'customer@example.com',
  amount: 50000,
  onSuccess: (transaction) {
    print('Payment successful: ${transaction.reference}');
  },
  onError: (error) {
    print('Payment failed: $error');
  },
);
```

### Flutterwave Integration

```dart
// Create customer
final customer = await sdk.flutterwave.data.createCustomer(
  FlutterwaveCustomerRequest(
    email: 'customer@example.com',
    name: 'John Doe',
    phoneNumber: '+2348123456789',
  ),
);

// Process payment
await sdk.flutterwave.ui.showPaymentSheet(
  context: context,
  amount: 25000,
  currency: 'NGN',
  customerEmail: 'customer@example.com',
  onSuccess: (charge) {
    print('Flutterwave payment successful: ${charge.id}');
  },
);
```

### Monnify Integration

```dart
// Initialize Monnify (uses OAuth 2.0)
final monnifySDK = AllFintechSDK.initialize(
  provider: FintechProvider.monnify,
  apiKey: 'your-api-key',
  publicKey: 'your-secret-key',
  isLive: false,
);

// Create reserved account
final account = await monnifySDK.monnify.data.createReservedAccount(
  MonnifyReservedAccountRequest(
    accountReference: 'unique-ref-123',
    accountName: 'John Doe',
    currencyCode: 'NGN',
    contractCode: 'your-contract-code',
    customerEmail: 'john@example.com',
  ),
);

// Show payment sheet
await monnifySDK.monnify.ui.showPaymentSheet(
  context: context,
  amount: 100000,
  customerName: 'John Doe',
  customerEmail: 'john@example.com',
  paymentReference: 'pay-ref-${DateTime.now().millisecondsSinceEpoch}',
  onSuccess: (transaction) {
    print('Monnify payment completed: ${transaction.transactionReference}');
  },
);
```

## 🏦 Open Banking Integration

```dart
// Initialize Open Banking
final openBankingSDK = AllFintechSDK.initialize(
  provider: FintechProvider.openBanking,
  apiKey: 'your-client-id',
  publicKey: 'your-client-secret',
  baseUrl: 'https://api.openbanking.ng',
);

// Get customer accounts
final accounts = await openBankingSDK.openBanking.data.getAccounts(
  consentToken: 'customer-consent-token',
);

// Show account selector UI
await openBankingSDK.openBanking.ui.showAccountSelector(
  context: context,
  consentToken: 'customer-consent-token',
  onAccountSelected: (account) {
    print('Selected account: ${account.accountNumber}');
  },
  onError: (error) {
    print('Error: $error');
  },
);

// Get transaction history
final transactions = await openBankingSDK.openBanking.data.getAccountTransactions(
  '0123456789',
  from: '2024-01-01',
  to: '2024-12-31',
  consentToken: 'customer-consent-token',
);
```

## 🎨 UI Components

### Payment Sheets

All providers include beautiful, customizable payment sheets:

```dart
// Paystack payment sheet
await sdk.paystack.ui.showPaymentSheet(
  context: context,
  email: 'customer@example.com',
  amount: 50000,
  metadata: {'order_id': '12345'},
  onSuccess: (transaction) => handleSuccess(transaction),
  onError: (error) => handleError(error),
);

// Opay payment sheet with channel selection
await sdk.opay.ui.showPaymentSheet(
  context: context,
  amount: 75000,
  orderNr: 'ORDER-${DateTime.now().millisecondsSinceEpoch}',
  redirectUrl: 'https://yourapp.com/success',
  webServiceUrl: 'https://yourapp.com/webhook',
  standard: 'opay_8.1',
  onSuccess: (transaction) => print('Opay success: ${transaction.transactionId}'),
);
```

### Management Dialogs

```dart
// Show transaction status
await sdk.paystack.ui.showTransactionStatusDialog(
  context: context,
  transaction: transaction,
);

// Show customer management
await sdk.flutterwave.ui.showCustomerForm(
  context: context,
  onCustomerCreated: (customer) => print('Customer created: ${customer.id}'),
);
```

## 🔧 Advanced Features

### Webhook Handling

```dart
// Verify webhook signatures
final isValid = await sdk.webhooks.processWebhook(
  payload: request.body,
  signature: request.headers['x-paystack-signature'],
);

if (isValid) {
  // Process webhook data
  print('Webhook verified and processed');
}
```

### Offline Support

```dart
// Initialize offline manager
await sdk.initialize();

// Sync offline requests when connection is restored
await sdk.syncOfflineRequests();
```

### Error Handling with Circuit Breaker

```dart
try {
  final transaction = await sdk.paystack.data.initializeTransaction(request);
} on FintechException catch (e) {
  if (e is CircuitBreakerOpenException) {
    // Handle circuit breaker open state
    print('Service temporarily unavailable');
  } else {
    // Handle other fintech errors
    print('Payment error: ${e.message}');
  }
}
```

## 🏗️ Architecture

### Dual Service Pattern

Every provider follows a consistent dual architecture:

```dart
// Data-only operations (headless)
final result = await sdk.provider.data.someOperation();

// UI-enabled operations (with widgets)
await sdk.provider.ui.showSomeSheet(context: context);
```

### Provider Switching

```dart
// Easy provider switching
FintechProvider currentProvider = FintechProvider.paystack;

switch (currentProvider) {
  case FintechProvider.paystack:
    await sdk.paystack.ui.showPaymentSheet(/* ... */);
    break;
  case FintechProvider.flutterwave:
    await sdk.flutterwave.ui.showPaymentSheet(/* ... */);
    break;
  case FintechProvider.monnify:
    await sdk.monnify.ui.showPaymentSheet(/* ... */);
    break;
}
```

## 📋 Supported Providers

| Provider | Payments | Transfers | Customers | Subscriptions | Open Banking |
|----------|----------|-----------|-----------|---------------|--------------|
| **Paystack** | ✅ | ✅ | ✅ | ✅ | ❌ |
| **Flutterwave** | ✅ | ✅ | ✅ | ✅ | ❌ |
| **Monnify** | ✅ | ✅ | ❌ | ❌ | ❌ |
| **Opay** | ✅ | ❌ | ❌ | ❌ | ❌ |
| **Open Banking** | ❌ | ❌ | ❌ | ❌ | ✅ |

## 🔒 Security Features

- **Signature Verification** - All API requests are signed and verified
- **OAuth 2.0** - Secure authentication for Open Banking and Monnify
- **Webhook Security** - Automatic signature validation for webhooks
- **Token Management** - Automatic token refresh and secure storage
- **Encryption** - AES-256-CBC encryption for sensitive data

## 🧪 Testing

```dart
// Mock responses for testing
final mockSDK = AllFintechSDK.initialize(
  provider: FintechProvider.paystack,
  apiKey: 'test-key',
  isLive: false, // Always use test mode for development
);

// Test payment flow
await mockSDK.paystack.data.initializeTransaction(
  TransactionRequest(
    email: 'test@example.com',
    amount: 100000,
    reference: 'test-ref-123',
  ),
);
```

## 📚 Documentation

- [API Reference](https://pub.dev/documentation/all_fintech_flutter_sdk/latest/)
- [Provider-Specific Guides](https://github.com/chidiebere-edeh/all_fintech_sdk/wiki)
- [Migration Guide](https://github.com/chidiebere-edeh/all_fintech_sdk/blob/main/MIGRATION.md)
- [Contributing](https://github.com/chidiebere-edeh/all_fintech_sdk/blob/main/CONTRIBUTING.md)

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Chidiebere Edeh**
- GitHub: [@chidiebere-edeh](https://github.com/chidiebere-edeh)
- Email: chidiebere.edeh@example.com
- LinkedIn: [Chidiebere Edeh](https://linkedin.com/in/chidiebere-edeh)

## 🙏 Acknowledgments

- Nigerian fintech ecosystem for driving innovation
- Flutter community for excellent tooling and support
- All contributors who helped make this SDK possible

## ⭐ Show Your Support

If this SDK helped you build amazing fintech applications, please give it a ⭐ on [GitHub](https://github.com/chidiebere-edeh/all_fintech_sdk)!

---

**Built with ❤️ for the Nigerian fintech ecosystem by Chidiebere Edeh**