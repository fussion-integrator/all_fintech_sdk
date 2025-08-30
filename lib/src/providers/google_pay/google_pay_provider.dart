/// Google Pay provider implementation.
library;

import 'package:meta/meta.dart';
import '../../core/logger.dart';
import 'models/google_pay_models.dart';

import 'data/google_pay_data_service.dart';
import 'ui/google_pay_ui_service.dart';

/// Google Pay provider for Android payment integration.
class GooglePayProvider {
  final String _merchantId;
  final String _merchantName;
  final String _countryCode;
  final String _currencyCode;
  final GooglePayEnvironment _environment;
  late final GooglePayDataService _dataService;
  late final GooglePayUIService _uiService;

  /// Data service for headless operations.
  GooglePayDataService get data => _dataService;
  
  /// UI service for widget operations.
  GooglePayUIService get ui => _uiService;

  GooglePayProvider._({
    required String merchantId,
    required String merchantName,
    required String countryCode,
    required String currencyCode,
    required GooglePayEnvironment environment,
  })  : _merchantId = merchantId,
        _merchantName = merchantName,
        _countryCode = countryCode,
        _currencyCode = currencyCode,
        _environment = environment;

  /// Factory constructor for easy initialization.
  factory GooglePayProvider.initialize({
    required String merchantId,
    required String merchantName,
    required String countryCode,
    required String currencyCode,
    required GooglePayEnvironment environment,
  }) {
    SDKLogger.info('Google Pay provider initialized for environment: ${environment.name}');
    
    final provider = GooglePayProvider._(
      merchantId: merchantId,
      merchantName: merchantName,
      countryCode: countryCode,
      currencyCode: currencyCode,
      environment: environment,
    );
    
    provider._dataService = GooglePayDataService();
    provider._uiService = GooglePayUIService();
    
    return provider;
  }

  /// Get merchant ID.
  String get merchantId => _merchantId;

  /// Get environment.
  GooglePayEnvironment get environment => _environment;

  /// Dispose resources.
  @mustCallSuper
  void dispose() {
    SDKLogger.debug('Google Pay provider disposed');
  }
}