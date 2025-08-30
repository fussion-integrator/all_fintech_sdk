/// Google Pay HTTP client for API interactions.
library;

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import '../../core/logger.dart';
import '../../core/constants.dart';
import 'models/google_pay_models.dart';

/// Google Pay API client.
class GooglePayClient {
  final GooglePayConfig _config;
  final http.Client _httpClient;
  
  /// Base URL for Google Pay APIs.
  static const String _baseUrl = 'https://payments.google.com/payments/apis-secure/u/0/pay';
  
  /// API version.
  static const String _apiVersion = '2.0';

  GooglePayClient(this._config, {http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  /// Check if Google Pay is available.
  Future<GooglePayAvailability> checkAvailability() async {
    try {
      final request = _buildIsReadyToPayRequest();
      final response = await _makeRequest('isReadyToPay', request);
      
      final isAvailable = response['result'] == true;
      final supportedNetworks = _config.allowedCardNetworks;
      
      return GooglePayAvailability(
        isAvailable: isAvailable,
        supportedNetworks: supportedNetworks,
        reason: isAvailable ? null : 'Google Pay not available on this device',
      );
    } catch (e) {
      SDKLogger.error('Failed to check Google Pay availability', e);
      return GooglePayAvailability(
        isAvailable: false,
        reason: e.toString(),
      );
    }
  }

  /// Request payment token.
  Future<GooglePayToken> requestPaymentToken(GooglePayRequest request) async {
    try {
      final paymentRequest = _buildPaymentDataRequest(request);
      final response = await _makeRequest('loadPaymentData', paymentRequest);
      
      return _parsePaymentToken(response);
    } catch (e) {
      SDKLogger.error('Failed to request payment token', e);
      throw GooglePayException(
        'Failed to request payment token: ${e.toString()}',
        code: 'PAYMENT_TOKEN_REQUEST_FAILED',
      );
    }
  }

  /// Validate merchant configuration.
  Future<bool> validateMerchantConfig() async {
    try {
      if (_config.merchantId.isEmpty) {
        throw GooglePayException('Merchant ID is required');
      }
      
      if (_config.merchantName.isEmpty) {
        throw GooglePayException('Merchant name is required');
      }
      
      if (_config.countryCode.length != 2) {
        throw GooglePayException('Invalid country code format');
      }
      
      if (_config.currencyCode.length != 3) {
        throw GooglePayException('Invalid currency code format');
      }
      
      return true;
    } catch (e) {
      SDKLogger.error('Merchant configuration validation failed', e);
      return false;
    }
  }

  /// Build IsReadyToPay request.
  Map<String, dynamic> _buildIsReadyToPayRequest() {
    return {
      'apiVersion': 2,
      'apiVersionMinor': 0,
      'allowedPaymentMethods': [
        {
          'type': 'CARD',
          'parameters': {
            'allowedAuthMethods': ['PAN_ONLY', 'CRYPTOGRAM_3DS'],
            'allowedCardNetworks': _config.allowedCardNetworks
                .map((network) => network.name.toUpperCase())
                .toList(),
          },
        },
      ],
    };
  }

  /// Build payment data request.
  Map<String, dynamic> _buildPaymentDataRequest(GooglePayRequest request) {
    return {
      'apiVersion': 2,
      'apiVersionMinor': 0,
      'merchantInfo': {
        'merchantId': _config.merchantId,
        'merchantName': _config.merchantName,
      },
      'allowedPaymentMethods': [
        {
          'type': 'CARD',
          'parameters': {
            'allowedAuthMethods': ['PAN_ONLY', 'CRYPTOGRAM_3DS'],
            'allowedCardNetworks': _config.allowedCardNetworks
                .map((network) => network.name.toUpperCase())
                .toList(),
            'billingAddressRequired': request.requireBillingAddress,
            'billingAddressParameters': {
              'format': 'FULL',
              'phoneNumberRequired': request.requirePhoneNumber,
            },
          },
          'tokenizationSpecification': _buildTokenizationSpec(),
        },
      ],
      'transactionInfo': {
        'totalPriceStatus': 'FINAL',
        'totalPrice': request.amount.toStringAsFixed(2),
        'currencyCode': request.currencyCode,
        'countryCode': _config.countryCode,
        'transactionId': _generateTransactionId(),
      },
      'shippingAddressRequired': request.requireShippingAddress,
      'emailRequired': request.requireEmail,
    };
  }

  /// Build tokenization specification.
  Map<String, dynamic> _buildTokenizationSpec() {
    if (_config.gateway != null && _config.gatewayMerchantId != null) {
      return {
        'type': 'PAYMENT_GATEWAY',
        'parameters': {
          'gateway': _config.gateway,
          'gatewayMerchantId': _config.gatewayMerchantId,
        },
      };
    }
    
    return {
      'type': 'DIRECT',
      'parameters': {
        'protocolVersion': 'ECv2',
        'publicKey': _config.merchantId,
      },
    };
  }

  /// Parse payment token from response.
  GooglePayToken _parsePaymentToken(Map<String, dynamic> response) {
    final paymentMethodData = response['paymentMethodData'];
    final tokenizationData = paymentMethodData['tokenizationData'];
    final info = paymentMethodData['info'];
    
    return GooglePayToken(
      token: tokenizationData['token'],
      tokenType: tokenizationData['type'],
      cardNetwork: info?['cardNetwork'],
      cardLast4: info?['cardDetails'],
      billingAddress: _parseAddress(response['billingAddress']),
      shippingAddress: _parseAddress(response['shippingAddress']),
      email: response['email'],
      phoneNumber: response['phoneNumber'],
    );
  }

  /// Parse address from response.
  GooglePayAddress? _parseAddress(Map<String, dynamic>? addressData) {
    if (addressData == null) return null;
    
    return GooglePayAddress(
      name: addressData['name'],
      address1: addressData['address1'],
      address2: addressData['address2'],
      city: addressData['locality'],
      state: addressData['administrativeArea'],
      postalCode: addressData['postalCode'],
      countryCode: addressData['countryCode'],
      phoneNumber: addressData['phoneNumber'],
    );
  }

  /// Make HTTP request to Google Pay API.
  Future<Map<String, dynamic>> _makeRequest(
    String method,
    Map<String, dynamic> data,
  ) async {
    final url = Uri.parse('$_baseUrl/$method');
    final headers = {
      'Content-Type': 'application/json',
      'User-Agent': SDKVersion.userAgent,
      'X-Payments-OS-Version': Platform.operatingSystemVersion,
      'X-Payments-Platform': Platform.operatingSystem,
    };

    SDKLogger.logRequest('POST', url.toString(), data);

    final response = await _httpClient
        .post(
          url,
          headers: headers,
          body: jsonEncode(data),
        )
        .timeout(
          Duration(seconds: HttpConstants.defaultTimeoutSeconds),
        );

    SDKLogger.logResponse('POST', url.toString(), response.statusCode, response.body);

    if (response.statusCode != 200) {
      throw GooglePayException(
        'HTTP ${response.statusCode}: ${response.body}',
        code: 'HTTP_ERROR',
        details: {'statusCode': response.statusCode, 'body': response.body},
      );
    }

    final responseData = jsonDecode(response.body) as Map<String, dynamic>;
    
    if (responseData.containsKey('error')) {
      final error = responseData['error'];
      throw GooglePayException(
        error['message'] ?? 'Unknown error',
        code: error['code']?.toString(),
        details: error,
      );
    }

    return responseData;
  }

  /// Generate unique transaction ID.
  String _generateTransactionId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = timestamp.toString();
    final bytes = utf8.encode('${_config.merchantId}$random');
    final digest = sha256.convert(bytes);
    return digest.toString().substring(0, 16);
  }

  /// Dispose resources.
  void dispose() {
    _httpClient.close();
  }
}