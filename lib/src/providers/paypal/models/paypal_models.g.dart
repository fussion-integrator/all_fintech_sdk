// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paypal_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayPalRequest _$PayPalRequestFromJson(Map<String, dynamic> json) =>
    PayPalRequest(
      amount: (json['amount'] as num).toDouble(),
      currencyCode: json['currencyCode'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$PayPalRequestToJson(PayPalRequest instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'currencyCode': instance.currencyCode,
      'description': instance.description,
    };

PayPalResponse _$PayPalResponseFromJson(Map<String, dynamic> json) =>
    PayPalResponse(
      id: json['id'] as String,
      status: json['status'] as String,
      amount: (json['amount'] as num).toDouble(),
    );

Map<String, dynamic> _$PayPalResponseToJson(PayPalResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'amount': instance.amount,
    };