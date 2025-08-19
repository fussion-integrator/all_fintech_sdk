import '../../../core/api_response.dart';
import '../../../models/flutterwave_models.dart';
import '../flutterwave_client.dart';

/// Flutterwave data service for API operations.
class FlutterwaveDataService {
  final FlutterwaveClient _client;

  FlutterwaveDataService(this._client);

  // PAYMENT ENDPOINTS

  /// Initialize payment
  Future<ApiResponse<Map<String, dynamic>>> initializePayment(
    FlutterwavePaymentRequest request,
  ) async {
    return await _client.post('/payments', data: request.toJson());
  }

  /// Verify payment
  Future<ApiResponse<FlutterwaveTransaction>> verifyPayment(int transactionId) async {
    return await _client.get(
      '/transactions/$transactionId/verify',
      fromJson: (data) => FlutterwaveTransaction.fromJson(data),
    );
  }

  /// Get payment link
  Future<ApiResponse<Map<String, dynamic>>> createPaymentLink({
    required String txRef,
    required int amount,
    required String currency,
    required String redirectUrl,
    required FlutterwaveCustomer customer,
    Map<String, dynamic>? customizations,
  }) async {
    final data = {
      'tx_ref': txRef,
      'amount': amount,
      'currency': currency,
      'redirect_url': redirectUrl,
      'customer': customer.toJson(),
      if (customizations != null) 'customizations': customizations,
    };

    return await _client.post('/payments', data: data);
  }

  // TRANSACTION ENDPOINTS

  /// List transactions
  Future<ApiResponse<List<FlutterwaveTransaction>>> listTransactions({
    int page = 1,
    DateTime? from,
    DateTime? to,
    String? currency,
    String? status,
  }) async {
    final queryParams = <String, dynamic>{'page': page};
    if (from != null) queryParams['from'] = from.toIso8601String();
    if (to != null) queryParams['to'] = to.toIso8601String();
    if (currency != null) queryParams['currency'] = currency;
    if (status != null) queryParams['status'] = status;

    return await _client.get(
      '/transactions',
      queryParameters: queryParams,
      fromJson: (data) => (data as List)
          .map((item) => FlutterwaveTransaction.fromJson(item))
          .toList(),
    );
  }

  /// Get transaction by ID
  Future<ApiResponse<FlutterwaveTransaction>> getTransaction(int transactionId) async {
    return await _client.get(
      '/transactions/$transactionId',
      fromJson: (data) => FlutterwaveTransaction.fromJson(data),
    );
  }

  // TRANSFER ENDPOINTS

  /// Create transfer
  Future<ApiResponse<FlutterwaveTransfer>> createTransfer(
    FlutterwaveTransferRequest request,
  ) async {
    return await _client.post(
      '/transfers',
      data: request.toJson(),
      fromJson: (data) => FlutterwaveTransfer.fromJson(data),
    );
  }

  /// List transfers
  Future<ApiResponse<List<FlutterwaveTransfer>>> listTransfers({
    int page = 1,
    String? status,
  }) async {
    final queryParams = <String, dynamic>{'page': page};
    if (status != null) queryParams['status'] = status;

    return await _client.get(
      '/transfers',
      queryParameters: queryParams,
      fromJson: (data) => (data as List)
          .map((item) => FlutterwaveTransfer.fromJson(item))
          .toList(),
    );
  }

  /// Get transfer by ID
  Future<ApiResponse<FlutterwaveTransfer>> getTransfer(int transferId) async {
    return await _client.get(
      '/transfers/$transferId',
      fromJson: (data) => FlutterwaveTransfer.fromJson(data),
    );
  }

  /// Get transfer fee
  Future<ApiResponse<Map<String, dynamic>>> getTransferFee({
    required int amount,
    required String currency,
  }) async {
    return await _client.get(
      '/transfers/fee',
      queryParameters: {
        'amount': amount,
        'currency': currency,
      },
    );
  }

  // BANK ENDPOINTS

  /// List banks (legacy)
  Future<ApiResponse<List<FlutterwaveBank>>> listBanks(String country) async {
    return await _client.get(
      '/banks/$country',
      fromJson: (data) => (data as List)
          .map((item) => FlutterwaveBank.fromJson(item))
          .toList(),
    );
  }

  /// Get banks by country
  Future<ApiResponse<List<FlutterwaveBank>>> getBanksByCountry(String country) async {
    return await _client.get(
      '/banks',
      queryParameters: {'country': country},
      fromJson: (data) => (data as List)
          .map((item) => FlutterwaveBank.fromJson(item))
          .toList(),
    );
  }

  /// Get mobile networks by country
  Future<ApiResponse<List<FlutterwaveMobileNetwork>>> getMobileNetworks(String country) async {
    return await _client.get(
      '/mobile-networks',
      queryParameters: {'country': country},
      fromJson: (data) => (data as List)
          .map((item) => FlutterwaveMobileNetwork.fromJson(item))
          .toList(),
    );
  }

  /// Get bank branches
  Future<ApiResponse<List<FlutterwaveBankBranch>>> getBankBranches(String bankId) async {
    return await _client.get(
      '/banks/$bankId/branches',
      fromJson: (data) => (data as List)
          .map((item) => FlutterwaveBankBranch.fromJson(item))
          .toList(),
    );
  }

  /// Resolve bank account
  Future<ApiResponse<FlutterwaveAccountResolution>> resolveBankAccount(
    Map<String, dynamic> request,
  ) async {
    return await _client.post(
      '/banks/account-resolve',
      data: request,
      fromJson: (data) => FlutterwaveAccountResolution.fromJson(data),
    );
  }

  /// Resolve account
  Future<ApiResponse<Map<String, dynamic>>> resolveAccount({
    required String accountNumber,
    required String accountBank,
  }) async {
    return await _client.post('/accounts/resolve', data: {
      'account_number': accountNumber,
      'account_bank': accountBank,
    });
  }

  // BALANCE ENDPOINTS

  /// Get balance
  Future<ApiResponse<List<Map<String, dynamic>>>> getBalance() async {
    return await _client.get(
      '/balances',
      fromJson: (data) => List<Map<String, dynamic>>.from(data),
    );
  }

  /// Get balance by currency
  Future<ApiResponse<Map<String, dynamic>>> getBalanceByCurrency(String currency) async {
    return await _client.get('/balances/$currency');
  }

  // CUSTOMER ENDPOINTS

  /// List customers
  Future<ApiResponse<List<FlutterwaveCustomer>>> listCustomers({
    int page = 1,
    int size = 10,
  }) async {
    return await _client.get(
      '/customers',
      queryParameters: {
        'page': page,
        'size': size,
      },
      fromJson: (data) => (data as List)
          .map((item) => FlutterwaveCustomer.fromJson(item))
          .toList(),
    );
  }

  /// Create customer
  Future<ApiResponse<FlutterwaveCustomer>> createCustomer(
    FlutterwaveCustomerRequest request,
  ) async {
    return await _client.post(
      '/customers',
      data: request.toJson(),
      fromJson: (data) => FlutterwaveCustomer.fromJson(data),
    );
  }

  /// Get customer by ID
  Future<ApiResponse<FlutterwaveCustomer>> getCustomer(String customerId) async {
    return await _client.get(
      '/customers/$customerId',
      fromJson: (data) => FlutterwaveCustomer.fromJson(data),
    );
  }

  /// Update customer
  Future<ApiResponse<FlutterwaveCustomer>> updateCustomer(
    String customerId,
    FlutterwaveCustomerRequest request,
  ) async {
    return await _client.put(
      '/customers/$customerId',
      data: request.toJson(),
      fromJson: (data) => FlutterwaveCustomer.fromJson(data),
    );
  }

  /// Search customers
  Future<ApiResponse<List<FlutterwaveCustomer>>> searchCustomers({
    required String email,
    int page = 1,
    int size = 10,
  }) async {
    return await _client.post(
      '/customers/search',
      queryParameters: {
        'page': page,
        'size': size,
      },
      data: {'email': email},
      fromJson: (data) => (data as List)
          .map((item) => FlutterwaveCustomer.fromJson(item))
          .toList(),
    );
  }

  // CHARGE ENDPOINTS

  /// List charges
  Future<ApiResponse<List<FlutterwaveCharge>>> listCharges({
    String? status,
    String? reference,
    DateTime? from,
    DateTime? to,
    String? customerId,
    String? virtualAccountId,
    String? paymentMethodId,
    String? orderId,
    int page = 1,
    int size = 10,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'size': size,
    };
    if (status != null) queryParams['status'] = status;
    if (reference != null) queryParams['reference'] = reference;
    if (from != null) queryParams['from'] = from.toIso8601String();
    if (to != null) queryParams['to'] = to.toIso8601String();
    if (customerId != null) queryParams['customer_id'] = customerId;
    if (virtualAccountId != null) queryParams['virtual_account_id'] = virtualAccountId;
    if (paymentMethodId != null) queryParams['payment_method_id'] = paymentMethodId;
    if (orderId != null) queryParams['order_id'] = orderId;

    return await _client.get(
      '/charges',
      queryParameters: queryParams,
      fromJson: (data) => (data as List)
          .map((item) => FlutterwaveCharge.fromJson(item))
          .toList(),
    );
  }

  /// Create charge
  Future<ApiResponse<FlutterwaveCharge>> createCharge(
    FlutterwaveChargeRequest request,
  ) async {
    return await _client.post(
      '/charges',
      data: request.toJson(),
      fromJson: (data) => FlutterwaveCharge.fromJson(data),
    );
  }

  /// Get charge by ID
  Future<ApiResponse<FlutterwaveCharge>> getCharge(String chargeId) async {
    return await _client.get(
      '/charges/$chargeId',
      fromJson: (data) => FlutterwaveCharge.fromJson(data),
    );
  }

  /// Update charge
  Future<ApiResponse<FlutterwaveCharge>> updateCharge(
    String chargeId, {
    Map<String, dynamic>? meta,
  }) async {
    final data = <String, dynamic>{};
    if (meta != null) data['meta'] = meta;

    return await _client.put(
      '/charges/$chargeId',
      data: data,
      fromJson: (data) => FlutterwaveCharge.fromJson(data),
    );
  }

  // ORCHESTRATION ENDPOINTS

  /// Create orchestrator charge
  Future<ApiResponse<FlutterwaveCharge>> createOrchestratorCharge(
    FlutterwaveOrchestrationRequest request,
  ) async {
    return await _client.post(
      '/orchestration/direct-charges',
      data: request.toJson(),
      fromJson: (data) => FlutterwaveCharge.fromJson(data),
    );
  }

  /// Create orchestrator order
  Future<ApiResponse<Map<String, dynamic>>> createOrchestratorOrder(
    FlutterwaveOrchestrationRequest request,
  ) async {
    return await _client.post(
      '/orchestration/direct-orders',
      data: request.toJson(),
    );
  }

  // PAYMENT METHODS ENDPOINTS

  /// List payment methods
  Future<ApiResponse<List<FlutterwavePaymentMethod>>> listPaymentMethods({
    int page = 1,
    int size = 10,
  }) async {
    return await _client.get(
      '/payment-methods',
      queryParameters: {
        'page': page,
        'size': size,
      },
      fromJson: (data) => (data as List)
          .map((item) => FlutterwavePaymentMethod.fromJson(item))
          .toList(),
    );
  }

  /// Create payment method
  Future<ApiResponse<FlutterwavePaymentMethod>> createPaymentMethod(
    Map<String, dynamic> paymentMethodData,
  ) async {
    return await _client.post(
      '/payment-methods',
      data: paymentMethodData,
      fromJson: (data) => FlutterwavePaymentMethod.fromJson(data),
    );
  }

  /// Get payment method by ID
  Future<ApiResponse<FlutterwavePaymentMethod>> getPaymentMethod(
    String paymentMethodId,
  ) async {
    return await _client.get(
      '/payment-methods/$paymentMethodId',
      fromJson: (data) => FlutterwavePaymentMethod.fromJson(data),
    );
  }

  // DIRECT TRANSFER ENDPOINTS

  /// Create direct transfer
  Future<ApiResponse<FlutterwaveTransfer>> createDirectTransfer(
    FlutterwaveDirectTransferRequest request,
  ) async {
    return await _client.post(
      '/direct-transfers',
      data: request.toJson(),
      fromJson: (data) => FlutterwaveTransfer.fromJson(data),
    );
  }

  /// Create transfer (using recipient/sender IDs)
  Future<ApiResponse<FlutterwaveTransfer>> createTransferWithIds(
    FlutterwaveTransferCreateRequest request,
  ) async {
    return await _client.post(
      '/transfers',
      data: request.toJson(),
      fromJson: (data) => FlutterwaveTransfer.fromJson(data),
    );
  }

  /// List transfers (enhanced)
  Future<ApiResponse<List<FlutterwaveTransfer>>> listTransfersEnhanced({
    String? next,
    String? previous,
    int size = 10,
    String? bulkId,
    String? recipientId,
    String? senderId,
    String? destinationCurrency,
    String? sourceCurrency,
    String? action,
    String? type,
    String? status,
    String? from,
    String? to,
  }) async {
    final queryParams = <String, dynamic>{'size': size};
    if (next != null) queryParams['next'] = next;
    if (previous != null) queryParams['previous'] = previous;
    if (bulkId != null) queryParams['bulk_id'] = bulkId;
    if (recipientId != null) queryParams['recipient_id'] = recipientId;
    if (senderId != null) queryParams['sender_id'] = senderId;
    if (destinationCurrency != null) queryParams['destination_currency'] = destinationCurrency;
    if (sourceCurrency != null) queryParams['source_currency'] = sourceCurrency;
    if (action != null) queryParams['action'] = action;
    if (type != null) queryParams['type'] = type;
    if (status != null) queryParams['status'] = status;
    if (from != null) queryParams['from'] = from;
    if (to != null) queryParams['to'] = to;

    return await _client.get(
      '/transfers',
      queryParameters: queryParams,
      fromJson: (data) => (data as List)
          .map((item) => FlutterwaveTransfer.fromJson(item))
          .toList(),
    );
  }

  /// Get transfer by ID (enhanced)
  Future<ApiResponse<FlutterwaveTransfer>> getTransferEnhanced(String transferId) async {
    return await _client.get(
      '/transfers/$transferId',
      fromJson: (data) => FlutterwaveTransfer.fromJson(data),
    );
  }

  /// Update transfer
  Future<ApiResponse<Map<String, dynamic>>> updateTransfer(
    String transferId,
    FlutterwaveTransferUpdateRequest request,
  ) async {
    return await _client.put(
      '/transfers/$transferId',
      data: request.toJson(),
    );
  }

  /// Retry or duplicate transfer
  Future<ApiResponse<FlutterwaveTransfer>> retryTransfer(
    String transferId,
    FlutterwaveTransferRetryRequest request,
  ) async {
    return await _client.post(
      '/transfers/$transferId/retries',
      data: request.toJson(),
      fromJson: (data) => FlutterwaveTransfer.fromJson(data),
    );
  }

  // TRANSFER RECIPIENTS ENDPOINTS

  /// List transfer recipients
  Future<ApiResponse<List<FlutterwaveTransferRecipient>>> listTransferRecipients({
    String? next,
    String? previous,
    int size = 10,
  }) async {
    final queryParams = <String, dynamic>{'size': size};
    if (next != null) queryParams['next'] = next;
    if (previous != null) queryParams['previous'] = previous;

    return await _client.get(
      '/transfers/recipients',
      queryParameters: queryParams,
      fromJson: (data) => (data as List)
          .map((item) => FlutterwaveTransferRecipient.fromJson(item))
          .toList(),
    );
  }

  /// Create transfer recipient
  Future<ApiResponse<FlutterwaveTransferRecipient>> createTransferRecipient(
    FlutterwaveTransferRecipientRequest request,
  ) async {
    return await _client.post(
      '/transfers/recipients',
      data: request.toJson(),
      fromJson: (data) => FlutterwaveTransferRecipient.fromJson(data),
    );
  }

  /// Get transfer recipient by ID
  Future<ApiResponse<FlutterwaveTransferRecipient>> getTransferRecipient(
    String recipientId,
  ) async {
    return await _client.get(
      '/transfers/recipients/$recipientId',
      fromJson: (data) => FlutterwaveTransferRecipient.fromJson(data),
    );
  }

  /// Delete transfer recipient
  Future<ApiResponse<void>> deleteTransferRecipient(String recipientId) async {
    return await _client.delete('/transfers/recipients/$recipientId');
  }

  // TRANSFER SENDERS ENDPOINTS

  /// List transfer senders
  Future<ApiResponse<List<FlutterwaveTransferSender>>> listTransferSenders({
    String? next,
    String? previous,
    int size = 10,
  }) async {
    final queryParams = <String, dynamic>{'size': size};
    if (next != null) queryParams['next'] = next;
    if (previous != null) queryParams['previous'] = previous;

    return await _client.get(
      '/transfers/senders',
      queryParameters: queryParams,
      fromJson: (data) => (data['senders'] as List)
          .map((item) => FlutterwaveTransferSender.fromJson(item))
          .toList(),
    );
  }

  /// Create transfer sender
  Future<ApiResponse<FlutterwaveTransferSender>> createTransferSender(
    FlutterwaveTransferSenderRequest request,
  ) async {
    return await _client.post(
      '/transfers/senders',
      data: request.toJson(),
      fromJson: (data) => FlutterwaveTransferSender.fromJson(data),
    );
  }

  /// Get transfer sender by ID
  Future<ApiResponse<FlutterwaveTransferSender>> getTransferSender(
    String senderId,
  ) async {
    return await _client.get(
      '/transfers/senders/$senderId',
      fromJson: (data) => FlutterwaveTransferSender.fromJson(data),
    );
  }

  /// Delete transfer sender
  Future<ApiResponse<void>> deleteTransferSender(String senderId) async {
    return await _client.delete('/transfers/senders/$senderId');
  }

  // TRANSFER RATES ENDPOINTS

  /// Get transfer rate
  Future<ApiResponse<FlutterwaveTransferRate>> getTransferRate(
    FlutterwaveTransferRateRequest request,
  ) async {
    return await _client.post(
      '/transfers/rates',
      data: request.toJson(),
      fromJson: (data) => FlutterwaveTransferRate.fromJson(data),
    );
  }

  /// Fetch converted rate by ID
  Future<ApiResponse<FlutterwaveTransferRate>> fetchConvertedRate(
    String rateId,
  ) async {
    return await _client.get(
      '/transfers/rates/$rateId',
      fromJson: (data) => FlutterwaveTransferRate.fromJson(data),
    );
  }

  // SETTLEMENTS ENDPOINTS

  /// List settlements
  Future<ApiResponse<List<FlutterwaveSettlement>>> listSettlements({
    int page = 1,
    int size = 10,
    DateTime? from,
    DateTime? to,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'size': size,
    };
    if (from != null) queryParams['from'] = from.toIso8601String();
    if (to != null) queryParams['to'] = to.toIso8601String();

    return await _client.get(
      '/settlements',
      queryParameters: queryParams,
      fromJson: (data) => (data as List)
          .map((item) => FlutterwaveSettlement.fromJson(item))
          .toList(),
    );
  }

  /// Get settlement by ID
  Future<ApiResponse<FlutterwaveSettlement>> getSettlement(
    String settlementId, {
    int page = 1,
    int size = 10,
  }) async {
    return await _client.get(
      '/settlements/$settlementId',
      queryParameters: {
        'page': page,
        'size': size,
      },
      fromJson: (data) => FlutterwaveSettlement.fromJson(data),
    );
  }

  // CHARGEBACKS ENDPOINTS

  /// List chargebacks
  Future<ApiResponse<List<FlutterwaveChargeback>>> listChargebacks({
    int page = 1,
    int size = 10,
    DateTime? from,
    DateTime? to,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'size': size,
    };
    if (from != null) queryParams['from'] = from.toIso8601String();
    if (to != null) queryParams['to'] = to.toIso8601String();

    return await _client.get(
      '/chargebacks',
      queryParameters: queryParams,
      fromJson: (data) => (data as List)
          .map((item) => FlutterwaveChargeback.fromJson(item))
          .toList(),
    );
  }

  /// Create chargeback
  Future<ApiResponse<FlutterwaveChargeback>> createChargeback(
    FlutterwaveChargebackRequest request,
  ) async {
    return await _client.post(
      '/chargebacks',
      data: request.toJson(),
      fromJson: (data) => FlutterwaveChargeback.fromJson(data),
    );
  }

  /// Get chargeback by ID
  Future<ApiResponse<FlutterwaveChargeback>> getChargeback(String chargebackId) async {
    return await _client.get(
      '/chargebacks/$chargebackId',
      fromJson: (data) => FlutterwaveChargeback.fromJson(data),
    );
  }

  /// Update chargeback
  Future<ApiResponse<FlutterwaveChargeback>> updateChargeback(
    String chargebackId, {
    String? status,
    String? uploadedProof,
    String? comment,
    String? provider,
    String? arn,
    DateTime? dueDatetime,
    String? proofData,
  }) async {
    final data = <String, dynamic>{};
    if (status != null) data['status'] = status;
    if (uploadedProof != null) data['uploaded_proof'] = uploadedProof;
    if (comment != null) data['comment'] = comment;
    if (provider != null) data['provider'] = provider;
    if (arn != null) data['arn'] = arn;
    if (dueDatetime != null) data['due_datetime'] = dueDatetime.toIso8601String();
    if (proofData != null) data['proof_data'] = proofData;

    return await _client.put(
      '/chargebacks/$chargebackId',
      data: data,
      fromJson: (data) => FlutterwaveChargeback.fromJson(data),
    );
  }

  // REFUNDS ENDPOINTS

  /// Create refund
  Future<ApiResponse<FlutterwaveRefund>> createRefund(
    FlutterwaveRefundRequest request,
  ) async {
    return await _client.post(
      '/refunds',
      data: request.toJson(),
      fromJson: (data) => FlutterwaveRefund.fromJson(data),
    );
  }

  /// Get refund by ID
  Future<ApiResponse<FlutterwaveRefund>> getRefund(String refundId) async {
    return await _client.get(
      '/refunds/$refundId',
      fromJson: (data) => FlutterwaveRefund.fromJson(data),
    );
  }

  // FEES ENDPOINTS

  /// Get transaction fees
  Future<ApiResponse<Map<String, dynamic>>> getTransactionFees({
    required double amount,
    required String currency,
    required String paymentMethod,
    String? card6,
    String? country,
    String? network,
  }) async {
    final queryParams = <String, dynamic>{
      'amount': amount,
      'currency': currency,
      'payment_method': paymentMethod,
    };
    if (card6 != null) queryParams['card6'] = card6;
    if (country != null) queryParams['country'] = country;
    if (network != null) queryParams['network'] = network;

    return await _client.get(
      '/fees',
      queryParameters: queryParams,
    );
  }

  // ORDERS ENDPOINTS

  /// List orders
  Future<ApiResponse<List<FlutterwaveOrder>>> listOrders({
    String? status,
    DateTime? from,
    DateTime? to,
    String? customerId,
    String? paymentMethodId,
    int page = 1,
    int size = 10,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'size': size,
    };
    if (status != null) queryParams['status'] = status;
    if (from != null) queryParams['from'] = from.toIso8601String();
    if (to != null) queryParams['to'] = to.toIso8601String();
    if (customerId != null) queryParams['customer_id'] = customerId;
    if (paymentMethodId != null) queryParams['payment_method_id'] = paymentMethodId;

    return await _client.get(
      '/orders',
      queryParameters: queryParams,
      fromJson: (data) => (data as List)
          .map((item) => FlutterwaveOrder.fromJson(item))
          .toList(),
    );
  }

  /// Create order
  Future<ApiResponse<FlutterwaveOrder>> createOrder(
    FlutterwaveOrderRequest request,
  ) async {
    return await _client.post(
      '/orders',
      data: request.toJson(),
      fromJson: (data) => FlutterwaveOrder.fromJson(data),
    );
  }

  /// Get order by ID
  Future<ApiResponse<FlutterwaveOrder>> getOrder(String orderId) async {
    return await _client.get(
      '/orders/$orderId',
      fromJson: (data) => FlutterwaveOrder.fromJson(data),
    );
  }

  /// Update order
  Future<ApiResponse<FlutterwaveOrder>> updateOrder(
    String orderId, {
    Map<String, dynamic>? meta,
    String? action,
  }) async {
    final data = <String, dynamic>{};
    if (meta != null) data['meta'] = meta;
    if (action != null) data['action'] = action;

    return await _client.put(
      '/orders/$orderId',
      data: data,
      fromJson: (data) => FlutterwaveOrder.fromJson(data),
    );
  }

  // VIRTUAL ACCOUNTS ENDPOINTS

  /// List virtual accounts
  Future<ApiResponse<List<FlutterwaveVirtualAccount>>> listVirtualAccounts({
    int page = 1,
    int size = 10,
    DateTime? from,
    DateTime? to,
    String? reference,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'size': size,
    };
    if (from != null) queryParams['from'] = from.toIso8601String();
    if (to != null) queryParams['to'] = to.toIso8601String();
    if (reference != null) queryParams['reference'] = reference;

    return await _client.get(
      '/virtual-accounts',
      queryParameters: queryParams,
      fromJson: (data) => (data as List)
          .map((item) => FlutterwaveVirtualAccount.fromJson(item))
          .toList(),
    );
  }

  /// Create virtual account
  Future<ApiResponse<FlutterwaveVirtualAccount>> createVirtualAccount(
    FlutterwaveVirtualAccountRequest request,
  ) async {
    return await _client.post(
      '/virtual-accounts',
      data: request.toJson(),
      fromJson: (data) => FlutterwaveVirtualAccount.fromJson(data),
    );
  }

  /// Get virtual account by ID
  Future<ApiResponse<FlutterwaveVirtualAccount>> getVirtualAccount(String accountId) async {
    return await _client.get(
      '/virtual-accounts/$accountId',
      fromJson: (data) => FlutterwaveVirtualAccount.fromJson(data),
    );
  }

  /// Update virtual account
  Future<ApiResponse<FlutterwaveVirtualAccount>> updateVirtualAccount(
    String accountId,
    FlutterwaveVirtualAccountUpdateRequest request,
  ) async {
    return await _client.put(
      '/virtual-accounts/$accountId',
      data: request.toJson(),
      fromJson: (data) => FlutterwaveVirtualAccount.fromJson(data),
    );
  }
}