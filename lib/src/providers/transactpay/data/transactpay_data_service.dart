/// TransactPay data service for headless operations.
library;

import 'dart:async';
import 'package:meta/meta.dart';
import '../../../core/logger.dart';
import '../transactpay_client.dart';
import '../models/transactpay_models.dart';

/// TransactPay data service for API operations without UI.
class TransactPayDataService {
  final TransactPayClient _client;
  final TransactPayConfig _config;

  TransactPayDataService(this._config) : _client = TransactPayClient(_config);

  /// Initialize a payment order.
  Future<TransactPayResponse> initializePayment(TransactPayRequest request) async {
    try {
      SDKLogger.info('Initializing TransactPay payment for amount: ${request.order.amount}');
      
      _validatePaymentRequest(request);
      
      final response = await _client.initializePayment(request);
      
      SDKLogger.info('TransactPay payment initialized successfully: ${response.reference}');
      return response;
    } catch (e) {
      SDKLogger.error('Failed to initialize TransactPay payment', e);
      if (e is TransactPayException) rethrow;
      throw TransactPayException(
        'Payment initialization failed: ${e.toString()}',
        code: 'PAYMENT_INIT_FAILED',
      );
    }
  }

  /// Verify payment status.
  Future<TransactPayResponse> verifyPayment(String reference) async {
    try {
      SDKLogger.info('Verifying TransactPay payment: $reference');
      
      if (reference.isEmpty) {
        throw TransactPayException(
          'Payment reference cannot be empty',
          code: 'INVALID_REFERENCE',
        );
      }
      
      final response = await _client.verifyPayment(reference);
      
      SDKLogger.info('TransactPay payment verified successfully');
      return response;
    } catch (e) {
      SDKLogger.error('Failed to verify TransactPay payment', e);
      if (e is TransactPayException) rethrow;
      throw TransactPayException(
        'Payment verification failed: ${e.toString()}',
        code: 'PAYMENT_VERIFY_FAILED',
      );
    }
  }

  /// Create a payment request with customer and order details.
  TransactPayRequest createPaymentRequest({
    required TransactPayCustomer customer,
    required TransactPayOrder order,
    required String redirectUrl,
  }) {
    return TransactPayRequest(
      customer: customer,
      order: order,
      payment: TransactPayPayment(redirectUrl: redirectUrl),
    );
  }

  /// Create a customer object.
  TransactPayCustomer createCustomer({
    required String firstname,
    required String lastname,
    required String email,
    required String mobile,
    String country = 'NG',
  }) {
    return TransactPayCustomer(
      firstname: firstname,
      lastname: lastname,
      email: email,
      mobile: mobile,
      country: country,
    );
  }

  /// Create an order object.
  TransactPayOrder createOrder({
    required double amount,
    required String reference,
    required String description,
    String currency = 'NGN',
  }) {
    return TransactPayOrder(
      amount: amount,
      reference: reference,
      description: description,
      currency: currency,
    );
  }

  /// Generate a unique payment reference.
  String generateReference({String prefix = 'TXN'}) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp % 10000).toString().padLeft(4, '0');
    return '${prefix}_${timestamp}_$random';
  }

  /// Validate payment request parameters.
  void _validatePaymentRequest(TransactPayRequest request) {
    // Validate customer
    if (request.customer.firstname.isEmpty) {
      throw TransactPayException(
        'Customer first name is required',
        code: 'INVALID_CUSTOMER_FIRSTNAME',
      );
    }

    if (request.customer.lastname.isEmpty) {
      throw TransactPayException(
        'Customer last name is required',
        code: 'INVALID_CUSTOMER_LASTNAME',
      );
    }

    if (request.customer.email.isEmpty || !_isValidEmail(request.customer.email)) {
      throw TransactPayException(
        'Valid customer email is required',
        code: 'INVALID_CUSTOMER_EMAIL',
      );
    }

    if (request.customer.mobile.isEmpty) {
      throw TransactPayException(
        'Customer mobile number is required',
        code: 'INVALID_CUSTOMER_MOBILE',
      );
    }

    // Validate order
    if (request.order.amount <= 0) {
      throw TransactPayException(
        'Order amount must be greater than zero',
        code: 'INVALID_ORDER_AMOUNT',
      );
    }

    if (request.order.reference.isEmpty) {
      throw TransactPayException(
        'Order reference is required',
        code: 'INVALID_ORDER_REFERENCE',
      );
    }

    if (request.order.description.isEmpty) {
      throw TransactPayException(
        'Order description is required',
        code: 'INVALID_ORDER_DESCRIPTION',
      );
    }

    // Validate payment
    if (request.payment.redirectUrl.isEmpty || !_isValidUrl(request.payment.redirectUrl)) {
      throw TransactPayException(
        'Valid redirect URL is required',
        code: 'INVALID_REDIRECT_URL',
      );
    }
  }

  /// Validate email format.
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Validate URL format.
  bool _isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  /// Get merchant configuration (without sensitive data).
  Map<String, dynamic> getMerchantInfo() {
    return {
      'isTestMode': _config.isTestMode,
      'baseUrl': _config.baseUrl,
      'hasApiKey': _config.apiKey.isNotEmpty,
      'hasSecretKey': _config.secretKey.isNotEmpty,
      'hasEncryptionKey': _config.encryptionKey.isNotEmpty,
    };
  }

  /// Get current configuration.
  TransactPayConfig get config => _config;

  /// Dispose resources.
  @mustCallSuper
  void dispose() {
    _client.dispose();
  }
}