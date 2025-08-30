// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactpay_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactPayConfig _$TransactPayConfigFromJson(Map<String, dynamic> json) =>
    TransactPayConfig(
      apiKey: json['apiKey'] as String,
      secretKey: json['secretKey'] as String,
      encryptionKey: json['encryptionKey'] as String,
      isTestMode: json['isTestMode'] as bool? ?? true,
      baseUrl: json['baseUrl'] as String?,
    );

Map<String, dynamic> _$TransactPayConfigToJson(TransactPayConfig instance) =>
    <String, dynamic>{
      'apiKey': instance.apiKey,
      'secretKey': instance.secretKey,
      'encryptionKey': instance.encryptionKey,
      'isTestMode': instance.isTestMode,
      'baseUrl': instance.baseUrl,
    };

TransactPayCustomer _$TransactPayCustomerFromJson(Map<String, dynamic> json) =>
    TransactPayCustomer(
      firstname: json['firstname'] as String,
      lastname: json['lastname'] as String,
      mobile: json['mobile'] as String,
      country: json['country'] as String,
      email: json['email'] as String,
    );

Map<String, dynamic> _$TransactPayCustomerToJson(
        TransactPayCustomer instance) =>
    <String, dynamic>{
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'mobile': instance.mobile,
      'country': instance.country,
      'email': instance.email,
    };

TransactPayOrder _$TransactPayOrderFromJson(Map<String, dynamic> json) =>
    TransactPayOrder(
      amount: (json['amount'] as num).toDouble(),
      reference: json['reference'] as String,
      description: json['description'] as String,
      currency: json['currency'] as String? ?? 'NGN',
    );

Map<String, dynamic> _$TransactPayOrderToJson(TransactPayOrder instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'reference': instance.reference,
      'description': instance.description,
      'currency': instance.currency,
    };

TransactPayPayment _$TransactPayPaymentFromJson(Map<String, dynamic> json) =>
    TransactPayPayment(
      redirectUrl: json['RedirectUrl'] as String,
    );

Map<String, dynamic> _$TransactPayPaymentToJson(TransactPayPayment instance) =>
    <String, dynamic>{
      'RedirectUrl': instance.redirectUrl,
    };

TransactPayRequest _$TransactPayRequestFromJson(Map<String, dynamic> json) =>
    TransactPayRequest(
      customer: TransactPayCustomer.fromJson(
          json['customer'] as Map<String, dynamic>),
      order: TransactPayOrder.fromJson(json['order'] as Map<String, dynamic>),
      payment: TransactPayPayment.fromJson(
          json['payment'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TransactPayRequestToJson(TransactPayRequest instance) =>
    <String, dynamic>{
      'customer': instance.customer,
      'order': instance.order,
      'payment': instance.payment,
    };

TransactPayResponse _$TransactPayResponseFromJson(Map<String, dynamic> json) =>
    TransactPayResponse(
      reference: json['reference'] as String,
      status: $enumDecode(_$TransactPayStatusEnumMap, json['status']),
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      message: json['message'] as String?,
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$TransactPayResponseToJson(
        TransactPayResponse instance) =>
    <String, dynamic>{
      'reference': instance.reference,
      'status': _$TransactPayStatusEnumMap[instance.status]!,
      'amount': instance.amount,
      'currency': instance.currency,
      'message': instance.message,
      'timestamp': instance.timestamp?.toIso8601String(),
    };

const _$TransactPayStatusEnumMap = {
  TransactPayStatus.pending: 'pending',
  TransactPayStatus.successful: 'successful',
  TransactPayStatus.failed: 'failed',
  TransactPayStatus.cancelled: 'cancelled',
  TransactPayStatus.processing: 'processing',
};