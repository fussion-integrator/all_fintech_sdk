import '../models/opay_models.dart';
import 'opay_client.dart';

/// Opay data service for API operations.
class OpayDataService {
  final OpayClient _client;

  OpayDataService(this._client);

  Future<OpayTransaction> createTransaction(OpayCreateTransactionRequest request) async {
    final response = await _client.createTransaction(request.toJson());
    return OpayTransaction.fromJson(response);
  }

  Future<OpayTransaction> getTransaction(String transactionId) async {
    final response = await _client.getTransaction(transactionId);
    return OpayTransaction.fromJson(response);
  }

  Future<List<OpayTransaction>> getTransactionsByOrderNumber(String orderNr) async {
    final response = await _client.getTransactionsByOrderNumber(orderNr);
    return response.map((data) => OpayTransaction.fromJson(data)).toList();
  }

  Future<Map<String, OpayChannelGroup>> listChannels({
    required String orderNr,
    required String redirectUrl,
    required String webServiceUrl,
    required String standard,
    required int amount,
    String currency = 'EUR',
    String? backUrl,
    String language = 'ENG',
    String? showChannels,
    String? hideChannels,
    String country = 'LT',
    String? paymentDescription,
    int timeLimit = 129600,
    String? test,
    String? cEmail,
    String? cMobileNr,
    String? passThroughChannelName,
    int passThroughOnly = 0,
    int redirectOnSuccess = 1,
    String? metadata,
    String? customParameters,
  }) async {
    final data = {
      'order_nr': orderNr,
      'redirect_url': redirectUrl,
      'web_service_url': webServiceUrl,
      'standard': standard,
      'amount': amount,
      'currency': currency,
      if (backUrl != null) 'back_url': backUrl,
      'language': language,
      if (showChannels != null) 'show_channels': showChannels,
      if (hideChannels != null) 'hide_channels': hideChannels,
      'country': country,
      if (paymentDescription != null) 'payment_description': paymentDescription,
      'time_limit': timeLimit,
      if (test != null) 'test': test,
      if (cEmail != null) 'c_email': cEmail,
      if (cMobileNr != null) 'c_mobile_nr': cMobileNr,
      if (passThroughChannelName != null) 'pass_through_channel_name': passThroughChannelName,
      'pass_through_only': passThroughOnly,
      'redirect_on_success': redirectOnSuccess,
      if (metadata != null) 'metadata': metadata,
      if (customParameters != null) 'custom_parameters': customParameters,
    };

    final response = await _client.listChannels(data);
    final channelGroups = <String, OpayChannelGroup>{};
    
    response.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        channelGroups[key] = OpayChannelGroup.fromJson(value);
      }
    });
    
    return channelGroups;
  }

  Future<Map<String, dynamic>> makeRecurringPayment(OpayRecurringPaymentRequest request) async {
    return await _client.makeRecurringPayment(request.toJson());
  }

  Future<Map<String, dynamic>> updateCardDetails({
    required String userId,
    required String currency,
    required int amount,
    required String recurringPaymentToken,
    required String paymentDescription,
    required DateTime recurringPaymentExpiryDate,
    String language = 'ENG',
  }) async {
    final data = {
      'language': language,
      'user_id': userId,
      'currency': currency,
      'amount': amount,
      'recurring_payment_token': recurringPaymentToken,
      'payment_description': paymentDescription,
      'recurring_payment_expiry_date': recurringPaymentExpiryDate.toIso8601String().split('T')[0],
    };
    
    return await _client.updateCardDetails(data);
  }

  Future<Map<String, dynamic>> getCardOperationStatus({
    required String userId,
    required String recurringPaymentToken,
    required String cardOperationId,
    String language = 'ENG',
  }) async {
    final data = {
      'language': language,
      'user_id': userId,
      'recurring_payment_token': recurringPaymentToken,
      'card_operation_id': cardOperationId,
    };
    
    return await _client.getCardOperationStatus(data);
  }

  Future<OpayRefund> createRefund(OpayRefundRequest request) async {
    final response = await _client.createRefund(request.toJson());
    return OpayRefund.fromJson(response);
  }

  Future<OpayRefund> getRefundStatus(String uniqueRefundToken) async {
    final response = await _client.getRefundStatus(uniqueRefundToken);
    return OpayRefund.fromJson(response);
  }
}