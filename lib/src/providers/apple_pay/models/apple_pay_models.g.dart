// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apple_pay_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplePayAvailability _$ApplePayAvailabilityFromJson(
        Map<String, dynamic> json) =>
    ApplePayAvailability(
      isAvailable: json['isAvailable'] as bool,
      reason: json['reason'] as String?,
      supportedNetworks: (json['supportedNetworks'] as List<dynamic>?)
              ?.map((e) =>
                  ApplePayCardNetwork.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ApplePayAvailabilityToJson(
        ApplePayAvailability instance) =>
    <String, dynamic>{
      'isAvailable': instance.isAvailable,
      'reason': instance.reason,
      'supportedNetworks': instance.supportedNetworks,
    };

ApplePayCardNetwork _$ApplePayCardNetworkFromJson(
        Map<String, dynamic> json) =>
    ApplePayCardNetwork(
      name: json['name'] as String,
      code: json['code'] as String,
    );

Map<String, dynamic> _$ApplePayCardNetworkToJson(
        ApplePayCardNetwork instance) =>
    <String, dynamic>{
      'name': instance.name,
      'code': instance.code,
    };

ApplePayRequest _$ApplePayRequestFromJson(Map<String, dynamic> json) =>
    ApplePayRequest(
      amount: (json['amount'] as num).toDouble(),
      currencyCode: json['currencyCode'] as String,
      label: json['label'] as String,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => ApplePayItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      requiresEmail: json['requiresEmail'] as bool? ?? false,
      requiresBillingAddress: json['requiresBillingAddress'] as bool? ?? false,
    );

Map<String, dynamic> _$ApplePayRequestToJson(ApplePayRequest instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'currencyCode': instance.currencyCode,
      'label': instance.label,
      'items': instance.items,
      'requiresEmail': instance.requiresEmail,
      'requiresBillingAddress': instance.requiresBillingAddress,
    };

ApplePayItem _$ApplePayItemFromJson(Map<String, dynamic> json) =>
    ApplePayItem(
      label: json['label'] as String,
      amount: (json['amount'] as num).toDouble(),
    );

Map<String, dynamic> _$ApplePayItemToJson(ApplePayItem instance) =>
    <String, dynamic>{
      'label': instance.label,
      'amount': instance.amount,
    };

ApplePayToken _$ApplePayTokenFromJson(Map<String, dynamic> json) =>
    ApplePayToken(
      transactionIdentifier: json['transactionIdentifier'] as String,
      paymentData: json['paymentData'] as String,
    );

Map<String, dynamic> _$ApplePayTokenToJson(ApplePayToken instance) =>
    <String, dynamic>{
      'transactionIdentifier': instance.transactionIdentifier,
      'paymentData': instance.paymentData,
    };