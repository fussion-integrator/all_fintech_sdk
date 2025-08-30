/// TransactPay provider implementation.
library;

import 'package:meta/meta.dart';
import '../../core/logger.dart';
import 'data/transactpay_data_service.dart';
import 'models/transactpay_models.dart';

/// TransactPay provider following the SDK's dual architecture pattern.
/// 
/// Provides both data-only operations for encrypted payment processing
/// with European BIN sponsorship and modular payment services.
class TransactPayProvider {
  final TransactPayConfig _config;
  late final TransactPayDataService _dataService;

  /// Data service for headless TransactPay operations.
  TransactPayDataService get data => _dataService;

  /// Create TransactPay provider with configuration.
  TransactPayProvider(this._config) {
    _dataService = TransactPayDataService(_config);
    
    SDKLogger.info('TransactPay provider initialized for mode: ${_config.isTestMode ? 'test' : 'live'}');
  }

  /// Factory constructor for easy initialization.
  factory TransactPayProvider.initialize({
    required String apiKey,
    required String secretKey,
    required String encryptionKey,
    bool isTestMode = true,
    String? baseUrl,
  }) {
    final config = TransactPayConfig(
      apiKey: apiKey,
      secretKey: secretKey,
      encryptionKey: encryptionKey,
      isTestMode: isTestMode,
      baseUrl: baseUrl,
    );
    
    return TransactPayProvider(config);
  }

  /// Get current configuration.
  TransactPayConfig get config => _config;

  /// Check if TransactPay is properly configured.
  bool get isConfigured {
    return _config.apiKey.isNotEmpty &&
        _config.secretKey.isNotEmpty &&
        _config.encryptionKey.isNotEmpty;
  }

  /// Get environment information.
  Map<String, dynamic> get environmentInfo => {
    'isTestMode': _config.isTestMode,
    'baseUrl': _config.baseUrl,
    'isConfigured': isConfigured,
    'hasApiKey': _config.apiKey.isNotEmpty,
    'hasSecretKey': _config.secretKey.isNotEmpty,
    'hasEncryptionKey': _config.encryptionKey.isNotEmpty,
  };

  /// Dispose resources.
  @mustCallSuper
  void dispose() {
    _dataService.dispose();
    SDKLogger.debug('TransactPay provider disposed');
  }
}