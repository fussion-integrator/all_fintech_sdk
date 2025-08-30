/// Apple Pay provider implementation.
library;

import 'package:meta/meta.dart';
import '../../core/logger.dart';
import 'models/apple_pay_models.dart';

import 'data/apple_pay_data_service.dart';
import 'ui/apple_pay_ui_service.dart';

/// Apple Pay provider for iOS payment integration.
class ApplePayProvider {
  final String _merchantId;
  final String _merchantName;
  final String _countryCode;
  final String _currencyCode;
  final ApplePayEnvironment _environment;
  late final ApplePayDataService _dataService;
  late final ApplePayUIService _uiService;

  /// Data service for headless operations.
  ApplePayDataService get data => _dataService;
  
  /// UI service for widget operations.
  ApplePayUIService get ui => _uiService;

  ApplePayProvider._({
    required String merchantId,
    required String merchantName,
    required String countryCode,
    required String currencyCode,
    required ApplePayEnvironment environment,
  })  : _merchantId = merchantId,
        _merchantName = merchantName,
        _countryCode = countryCode,
        _currencyCode = currencyCode,
        _environment = environment;

  /// Factory constructor for easy initialization.
  factory ApplePayProvider.initialize({
    required String merchantId,
    required String merchantName,
    required String countryCode,
    required String currencyCode,
    required ApplePayEnvironment environment,
  }) {
    SDKLogger.info('Apple Pay provider initialized for environment: ${environment.name}');
    
    final provider = ApplePayProvider._(
      merchantId: merchantId,
      merchantName: merchantName,
      countryCode: countryCode,
      currencyCode: currencyCode,
      environment: environment,
    );
    
    provider._dataService = ApplePayDataService();
    provider._uiService = ApplePayUIService();
    
    return provider;
  }

  /// Get merchant ID.
  String get merchantId => _merchantId;

  /// Get environment.
  ApplePayEnvironment get environment => _environment;

  /// Dispose resources.
  @mustCallSuper
  void dispose() {
    SDKLogger.debug('Apple Pay provider disposed');
  }
}