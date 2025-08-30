/// PayPal models and data structures.
library;

import 'package:json_annotation/json_annotation.dart';

part 'paypal_models.g.dart';

/// PayPal environment.
enum PayPalEnvironment {
  sandbox,
  production,
}

/// PayPal payment request.
@JsonSerializable()
class PayPalRequest {
  /// Payment amount.
  final double amount;
  
  /// Currency code.
  final String currencyCode;
  
  /// Payment description.
  final String description;

  const PayPalRequest({
    required this.amount,
    required this.currencyCode,
    required this.description,
  });

  factory PayPalRequest.fromJson(Map<String, dynamic> json) =>
      _$PayPalRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PayPalRequestToJson(this);
}

/// PayPal payment response.
@JsonSerializable()
class PayPalResponse {
  /// Payment ID.
  final String id;
  
  /// Payment status.
  final String status;
  
  /// Payment amount.
  final double amount;

  const PayPalResponse({
    required this.id,
    required this.status,
    required this.amount,
  });

  factory PayPalResponse.fromJson(Map<String, dynamic> json) =>
      _$PayPalResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PayPalResponseToJson(this);
}

/// PayPal exception.
class PayPalException implements Exception {
  /// Error message.
  final String message;
  
  /// Error code.
  final String? code;

  const PayPalException(this.message, {this.code});

  @override
  String toString() => 'PayPalException: $message${code != null ? ' ($code)' : ''}';
}