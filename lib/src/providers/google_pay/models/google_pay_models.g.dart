// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_pay_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GooglePayAvailability _$GooglePayAvailabilityFromJson(
        Map<String, dynamic> json) =>
    GooglePayAvailability(
      isAvailable: json['isAvailable'] as bool,
      reason: json['reason'] as String?,
      supportedNetworks: (json['supportedNetworks'] as List<dynamic>?)
              ?.map((e) =>
                  GooglePayCardNetwork.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$GooglePayAvailabilityToJson(
        GooglePayAvailability instance) =>
    <String, dynamic>{
      'isAvailable': instance.isAvailable,
      'reason': instance.reason,
      'supportedNetworks': instance.supportedNetworks,
    };

GooglePayCardNetwork _$GooglePayCardNetworkFromJson(
        Map<String, dynamic> json) =>
    GooglePayCardNetwork(
      name: json['name'] as String,
      code: json['code'] as String,
    );

Map<String, dynamic> _$GooglePayCardNetworkToJson(
        GooglePayCardNetwork instance) =>
    <String, dynamic>{
      'name': instance.name,
      'code': instance.code,
    };

GooglePayRequest _$GooglePayRequestFromJson(Map<String, dynamic> json) =>
    GooglePayRequest(
      amount: (json['amount'] as num).toDouble(),
      currencyCode: json['currencyCode'] as String,
      label: json['label'] as String,
    );

Map<String, dynamic> _$GooglePayRequestToJson(GooglePayRequest instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'currencyCode': instance.currencyCode,
      'label': instance.label,
    };

GooglePayToken _$GooglePayTokenFromJson(Map<String, dynamic> json) =>
    GooglePayToken(
      token: json['token'] as String,
      tokenType: json['tokenType'] as String,
    );

Map<String, dynamic> _$GooglePayTokenToJson(GooglePayToken instance) =>
    <String, dynamic>{
      'token': instance.token,
      'tokenType': instance.tokenType,
    };