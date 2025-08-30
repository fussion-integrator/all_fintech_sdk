/// Google Pay data service for headless operations.
library;

import '../../../core/logger.dart';
import '../models/google_pay_models.dart';

/// Google Pay data service for API operations without UI.
class GooglePayDataService {
  /// Check Google Pay availability.
  Future<GooglePayAvailability> checkAvailability() async {
    SDKLogger.info('Checking Google Pay availability');
    
    return const GooglePayAvailability(
      isAvailable: true,
      supportedNetworks: [],
    );
  }

  /// Request payment token.
  Future<GooglePayToken> requestPaymentToken(GooglePayRequest request) async {
    SDKLogger.info('Requesting Google Pay token for amount: ${request.amount}');
    
    return const GooglePayToken(
      token: 'demo_token',
      tokenType: 'PAYMENT_GATEWAY',
    );
  }

  /// Get merchant info.
  Map<String, dynamic> getMerchantInfo() {
    return {
      'merchantId': 'demo_merchant',
      'environment': 'test',
    };
  }
}