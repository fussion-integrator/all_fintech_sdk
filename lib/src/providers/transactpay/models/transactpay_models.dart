/// TransactPay models and data structures.
library;

import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'transactpay_models.g.dart';

/// TransactPay configuration.
@JsonSerializable()
class TransactPayConfig {
  /// API key (Public key).
  final String apiKey;
  
  /// Secret key.
  final String secretKey;
  
  /// Encryption key for RSA encryption.
  final String encryptionKey;
  
  /// Test mode flag.
  final bool isTestMode;
  
  /// Base URL for API calls.
  final String? baseUrl;

  const TransactPayConfig({
    required this.apiKey,
    required this.secretKey,
    required this.encryptionKey,
    this.isTestMode = true,
    this.baseUrl,
  });

  factory TransactPayConfig.fromJson(Map<String, dynamic> json) =>
      _$TransactPayConfigFromJson(json);

  Map<String, dynamic> toJson() => _$TransactPayConfigToJson(this);
}

/// TransactPay customer information.
@JsonSerializable()
class TransactPayCustomer {
  /// Customer first name.
  final String firstname;
  
  /// Customer last name.
  final String lastname;
  
  /// Customer mobile number.
  final String mobile;
  
  /// Customer country code.
  final String country;
  
  /// Customer email address.
  final String email;

  const TransactPayCustomer({
    required this.firstname,
    required this.lastname,
    required this.mobile,
    required this.country,
    required this.email,
  });

  factory TransactPayCustomer.fromJson(Map<String, dynamic> json) =>
      _$TransactPayCustomerFromJson(json);

  Map<String, dynamic> toJson() => _$TransactPayCustomerToJson(this);
}

/// TransactPay order information.
@JsonSerializable()
class TransactPayOrder {
  /// Order amount.
  final double amount;
  
  /// Order reference.
  final String reference;
  
  /// Order description.
  final String description;
  
  /// Order currency.
  final String currency;

  const TransactPayOrder({
    required this.amount,
    required this.reference,
    required this.description,
    this.currency = 'NGN',
  });

  factory TransactPayOrder.fromJson(Map<String, dynamic> json) =>
      _$TransactPayOrderFromJson(json);

  Map<String, dynamic> toJson() => _$TransactPayOrderToJson(this);
}

/// TransactPay payment configuration.
@JsonSerializable()
class TransactPayPayment {
  /// Redirect URL after payment.
  @JsonKey(name: 'RedirectUrl')
  final String redirectUrl;

  const TransactPayPayment({
    required this.redirectUrl,
  });

  factory TransactPayPayment.fromJson(Map<String, dynamic> json) =>
      _$TransactPayPaymentFromJson(json);

  Map<String, dynamic> toJson() => _$TransactPayPaymentToJson(this);
}

/// TransactPay payment request.
@JsonSerializable()
class TransactPayRequest {
  /// Customer information.
  final TransactPayCustomer customer;
  
  /// Order information.
  final TransactPayOrder order;
  
  /// Payment configuration.
  final TransactPayPayment payment;

  const TransactPayRequest({
    required this.customer,
    required this.order,
    required this.payment,
  });

  factory TransactPayRequest.fromJson(Map<String, dynamic> json) =>
      _$TransactPayRequestFromJson(json);

  Map<String, dynamic> toJson() => _$TransactPayRequestToJson(this);
}

/// TransactPay payment response.
@JsonSerializable()
class TransactPayResponse {
  /// Transaction reference.
  final String reference;
  
  /// Payment status.
  final TransactPayStatus status;
  
  /// Transaction amount.
  final double amount;
  
  /// Currency code.
  final String currency;
  
  /// Response message.
  final String? message;
  
  /// Transaction timestamp.
  final DateTime? timestamp;

  const TransactPayResponse({
    required this.reference,
    required this.status,
    required this.amount,
    required this.currency,
    this.message,
    this.timestamp,
  });

  factory TransactPayResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactPayResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TransactPayResponseToJson(this);
}

/// TransactPay payment status.
enum TransactPayStatus {
  pending,
  successful,
  failed,
  cancelled,
  processing,
}

/// TransactPay exception.
class TransactPayException implements Exception {
  /// Error message.
  final String message;
  
  /// Error code.
  final String? code;
  
  /// Additional details.
  final Map<String, dynamic>? details;

  const TransactPayException(
    this.message, {
    this.code,
    this.details,
  });

  @override
  String toString() => 'TransactPayException: $message${code != null ? ' ($code)' : ''}';
}

/// TransactPay button configuration.
@immutable
class TransactPayButtonConfig {
  /// Button text.
  final String text;
  
  /// Button width.
  final double? width;
  
  /// Button height.
  final double? height;
  
  /// Button color.
  final int? color;

  const TransactPayButtonConfig({
    this.text = 'Pay with TransactPay',
    this.width,
    this.height,
    this.color,
  });
}