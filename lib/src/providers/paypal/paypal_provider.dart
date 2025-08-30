/// PayPal provider implementation.
library;

import 'package:meta/meta.dart';
import '../../core/logger.dart';
import 'data/paypal_data_service.dart';
import 'models/paypal_models.dart';

/// PayPal provider following the SDK's dual architecture pattern.
/// 
/// Provides both data-only operations and UI-enabled components for
/// PayPal integration.
class PayPalProvider {
  final PayPalConfig _config;
  late final PayPalDataService _dataService;

  /// Data service for headless PayPal operations.
  PayPalDataService get data => _dataService;

  /// Create PayPal provider with configuration.
  PayPalProvider(this._config) {
    _dataService = PayPalDataService(_config);
    
    SDKLogger.info('PayPal provider initialized for environment: ${_config.environment.name}');
  }

  /// Factory constructor for easy initialization.
  factory PayPalProvider.initialize({
    required String clientId,
    required String clientSecret,
    PayPalEnvironment environment = PayPalEnvironment.sandbox,
    String currencyCode = 'USD',
    String? returnUrl,
    String? cancelUrl,
  }) {
    final config = PayPalConfig(
      clientId: clientId,
      clientSecret: clientSecret,
      environment: environment,
      currencyCode: currencyCode,
      returnUrl: returnUrl,
      cancelUrl: cancelUrl,
    );
    
    return PayPalProvider(config);
  }

  /// Get current configuration.
  PayPalConfig get config => _config;

  /// Check if PayPal is properly configured.
  bool get isConfigured {
    return _config.clientId.isNotEmpty &&
        _config.clientSecret.isNotEmpty &&
        _config.currencyCode.length == 3;
  }

  /// Get environment information.
  Map<String, dynamic> get environmentInfo => {
    'environment': _config.environment.name,
    'currencyCode': _config.currencyCode,
    'returnUrl': _config.returnUrl,
    'cancelUrl': _config.cancelUrl,
    'isConfigured': isConfigured,
  };

  /// Dispose resources.
  @mustCallSuper
  void dispose() {
    _dataService.dispose();
    SDKLogger.debug('PayPal provider disposed');
  }
}