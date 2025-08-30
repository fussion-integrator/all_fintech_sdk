/// Apple Pay UI service for widget operations.
library;

import 'package:flutter/material.dart';
import '../../../core/logger.dart';
import '../models/apple_pay_models.dart';

/// Apple Pay UI service for widget operations.
class ApplePayUIService {
  /// Show Apple Pay button.
  Widget showApplePayButton({
    required ApplePayRequest paymentRequest,
    required ApplePayButtonConfig buttonConfig,
    required Function(ApplePayToken) onPaymentSuccess,
    required Function(ApplePayException) onPaymentError,
  }) {
    return ElevatedButton(
      onPressed: () => _handlePayment(paymentRequest, onPaymentSuccess, onPaymentError),
      child: const Text('Apple Pay'),
    );
  }

  /// Create simple button.
  Widget createSimpleButton({
    required double amount,
    required Function(ApplePayToken) onSuccess,
    required Function(ApplePayException) onError,
    double? width,
  }) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: () => _handlePayment(
          ApplePayRequest(amount: amount, currencyCode: 'USD', label: 'Payment'),
          onSuccess,
          onError,
        ),
        child: const Text('Apple Pay'),
      ),
    );
  }

  void _handlePayment(
    ApplePayRequest request,
    Function(ApplePayToken) onSuccess,
    Function(ApplePayException) onError,
  ) {
    SDKLogger.info('Processing Apple Pay payment');
    onSuccess(const ApplePayToken(
      transactionIdentifier: 'demo_transaction',
      paymentData: 'demo_payment_data',
    ));
  }
}