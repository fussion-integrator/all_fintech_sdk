/// Google Pay models and data structures.
library;

import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'google_pay_models.g.dart';

/// Google Pay environment.
enum GooglePayEnvironment {
  test,
  production,
}

/// Google Pay availability response.
@JsonSerializable()
class GooglePayAvailability {
  /// Whether Google Pay is available.
  final bool isAvailable;
  
  /// Reason if not available.
  final String? reason;
  
  /// Supported card networks.
  final List<GooglePayCardNetwork> supportedNetworks;

  const GooglePayAvailability({
    required this.isAvailable,
    this.reason,
    this.supportedNetworks = const [],
  });

  factory GooglePayAvailability.fromJson(Map<String, dynamic> json) =>
      _$GooglePayAvailabilityFromJson(json);

  Map<String, dynamic> toJson() => _$GooglePayAvailabilityToJson(this);
}

/// Google Pay card network.
@JsonSerializable()
class GooglePayCardNetwork {
  /// Network name.
  final String name;
  
  /// Network code.
  final String code;

  const GooglePayCardNetwork({
    required this.name,
    required this.code,
  });

  factory GooglePayCardNetwork.fromJson(Map<String, dynamic> json) =>
      _$GooglePayCardNetworkFromJson(json);

  Map<String, dynamic> toJson() => _$GooglePayCardNetworkToJson(this);
}

/// Google Pay payment request.
@JsonSerializable()
class GooglePayRequest {
  /// Payment amount.
  final double amount;
  
  /// Currency code.
  final String currencyCode;
  
  /// Payment label.
  final String label;

  const GooglePayRequest({
    required this.amount,
    required this.currencyCode,
    required this.label,
  });

  factory GooglePayRequest.fromJson(Map<String, dynamic> json) =>
      _$GooglePayRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GooglePayRequestToJson(this);
}

/// Google Pay button type.
enum GooglePayButtonType {
  buy,
  pay,
  donate,
}

/// Google Pay button theme.
enum GooglePayButtonTheme {
  dark,
  light,
}

/// Google Pay button configuration.
@immutable
class GooglePayButtonConfig {
  /// Button type.
  final GooglePayButtonType type;
  
  /// Button theme.
  final GooglePayButtonTheme theme;
  
  /// Button width.
  final double? width;
  
  /// Button height.
  final double? height;

  const GooglePayButtonConfig({
    this.type = GooglePayButtonType.pay,
    this.theme = GooglePayButtonTheme.dark,
    this.width,
    this.height,
  });
}

/// Google Pay token response.
@JsonSerializable()
class GooglePayToken {
  /// Payment token.
  final String token;
  
  /// Token type.
  final String tokenType;

  const GooglePayToken({
    required this.token,
    required this.tokenType,
  });

  factory GooglePayToken.fromJson(Map<String, dynamic> json) =>
      _$GooglePayTokenFromJson(json);

  Map<String, dynamic> toJson() => _$GooglePayTokenToJson(this);
}

/// Google Pay exception.
class GooglePayException implements Exception {
  /// Error message.
  final String message;
  
  /// Error code.
  final String? code;

  const GooglePayException(this.message, {this.code});

  @override
  String toString() => 'GooglePayException: $message${code != null ? ' ($code)' : ''}';
}