/// Google Pay UI service for widget operations.
library;

import 'package:flutter/material.dart';
import '../../../core/logger.dart';
import '../models/google_pay_models.dart';

/// Google Pay UI service for widget operations.
class GooglePayUIService {
  /// Show Google Pay button.
  Widget showGooglePayButton({
    required GooglePayRequest paymentRequest,
    required GooglePayButtonConfig buttonConfig,
    required Function(GooglePayToken) onPaymentSuccess,
    required Function(GooglePayException) onPaymentError,
  }) {
    return ElevatedButton(
      onPressed: () => _handlePayment(paymentRequest, onPaymentSuccess, onPaymentError),
      child: Text(buttonConfig.type.name),
    );
  }

  /// Create simple button.
  Widget createSimpleButton({
    required double amount,
    required Function(GooglePayToken) onSuccess,
    required Function(GooglePayException) onError,
    GooglePayButtonType type = GooglePayButtonType.pay,
    double? width,
  }) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: () => _handlePayment(
          GooglePayRequest(amount: amount, currencyCode: 'USD', label: 'Payment'),
          onSuccess,
          onError,
        ),
        child: Text(type.name),
      ),
    );
  }

  void _handlePayment(
    GooglePayRequest request,
    Function(GooglePayToken) onSuccess,
    Function(GooglePayException) onError,
  ) {
    SDKLogger.info('Processing Google Pay payment');
    onSuccess(const GooglePayToken(token: 'demo_token', tokenType: 'PAYMENT_GATEWAY'));
  }
}