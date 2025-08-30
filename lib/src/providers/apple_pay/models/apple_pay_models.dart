/// Apple Pay models and data structures.
library;

import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'apple_pay_models.g.dart';

/// Apple Pay environment.
enum ApplePayEnvironment {
  sandbox,
  production,
}

/// Apple Pay availability response.
@JsonSerializable()
class ApplePayAvailability {
  /// Whether Apple Pay is available.
  final bool isAvailable;
  
  /// Reason if not available.
  final String? reason;
  
  /// Supported card networks.
  final List<ApplePayCardNetwork> supportedNetworks;

  const ApplePayAvailability({
    required this.isAvailable,
    this.reason,
    this.supportedNetworks = const [],
  });

  factory ApplePayAvailability.fromJson(Map<String, dynamic> json) =>
      _$ApplePayAvailabilityFromJson(json);

  Map<String, dynamic> toJson() => _$ApplePayAvailabilityToJson(this);
}

/// Apple Pay card network.
@JsonSerializable()
class ApplePayCardNetwork {
  /// Network name.
  final String name;
  
  /// Network code.
  final String code;

  const ApplePayCardNetwork({
    required this.name,
    required this.code,
  });

  factory ApplePayCardNetwork.fromJson(Map<String, dynamic> json) =>
      _$ApplePayCardNetworkFromJson(json);

  Map<String, dynamic> toJson() => _$ApplePayCardNetworkToJson(this);
}

/// Apple Pay payment request.
@JsonSerializable()
class ApplePayRequest {
  /// Payment amount.
  final double amount;
  
  /// Currency code.
  final String currencyCode;
  
  /// Payment label.
  final String label;
  
  /// Payment items.
  final List<ApplePayItem>? items;
  
  /// Requires email.
  final bool requiresEmail;
  
  /// Requires billing address.
  final bool requiresBillingAddress;

  const ApplePayRequest({
    required this.amount,
    required this.currencyCode,
    required this.label,
    this.items,
    this.requiresEmail = false,
    this.requiresBillingAddress = false,
  });

  factory ApplePayRequest.fromJson(Map<String, dynamic> json) =>
      _$ApplePayRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ApplePayRequestToJson(this);
}

/// Apple Pay item.
@JsonSerializable()
class ApplePayItem {
  /// Item label.
  final String label;
  
  /// Item amount.
  final double amount;

  const ApplePayItem({
    required this.label,
    required this.amount,
  });

  factory ApplePayItem.fromJson(Map<String, dynamic> json) =>
      _$ApplePayItemFromJson(json);

  Map<String, dynamic> toJson() => _$ApplePayItemToJson(this);
}

/// Apple Pay button configuration.
@immutable
class ApplePayButtonConfig {
  /// Button width.
  final double? width;
  
  /// Button height.
  final double? height;

  const ApplePayButtonConfig({
    this.width,
    this.height,
  });
}

/// Apple Pay token response.
@JsonSerializable()
class ApplePayToken {
  /// Transaction identifier.
  final String transactionIdentifier;
  
  /// Payment data.
  final String paymentData;

  const ApplePayToken({
    required this.transactionIdentifier,
    required this.paymentData,
  });

  factory ApplePayToken.fromJson(Map<String, dynamic> json) =>
      _$ApplePayTokenFromJson(json);

  Map<String, dynamic> toJson() => _$ApplePayTokenToJson(this);
}

/// Apple Pay exception.
class ApplePayException implements Exception {
  /// Error message.
  final String message;
  
  /// Error code.
  final String? code;

  const ApplePayException(this.message, {this.code});

  @override
  String toString() => 'ApplePayException: $message${code != null ? ' ($code)' : ''}';
}