/// Apple Pay client for PassKit integration.
library;

import 'dart:io';
import 'package:flutter/services.dart';
import '../../core/logger.dart';
import 'models/apple_pay_models.dart';

/// Apple Pay client for PassKit operations.
class ApplePayClient {
  final ApplePayConfig _config;
  static const MethodChannel _channel = MethodChannel('all_fintech_sdk/apple_pay');

  ApplePayClient(this._config);

  /// Check if Apple Pay is available on device.
  Future<ApplePayAvailability> checkAvailability() async {
    try {
      if (!Platform.isIOS) {
        return const ApplePayAvailability(
          isAvailable: false,
          canMakePayments: false,
          canMakePaymentsUsingNetworks: false,
          reason: 'Apple Pay is only available on iOS devices',
        );
      }

      final result = await _channel.invokeMethod<Map<String, dynamic>>(
        'checkAvailability',
        {
          'supportedNetworks': _config.supportedNetworks
              .map((network) => _networkToString(network))
              .toList(),
        },
      );

      if (result == null) {
        throw ApplePayException('Failed to check Apple Pay availability');
      }

      return ApplePayAvailability(
        isAvailable: result['isAvailable'] as bool? ?? false,
        canMakePayments: result['canMakePayments'] as bool? ?? false,
        canMakePaymentsUsingNetworks: result['canMakePaymentsUsingNetworks'] as bool? ?? false,
        reason: result['reason'] as String?,
      );
    } catch (e) {
      SDKLogger.error('Failed to check Apple Pay availability', e);
      return ApplePayAvailability(
        isAvailable: false,
        canMakePayments: false,
        canMakePaymentsUsingNetworks: false,
        reason: e.toString(),
      );
    }
  }

  /// Request Apple Pay payment.
  Future<ApplePayToken> requestPayment(ApplePayRequest request) async {
    try {
      if (!Platform.isIOS) {
        throw ApplePayException(
          'Apple Pay is only available on iOS devices',
          code: 'PLATFORM_NOT_SUPPORTED',
        );
      }

      final paymentRequest = _buildPaymentRequest(request);
      
      SDKLogger.info('Requesting Apple Pay payment for amount: ${request.amount}');
      
      final result = await _channel.invokeMethod<Map<String, dynamic>>(
        'requestPayment',
        paymentRequest,
      );

      if (result == null) {
        throw ApplePayException('Payment request returned null result');
      }

      return _parsePaymentToken(result);
    } catch (e) {
      SDKLogger.error('Failed to request Apple Pay payment', e);
      if (e is ApplePayException) {
        rethrow;
      }
      throw ApplePayException(
        'Payment request failed: ${e.toString()}',
        code: 'PAYMENT_REQUEST_FAILED',
      );
    }
  }

  /// Complete Apple Pay payment.
  Future<void> completePayment(ApplePayStatus status) async {
    try {
      await _channel.invokeMethod('completePayment', {
        'status': _statusToString(status),
      });
      
      SDKLogger.info('Apple Pay payment completed with status: $status');
    } catch (e) {
      SDKLogger.error('Failed to complete Apple Pay payment', e);
      throw ApplePayException(
        'Failed to complete payment: ${e.toString()}',
        code: 'PAYMENT_COMPLETION_FAILED',
      );
    }
  }

  /// Build payment request for native layer.
  Map<String, dynamic> _buildPaymentRequest(ApplePayRequest request) {
    final paymentItems = <Map<String, dynamic>>[];
    
    // Add individual items if provided
    if (request.items != null) {
      for (final item in request.items!) {
        paymentItems.add({
          'label': item.label,
          'amount': item.amount.toStringAsFixed(2),
          'type': item.type == ApplePayItemType.final_ ? 'final' : 'pending',
        });
      }
    }
    
    // Add total item
    paymentItems.add({
      'label': request.label ?? _config.merchantName,
      'amount': request.amount.toStringAsFixed(2),
      'type': 'final',
    });

    return {
      'merchantIdentifier': _config.merchantId,
      'merchantDisplayName': _config.merchantName,
      'countryCode': _config.countryCode,
      'currencyCode': request.currencyCode,
      'paymentItems': paymentItems,
      'supportedNetworks': _config.supportedNetworks
          .map((network) => _networkToString(network))
          .toList(),
      'merchantCapabilities': _config.merchantCapabilities
          .map((capability) => _capabilityToString(capability))
          .toList(),
      'requiredBillingContactFields': _buildContactFields(
        request.requiresBillingAddress,
        request.requiresPhoneNumber,
        request.requiresEmail,
      ),
      'requiredShippingContactFields': _buildContactFields(
        request.requiresShippingAddress,
        request.requiresPhoneNumber,
        request.requiresEmail,
      ),
      'shippingType': request.shippingType != null
          ? _shippingTypeToString(request.shippingType!)
          : null,
    };
  }

  /// Build contact fields array.
  List<String> _buildContactFields(bool address, bool phone, bool email) {
    final fields = <String>[];
    if (address) fields.add('postalAddress');
    if (phone) fields.add('phoneNumber');
    if (email) fields.add('emailAddress');
    return fields;
  }

  /// Parse payment token from native response.
  ApplePayToken _parsePaymentToken(Map<String, dynamic> response) {
    final paymentMethodData = response['paymentMethod'] as Map<String, dynamic>? ?? {};
    final billingContactData = response['billingContact'] as Map<String, dynamic>?;
    final shippingContactData = response['shippingContact'] as Map<String, dynamic>?;

    return ApplePayToken(
      paymentData: response['paymentData'] as String? ?? '',
      transactionIdentifier: response['transactionIdentifier'] as String? ?? '',
      paymentMethod: ApplePayPaymentMethod(
        displayName: paymentMethodData['displayName'] as String?,
        network: _stringToNetwork(paymentMethodData['network'] as String?),
        type: _stringToPaymentType(paymentMethodData['type'] as String?),
      ),
      billingContact: billingContactData != null
          ? _parseContact(billingContactData)
          : null,
      shippingContact: shippingContactData != null
          ? _parseContact(shippingContactData)
          : null,
    );
  }

  /// Parse contact information.
  ApplePayContact _parseContact(Map<String, dynamic> contactData) {
    final postalAddressData = contactData['postalAddress'] as Map<String, dynamic>?;
    
    return ApplePayContact(
      phoneNumber: contactData['phoneNumber'] as String?,
      emailAddress: contactData['emailAddress'] as String?,
      givenName: contactData['givenName'] as String?,
      familyName: contactData['familyName'] as String?,
      postalAddress: postalAddressData != null
          ? ApplePayPostalAddress(
              street: postalAddressData['street'] as String?,
              city: postalAddressData['city'] as String?,
              state: postalAddressData['state'] as String?,
              postalCode: postalAddressData['postalCode'] as String?,
              country: postalAddressData['country'] as String?,
              countryCode: postalAddressData['countryCode'] as String?,
            )
          : null,
    );
  }

  /// Convert network enum to string.
  String _networkToString(ApplePayNetwork network) {
    switch (network) {
      case ApplePayNetwork.visa:
        return 'visa';
      case ApplePayNetwork.masterCard:
        return 'masterCard';
      case ApplePayNetwork.amex:
        return 'amex';
      case ApplePayNetwork.discover:
        return 'discover';
      case ApplePayNetwork.jcb:
        return 'jcb';
      case ApplePayNetwork.chinaUnionPay:
        return 'chinaUnionPay';
      case ApplePayNetwork.interac:
        return 'interac';
      case ApplePayNetwork.privateLabel:
        return 'privateLabel';
    }
  }

  /// Convert string to network enum.
  ApplePayNetwork? _stringToNetwork(String? network) {
    if (network == null) return null;
    switch (network.toLowerCase()) {
      case 'visa':
        return ApplePayNetwork.visa;
      case 'mastercard':
        return ApplePayNetwork.masterCard;
      case 'amex':
        return ApplePayNetwork.amex;
      case 'discover':
        return ApplePayNetwork.discover;
      case 'jcb':
        return ApplePayNetwork.jcb;
      case 'chinaunionpay':
        return ApplePayNetwork.chinaUnionPay;
      case 'interac':
        return ApplePayNetwork.interac;
      case 'privatelabel':
        return ApplePayNetwork.privateLabel;
      default:
        return null;
    }
  }

  /// Convert capability enum to string.
  String _capabilityToString(ApplePayMerchantCapability capability) {
    switch (capability) {
      case ApplePayMerchantCapability.supports3DS:
        return 'supports3DS';
      case ApplePayMerchantCapability.supportsEMV:
        return 'supportsEMV';
      case ApplePayMerchantCapability.supportsCredit:
        return 'supportsCredit';
      case ApplePayMerchantCapability.supportsDebit:
        return 'supportsDebit';
    }
  }

  /// Convert shipping type enum to string.
  String _shippingTypeToString(ApplePayShippingType type) {
    switch (type) {
      case ApplePayShippingType.shipping:
        return 'shipping';
      case ApplePayShippingType.delivery:
        return 'delivery';
      case ApplePayShippingType.storePickup:
        return 'storePickup';
      case ApplePayShippingType.servicePickup:
        return 'servicePickup';
    }
  }

  /// Convert status enum to string.
  String _statusToString(ApplePayStatus status) {
    switch (status) {
      case ApplePayStatus.success:
        return 'success';
      case ApplePayStatus.failure:
        return 'failure';
      case ApplePayStatus.invalidBillingPostalAddress:
        return 'invalidBillingPostalAddress';
      case ApplePayStatus.invalidShippingPostalAddress:
        return 'invalidShippingPostalAddress';
      case ApplePayStatus.invalidShippingContact:
        return 'invalidShippingContact';
      case ApplePayStatus.requiresPin:
        return 'requiresPin';
    }
  }

  /// Convert string to payment type enum.
  ApplePayPaymentType _stringToPaymentType(String? type) {
    if (type == null) return ApplePayPaymentType.unknown;
    switch (type.toLowerCase()) {
      case 'debit':
        return ApplePayPaymentType.debit;
      case 'credit':
        return ApplePayPaymentType.credit;
      case 'prepaid':
        return ApplePayPaymentType.prepaid;
      case 'store':
        return ApplePayPaymentType.store;
      default:
        return ApplePayPaymentType.unknown;
    }
  }
}