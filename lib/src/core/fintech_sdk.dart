import 'fintech_config.dart';
import 'fintech_provider.dart';
import 'webhook_manager.dart';
import 'offline_manager.dart';
import 'enhanced_exceptions.dart';
import '../providers/paystack/paystack_provider.dart';
import '../providers/flutterwave/flutterwave_provider.dart';
import '../providers/monnify/monnify_provider.dart';
import '../providers/opay/opay_provider.dart';
import '../providers/open_banking/open_banking_provider.dart';

/// The main SDK class providing access to all Nigerian fintech providers.
/// 
/// Supports Paystack, Flutterwave, Monnify, Opay, and Open Banking with
/// both data-only and UI-enabled operations.
class AllFintechSDK {
  final FintechConfig _config;
  PaystackProvider? _paystack;
  FlutterwaveProvider? _flutterwave;
  MonnifyProvider? _monnify;
  OpayProvider? _opay;
  OpenBankingProvider? _openBanking;
  WebhookManager? _webhookManager;
  OfflineManager? _offlineManager;
  CircuitBreaker? _circuitBreaker;

  AllFintechSDK(this._config);

  /// Factory constructor for easy initialization
  factory AllFintechSDK.initialize({
    required FintechProvider provider,
    required String apiKey,
    String? publicKey,
    bool isLive = false,
    String? baseUrl,
  }) {
    final config = FintechConfig(
      provider: provider,
      apiKey: apiKey,
      publicKey: publicKey,
      isLive: isLive,
      baseUrl: baseUrl,
    );
    return AllFintechSDK(config);
  }

  /// Get Paystack provider instance
  PaystackProvider get paystack {
    _paystack ??= PaystackProvider(_config);
    return _paystack!;
  }

  /// Get Flutterwave provider instance
  FlutterwaveProvider get flutterwave {
    _flutterwave ??= FlutterwaveProvider(_config);
    return _flutterwave!;
  }

  /// Get Monnify provider instance
  MonnifyProvider get monnify {
    _monnify ??= MonnifyProvider(_config);
    return _monnify!;
  }

  /// Get Opay provider instance
  OpayProvider get opay {
    _opay ??= OpayProvider(
      websiteId: _config.apiKey,
      password: _config.publicKey ?? '',
      isTestMode: !_config.isLive,
    );
    return _opay!;
  }

  /// Get Open Banking provider instance
  OpenBankingProvider get openBanking {
    _openBanking ??= OpenBankingProvider(
      clientId: _config.apiKey,
      clientSecret: _config.publicKey ?? '',
      baseUrl: _config.baseUrl ?? 'https://api.openbanking.ng',
    );
    return _openBanking!;
  }

  /// Get current configuration
  FintechConfig get config => _config;

  /// Check if provider is supported
  bool isProviderSupported(FintechProvider provider) {
    switch (provider) {
      case FintechProvider.paystack:
      case FintechProvider.flutterwave:
      case FintechProvider.monnify:
      case FintechProvider.opay:
      case FintechProvider.openBanking:
        return true;
      default:
        return false;
    }
  }

  /// Get webhook manager instance
  WebhookManager get webhooks {
    _webhookManager ??= WebhookManager(_config.apiKey);
    return _webhookManager!;
  }

  /// Get offline manager instance
  OfflineManager get offline {
    _offlineManager ??= OfflineManager();
    return _offlineManager!;
  }

  /// Get circuit breaker instance
  CircuitBreaker get circuitBreaker {
    _circuitBreaker ??= CircuitBreaker();
    return _circuitBreaker!;
  }

  /// Initialize offline manager
  Future<void> initialize() async {
    await offline.initialize();
  }

  /// Sync offline requests
  Future<void> syncOfflineRequests() async {
    await offline.processQueue();
  }

  /// Process webhook
  Future<bool> processWebhook(String payload, String signature) async {
    return await webhooks.processWebhook(payload, signature);
  }
}