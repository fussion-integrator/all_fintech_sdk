/// PayPal data service for headless operations.
library;

import 'dart:async';
import 'package:meta/meta.dart';
import '../../../core/logger.dart';
import '../paypal_client.dart';
import '../models/paypal_models.dart';

/// PayPal data service for API operations without UI.
class PayPalDataService {
  final PayPalClient _client;
  final PayPalConfig _config;

  PayPalDataService(this._config) : _client = PayPalClient(_config);

  /// Create a payment order.
  Future<PayPalPaymentResponse> createPayment(PayPalPaymentRequest request) async {
    try {
      SDKLogger.info('Creating PayPal payment for amount: ${request.amount.value}');
      
      _validatePaymentRequest(request);
      
      final response = await _client.createOrder(request);
      
      SDKLogger.info('PayPal payment created successfully: ${response.id}');
      return response;
    } catch (e) {
      SDKLogger.error('Failed to create PayPal payment', e);
      if (e is PayPalException) rethrow;
      throw PayPalException(
        'Payment creation failed: ${e.toString()}',
        code: 'PAYMENT_CREATION_FAILED',
      );
    }
  }

  /// Capture an approved payment.
  Future<PayPalCaptureResponse> capturePayment(String orderId) async {
    try {
      SDKLogger.info('Capturing PayPal payment: $orderId');
      
      final response = await _client.captureOrder(orderId);
      
      SDKLogger.info('PayPal payment captured successfully: ${response.id}');
      return response;
    } catch (e) {
      SDKLogger.error('Failed to capture PayPal payment', e);
      if (e is PayPalException) rethrow;
      throw PayPalException(
        'Payment capture failed: ${e.toString()}',
        code: 'PAYMENT_CAPTURE_FAILED',
      );
    }
  }

  /// Get payment details.
  Future<PayPalPaymentResponse> getPayment(String orderId) async {
    try {
      SDKLogger.info('Retrieving PayPal payment: $orderId');
      
      final response = await _client.getOrder(orderId);
      
      SDKLogger.info('PayPal payment retrieved successfully');
      return response;
    } catch (e) {
      SDKLogger.error('Failed to retrieve PayPal payment', e);
      if (e is PayPalException) rethrow;
      throw PayPalException(
        'Payment retrieval failed: ${e.toString()}',
        code: 'PAYMENT_RETRIEVAL_FAILED',
      );
    }
  }

  /// Create a simple payment request.
  PayPalPaymentRequest createPaymentRequest({
    required double amount,
    String? currencyCode,
    String? description,
    PayPalIntent intent = PayPalIntent.capture,
    List<PayPalItem>? items,
    PayPalAddress? shippingAddress,
  }) {
    final paypalAmount = PayPalAmount(
      currencyCode: currencyCode ?? _config.currencyCode,
      value: amount.toStringAsFixed(2),
      breakdown: items != null ? _calculateBreakdown(items, currencyCode ?? _config.currencyCode) : null,
    );

    return PayPalPaymentRequest(
      intent: intent,
      amount: paypalAmount,
      description: description,
      items: items,
      shippingAddress: shippingAddress,
    );
  }

  /// Create a PayPal item.
  PayPalItem createItem({
    required String name,
    required double unitPrice,
    int quantity = 1,
    String? currencyCode,
    String? description,
    String? sku,
    String? category,
  }) {
    return PayPalItem(
      name: name,
      quantity: quantity.toString(),
      unitAmount: PayPalMoney(
        currencyCode: currencyCode ?? _config.currencyCode,
        value: unitPrice.toStringAsFixed(2),
      ),
      description: description,
      sku: sku,
      category: category,
    );
  }

  /// Create a PayPal address.
  PayPalAddress createAddress({
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? postalCode,
    String? countryCode,
  }) {
    return PayPalAddress(
      addressLine1: addressLine1,
      addressLine2: addressLine2,
      city: city,
      state: state,
      postalCode: postalCode,
      countryCode: countryCode,
    );
  }

  /// Calculate amount breakdown from items.
  PayPalBreakdown _calculateBreakdown(List<PayPalItem> items, String currencyCode) {
    double itemTotal = 0.0;
    
    for (final item in items) {
      final unitPrice = double.parse(item.unitAmount.value);
      final quantity = int.parse(item.quantity);
      itemTotal += unitPrice * quantity;
    }

    return PayPalBreakdown(
      itemTotal: PayPalMoney(
        currencyCode: currencyCode,
        value: itemTotal.toStringAsFixed(2),
      ),
    );
  }

  /// Validate payment request.
  void _validatePaymentRequest(PayPalPaymentRequest request) {
    final amount = double.tryParse(request.amount.value);
    if (amount == null || amount <= 0) {
      throw PayPalException(
        'Payment amount must be greater than zero',
        code: 'INVALID_AMOUNT',
      );
    }

    if (request.amount.currencyCode.length != 3) {
      throw PayPalException(
        'Invalid currency code format',
        code: 'INVALID_CURRENCY',
      );
    }

    if (amount > 10000.00) {
      throw PayPalException(
        'Payment amount exceeds maximum limit',
        code: 'AMOUNT_TOO_LARGE',
      );
    }

    // Validate items if provided
    if (request.items != null) {
      for (final item in request.items!) {
        final unitPrice = double.tryParse(item.unitAmount.value);
        if (unitPrice == null || unitPrice < 0) {
          throw PayPalException(
            'Invalid item price: ${item.name}',
            code: 'INVALID_ITEM_PRICE',
          );
        }
        
        final quantity = int.tryParse(item.quantity);
        if (quantity == null || quantity <= 0) {
          throw PayPalException(
            'Invalid item quantity: ${item.name}',
            code: 'INVALID_ITEM_QUANTITY',
          );
        }
      }
    }
  }

  /// Get merchant configuration (without sensitive data).
  Map<String, dynamic> getMerchantInfo() {
    return {
      'environment': _config.environment.name,
      'currencyCode': _config.currencyCode,
      'returnUrl': _config.returnUrl,
      'cancelUrl': _config.cancelUrl,
    };
  }

  /// Get current configuration.
  PayPalConfig get config => _config;

  /// Dispose resources.
  @mustCallSuper
  void dispose() {
    _client.dispose();
  }
}