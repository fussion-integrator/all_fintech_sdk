/// The most comprehensive Flutter SDK for Nigerian fintech APIs.
/// 
/// Integrate payments, banking, and financial services with a single, unified interface.
/// Supports Paystack, Flutterwave, Monnify, Opay, Google Pay, Apple Pay, PayPal, and more.
/// 
/// ## Features
/// 
/// - **🎯 One SDK, Multiple Providers** - Paystack, Flutterwave, Monnify, Opay, Open Banking
/// - **🔒 Enterprise Security** - OAuth 2.0, signature verification, webhook handling
/// - **🎨 Beautiful UI Components** - Material Design 3 payment sheets and forms
/// - **⚡ Production Ready** - Offline support, error handling, circuit breaker patterns
/// - **📱 Type Safe** - Complete Dart models with null safety
/// - **🔄 Dual Architecture** - Data-only operations OR UI-enabled components
/// 
/// ## Quick Start
/// 
/// ```dart
/// import 'package:all_fintech_flutter_sdk/all_fintech_flutter_sdk.dart';
/// 
/// // Initialize SDK
/// final sdk = AllFintechSDK.initialize(
///   provider: FintechProvider.paystack,
///   apiKey: 'your-api-key',
///   isLive: false,
/// );
/// 
/// // Use data service (headless)
/// final transaction = await sdk.paystack.data.initializeTransaction(
///   TransactionRequest(
///     email: 'customer@example.com',
///     amount: 50000, // Amount in kobo (₦500.00)
///   ),
/// );
/// 
/// // Use UI service (with widgets)
/// await sdk.paystack.ui.showPaymentSheet(
///   context: context,
///   email: 'customer@example.com',
///   amount: 50000,
///   onSuccess: (transaction) => print('Success: ${transaction.reference}'),
/// );
/// ```
/// 
/// ## Supported Providers
/// 
/// ### Nigerian Providers
/// - **Paystack** - Payments, transfers, subscriptions, customers
/// - **Flutterwave** - Charges, virtual accounts, transfers, customers
/// - **Monnify** - Reserved accounts, bulk transfers, webhooks
/// - **Opay** - Payment channels, recurring payments, USSD
/// - **TransactPay** - Encrypted payments, bank transfers
/// - **Open Banking** - Account aggregation, transaction history
/// 
/// ### International Providers
/// - **Google Pay** - Android payment integration with tokenization
/// - **Apple Pay** - iOS payment integration with PassKit
/// - **PayPal** - Global payment processing with multi-currency support
/// 
/// ## Architecture
/// 
/// Every provider follows a consistent dual architecture:
/// 
/// ```dart
/// // Data-only operations (headless)
/// final result = await sdk.provider.data.someOperation();
/// 
/// // UI-enabled operations (with widgets)
/// await sdk.provider.ui.showSomeSheet(context: context);
/// ```
/// 
/// ## Security
/// 
/// - **Signature Verification** - All API requests are signed and verified
/// - **OAuth 2.0** - Secure authentication for Open Banking and Monnify
/// - **Webhook Security** - Automatic signature validation for webhooks
/// - **Token Management** - Automatic token refresh and secure storage
/// - **Encryption** - AES-256-CBC encryption for sensitive data
/// 
/// ## Error Handling
/// 
/// ```dart
/// try {
///   final result = await sdk.paystack.data.initializeTransaction(request);
/// } on FintechException catch (e) {
///   if (e is CircuitBreakerOpenException) {
///     // Handle circuit breaker open state
///     print('Service temporarily unavailable');
///   } else {
///     // Handle other fintech errors
///     print('Payment error: ${e.message}');
///   }
/// }
/// ```
/// 
/// ## Examples
/// 
/// See the [example app](https://github.com/chidiebere-edeh/all_fintech_sdk/tree/main/example) 
/// for comprehensive demonstrations of all providers and features.
library all_fintech_flutter_sdk;

// Core SDK
export 'src/core/fintech_sdk.dart';
export 'src/core/fintech_provider.dart';
export 'src/core/fintech_config.dart';
export 'src/core/fintech_exception.dart';
export 'src/core/logger.dart';
export 'src/core/constants.dart';

// Providers
export 'src/providers/paystack/paystack_provider.dart';
export 'src/providers/flutterwave/flutterwave_provider.dart';
export 'src/providers/monnify/monnify_provider.dart';
export 'src/providers/opay/opay_provider.dart';
export 'src/providers/open_banking/open_banking_provider.dart';
export 'src/providers/transactpay/transactpay_provider.dart';
export 'src/providers/google_pay/google_pay_provider.dart';
export 'src/providers/apple_pay/apple_pay_provider.dart';
export 'src/providers/paypal/paypal_provider.dart';

// Provider Models
export 'src/providers/opay/models/opay_models.dart';
export 'src/providers/open_banking/models/open_banking_models.dart';
export 'src/providers/transactpay/models/transactpay_models.dart';
export 'src/providers/google_pay/models/google_pay_models.dart';
export 'src/providers/apple_pay/models/apple_pay_models.dart';
export 'src/providers/paypal/models/paypal_models.dart';

// Utilities
export 'src/utils/validators.dart';
export 'src/utils/formatters.dart';
export 'src/utils/extensions.dart';