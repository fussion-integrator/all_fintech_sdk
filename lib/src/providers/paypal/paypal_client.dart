/// PayPal HTTP client for API interactions.
library;

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/logger.dart';
import '../../core/constants.dart';
import 'models/paypal_models.dart';

/// PayPal API client.
class PayPalClient {
  final PayPalConfig _config;
  final http.Client _httpClient;
  String? _accessToken;
  DateTime? _tokenExpiry;

  /// Base URLs for PayPal APIs.
  static const String _sandboxBaseUrl = 'https://api-m.sandbox.paypal.com';
  static const String _productionBaseUrl = 'https://api-m.paypal.com';

  PayPalClient(this._config, {http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  /// Get base URL based on environment.
  String get _baseUrl => _config.environment == PayPalEnvironment.production
      ? _productionBaseUrl
      : _sandboxBaseUrl;

  /// Get access token for API calls.
  Future<String> _getAccessToken() async {
    if (_accessToken != null && 
        _tokenExpiry != null && 
        DateTime.now().isBefore(_tokenExpiry!)) {
      return _accessToken!;
    }

    try {
      final credentials = base64Encode(
        utf8.encode('${_config.clientId}:${_config.clientSecret}'),
      );

      final response = await _httpClient.post(
        Uri.parse('$_baseUrl/v1/oauth2/token'),
        headers: {
          'Authorization': 'Basic $credentials',
          'Content-Type': 'application/x-www-form-urlencoded',
          'User-Agent': SDKVersion.userAgent,
        },
        body: 'grant_type=client_credentials',
      );

      if (response.statusCode != 200) {
        throw PayPalException(
          'Failed to get access token: ${response.body}',
          code: 'AUTH_ERROR',
        );
      }

      final data = jsonDecode(response.body);
      _accessToken = data['access_token'];
      final expiresIn = data['expires_in'] as int;
      _tokenExpiry = DateTime.now().add(Duration(seconds: expiresIn - 60));

      SDKLogger.info('PayPal access token obtained');
      return _accessToken!;
    } catch (e) {
      SDKLogger.error('Failed to get PayPal access token', e);
      throw PayPalException(
        'Authentication failed: ${e.toString()}',
        code: 'AUTH_FAILED',
      );
    }
  }

  /// Create a payment order.
  Future<PayPalPaymentResponse> createOrder(PayPalPaymentRequest request) async {
    try {
      final token = await _getAccessToken();
      final orderData = _buildOrderRequest(request);

      SDKLogger.info('Creating PayPal order for amount: ${request.amount.value}');

      final response = await _httpClient.post(
        Uri.parse('$_baseUrl/v2/checkout/orders'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'User-Agent': SDKVersion.userAgent,
          'PayPal-Request-Id': _generateRequestId(),
        },
        body: jsonEncode(orderData),
      );

      SDKLogger.logResponse('POST', '$_baseUrl/v2/checkout/orders', response.statusCode);

      if (response.statusCode != 201) {
        throw PayPalException(
          'Failed to create order: ${response.body}',
          code: 'ORDER_CREATION_FAILED',
        );
      }

      final responseData = jsonDecode(response.body);
      return _parseOrderResponse(responseData);
    } catch (e) {
      SDKLogger.error('Failed to create PayPal order', e);
      if (e is PayPalException) rethrow;
      throw PayPalException(
        'Order creation failed: ${e.toString()}',
        code: 'ORDER_ERROR',
      );
    }
  }

  /// Capture an approved order.
  Future<PayPalCaptureResponse> captureOrder(String orderId) async {
    try {
      final token = await _getAccessToken();

      SDKLogger.info('Capturing PayPal order: $orderId');

      final response = await _httpClient.post(
        Uri.parse('$_baseUrl/v2/checkout/orders/$orderId/capture'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'User-Agent': SDKVersion.userAgent,
          'PayPal-Request-Id': _generateRequestId(),
        },
      );

      SDKLogger.logResponse('POST', '$_baseUrl/v2/checkout/orders/$orderId/capture', response.statusCode);

      if (response.statusCode != 201) {
        throw PayPalException(
          'Failed to capture order: ${response.body}',
          code: 'CAPTURE_FAILED',
        );
      }

      final responseData = jsonDecode(response.body);
      return _parseCaptureResponse(responseData);
    } catch (e) {
      SDKLogger.error('Failed to capture PayPal order', e);
      if (e is PayPalException) rethrow;
      throw PayPalException(
        'Order capture failed: ${e.toString()}',
        code: 'CAPTURE_ERROR',
      );
    }
  }

  /// Get order details.
  Future<PayPalPaymentResponse> getOrder(String orderId) async {
    try {
      final token = await _getAccessToken();

      final response = await _httpClient.get(
        Uri.parse('$_baseUrl/v2/checkout/orders/$orderId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'User-Agent': SDKVersion.userAgent,
        },
      );

      if (response.statusCode != 200) {
        throw PayPalException(
          'Failed to get order: ${response.body}',
          code: 'ORDER_NOT_FOUND',
        );
      }

      final responseData = jsonDecode(response.body);
      return _parseOrderResponse(responseData);
    } catch (e) {
      SDKLogger.error('Failed to get PayPal order', e);
      if (e is PayPalException) rethrow;
      throw PayPalException(
        'Failed to retrieve order: ${e.toString()}',
        code: 'ORDER_RETRIEVAL_ERROR',
      );
    }
  }

  /// Build order request payload.
  Map<String, dynamic> _buildOrderRequest(PayPalPaymentRequest request) {
    final purchaseUnits = <Map<String, dynamic>>[
      {
        'amount': request.amount.toJson(),
        if (request.description != null) 'description': request.description,
        if (request.customId != null) 'custom_id': request.customId,
        if (request.invoiceId != null) 'invoice_id': request.invoiceId,
        if (request.items != null)
          'items': request.items!.map((item) => item.toJson()).toList(),
        if (request.shippingAddress != null)
          'shipping': {
            'address': request.shippingAddress!.toJson(),
          },
      },
    ];

    return {
      'intent': request.intent.name.toUpperCase(),
      'purchase_units': purchaseUnits,
      'application_context': {
        'return_url': _config.returnUrl ?? 'https://example.com/return',
        'cancel_url': _config.cancelUrl ?? 'https://example.com/cancel',
        'brand_name': 'All Fintech SDK',
        'landing_page': 'BILLING',
        'user_action': 'PAY_NOW',
      },
    };
  }

  /// Parse order response.
  PayPalPaymentResponse _parseOrderResponse(Map<String, dynamic> data) {
    final links = data['links'] as List<dynamic>? ?? [];
    String? approvalUrl;
    
    for (final link in links) {
      if (link['rel'] == 'approve') {
        approvalUrl = link['href'];
        break;
      }
    }

    final purchaseUnits = data['purchase_units'] as List<dynamic>;
    final amount = purchaseUnits.first['amount'];

    return PayPalPaymentResponse(
      id: data['id'],
      status: _parsePaymentStatus(data['status']),
      intent: _parseIntent(data['intent']),
      approvalUrl: approvalUrl,
      amount: PayPalAmount.fromJson(amount),
      createTime: data['create_time'] != null 
          ? DateTime.parse(data['create_time']) 
          : null,
      updateTime: data['update_time'] != null 
          ? DateTime.parse(data['update_time']) 
          : null,
    );
  }

  /// Parse capture response.
  PayPalCaptureResponse _parseCaptureResponse(Map<String, dynamic> data) {
    final purchaseUnits = data['purchase_units'] as List<dynamic>;
    final payments = purchaseUnits.first['payments'];
    final captures = payments['captures'] as List<dynamic>;
    final capture = captures.first;

    return PayPalCaptureResponse(
      id: capture['id'],
      status: _parseCaptureStatus(capture['status']),
      amount: PayPalAmount.fromJson(capture['amount']),
      sellerProtection: capture['seller_protection'] != null
          ? PayPalSellerProtection.fromJson(capture['seller_protection'])
          : null,
      finalCapture: capture['final_capture'],
      createTime: capture['create_time'] != null 
          ? DateTime.parse(capture['create_time']) 
          : null,
      updateTime: capture['update_time'] != null 
          ? DateTime.parse(capture['update_time']) 
          : null,
    );
  }

  /// Parse payment status.
  PayPalPaymentStatus _parsePaymentStatus(String status) {
    switch (status.toLowerCase()) {
      case 'created':
        return PayPalPaymentStatus.created;
      case 'saved':
        return PayPalPaymentStatus.saved;
      case 'approved':
        return PayPalPaymentStatus.approved;
      case 'voided':
        return PayPalPaymentStatus.voided;
      case 'completed':
        return PayPalPaymentStatus.completed;
      case 'payer_action_required':
        return PayPalPaymentStatus.payerActionRequired;
      default:
        return PayPalPaymentStatus.created;
    }
  }

  /// Parse payment intent.
  PayPalIntent _parseIntent(String intent) {
    switch (intent.toLowerCase()) {
      case 'capture':
        return PayPalIntent.capture;
      case 'authorize':
        return PayPalIntent.authorize;
      default:
        return PayPalIntent.capture;
    }
  }

  /// Parse capture status.
  PayPalCaptureStatus _parseCaptureStatus(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return PayPalCaptureStatus.completed;
      case 'declined':
        return PayPalCaptureStatus.declined;
      case 'partially_refunded':
        return PayPalCaptureStatus.partiallyRefunded;
      case 'pending':
        return PayPalCaptureStatus.pending;
      case 'refunded':
        return PayPalCaptureStatus.refunded;
      default:
        return PayPalCaptureStatus.pending;
    }
  }

  /// Generate unique request ID.
  String _generateRequestId() {
    return 'ALLFINTECH-${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Dispose resources.
  void dispose() {
    _httpClient.close();
  }
}