/// The most comprehensive Flutter SDK for Nigerian fintech APIs.
/// 
/// Integrate Paystack, Flutterwave, Monnify, Opay, and Open Banking
/// with beautiful UI components and enterprise security.
/// 
/// ## Quick Start
/// 
/// ```dart
/// final sdk = AllFintechSDK.initialize(
///   provider: FintechProvider.paystack,
///   apiKey: 'your-api-key',
///   isLive: false,
/// );
/// 
/// // Data-only operation
/// final transaction = await sdk.paystack.data.initializeTransaction(request);
/// 
/// // UI-enabled operation
/// await sdk.paystack.ui.showPaymentSheet(context: context, ...);
/// ```
library all_fintech_flutter_sdk;

export 'src/core/fintech_sdk.dart';
export 'src/core/fintech_config.dart';
export 'src/core/fintech_provider.dart';
export 'src/core/exceptions.dart';
export 'src/core/api_response.dart';
export 'src/core/webhook_manager.dart';
export 'src/core/offline_manager.dart';
export 'src/core/enhanced_exceptions.dart';
export 'src/models/models.dart';
export 'src/services/services.dart';
export 'src/providers/paystack/paystack_provider.dart';
export 'src/providers/flutterwave/flutterwave_provider.dart';
export 'src/providers/monnify/monnify_provider.dart';
export 'src/providers/opay/opay_provider.dart';
export 'src/providers/opay/models/opay_models.dart';
export 'src/providers/open_banking/open_banking_provider.dart';
export 'src/providers/open_banking/models/open_banking_models.dart';