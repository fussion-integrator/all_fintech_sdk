import '../../../core/api_response.dart';
import '../../../models/transaction.dart';
import '../../../models/payment_request.dart';
import '../../../models/customer.dart';
import '../../../models/subscription.dart';
import '../../../models/product.dart';
import '../../../models/transfer_recipient.dart';
import '../../../models/transfer.dart';
import '../../../models/verification.dart';
import '../paystack_client.dart';

class PaystackDataService {
  final PaystackClient _client;

  PaystackDataService(this._client);

  // TRANSACTION ENDPOINTS

  /// Initialize a transaction
  Future<ApiResponse<Map<String, dynamic>>> initializeTransaction(
    PaymentRequest request,
  ) async {
    return await _client.post(
      '/transaction/initialize',
      data: request.toJson(),
    );
  }

  /// Verify a transaction
  Future<ApiResponse<Transaction>> verifyTransaction(String reference) async {
    return await _client.get(
      '/transaction/verify/$reference',
      fromJson: (data) => Transaction.fromJson(data),
    );
  }

  /// List transactions
  Future<ApiResponse<List<Transaction>>> listTransactions({
    int page = 1,
    int perPage = 50,
    String? customer,
    String? terminalId,
    String? status,
    DateTime? from,
    DateTime? to,
    int? amount,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'perPage': perPage,
    };

    if (customer != null) queryParams['customer'] = customer;
    if (terminalId != null) queryParams['terminalid'] = terminalId;
    if (status != null) queryParams['status'] = status;
    if (from != null) queryParams['from'] = from.toIso8601String();
    if (to != null) queryParams['to'] = to.toIso8601String();
    if (amount != null) queryParams['amount'] = amount;

    return await _client.get(
      '/transaction',
      queryParameters: queryParams,
      fromJson: (data) => (data as List)
          .map((item) => Transaction.fromJson(item))
          .toList(),
    );
  }

  /// Fetch transaction by ID
  Future<ApiResponse<Transaction>> fetchTransaction(int transactionId) async {
    return await _client.get(
      '/transaction/$transactionId',
      fromJson: (data) => Transaction.fromJson(data),
    );
  }

  /// Charge authorization
  Future<ApiResponse<Transaction>> chargeAuthorization(
    ChargeRequest request,
  ) async {
    return await _client.post(
      '/transaction/charge_authorization',
      data: request.toJson(),
      fromJson: (data) => Transaction.fromJson(data),
    );
  }

  /// View transaction timeline
  Future<ApiResponse<Map<String, dynamic>>> getTransactionTimeline(
    String idOrReference,
  ) async {
    return await _client.get('/transaction/timeline/$idOrReference');
  }

  /// Get transaction totals
  Future<ApiResponse<Map<String, dynamic>>> getTransactionTotals({
    int page = 1,
    int perPage = 50,
    DateTime? from,
    DateTime? to,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'perPage': perPage,
    };

    if (from != null) queryParams['from'] = from.toIso8601String();
    if (to != null) queryParams['to'] = to.toIso8601String();

    return await _client.get(
      '/transaction/totals',
      queryParameters: queryParams,
    );
  }

  /// Export transactions
  Future<ApiResponse<Map<String, dynamic>>> exportTransactions({
    int page = 1,
    int perPage = 50,
    DateTime? from,
    DateTime? to,
    String? customer,
    String? status,
    String? currency,
    int? amount,
    bool? settled,
    int? settlement,
    int? paymentPage,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'perPage': perPage,
    };

    if (from != null) queryParams['from'] = from.toIso8601String();
    if (to != null) queryParams['to'] = to.toIso8601String();
    if (customer != null) queryParams['customer'] = customer;
    if (status != null) queryParams['status'] = status;
    if (currency != null) queryParams['currency'] = currency;
    if (amount != null) queryParams['amount'] = amount;
    if (settled != null) queryParams['settled'] = settled;
    if (settlement != null) queryParams['settlement'] = settlement;
    if (paymentPage != null) queryParams['payment_page'] = paymentPage;

    return await _client.get(
      '/transaction/export',
      queryParameters: queryParams,
    );
  }

  /// Partial debit
  Future<ApiResponse<Transaction>> partialDebit({
    required String authorizationCode,
    required String currency,
    required int amount,
    required String email,
    String? reference,
    int? atLeast,
  }) async {
    final data = {
      'authorization_code': authorizationCode,
      'currency': currency,
      'amount': amount.toString(),
      'email': email,
    };

    if (reference != null) data['reference'] = reference;
    if (atLeast != null) data['at_least'] = atLeast.toString();

    return await _client.post(
      '/transaction/partial_debit',
      data: data,
      fromJson: (data) => Transaction.fromJson(data),
    );
  }

  // CHARGE ENDPOINTS

  /// Charge card (for direct card charges)
  Future<ApiResponse<Transaction>> chargeCard({
    required String email,
    required int amount,
    required String cardNumber,
    required String expiryMonth,
    required String expiryYear,
    required String cvv,
    String currency = 'NGN',
    String? pin,
    Map<String, dynamic>? metadata,
  }) async {
    final data = {
      'email': email,
      'amount': amount,
      'card': {
        'number': cardNumber,
        'cvv': cvv,
        'expiry_month': expiryMonth,
        'expiry_year': expiryYear,
      },
      'currency': currency,
    };

    if (pin != null) data['pin'] = pin;
    if (metadata != null) data['metadata'] = metadata;

    return await _client.post(
      '/charge',
      data: data,
      fromJson: (data) => Transaction.fromJson(data),
    );
  }

  /// Submit PIN for card charge
  Future<ApiResponse<Transaction>> submitPin({
    required String reference,
    required String pin,
  }) async {
    return await _client.post(
      '/charge/submit_pin',
      data: {
        'reference': reference,
        'pin': pin,
      },
      fromJson: (data) => Transaction.fromJson(data),
    );
  }

  /// Submit OTP for card charge
  Future<ApiResponse<Transaction>> submitOtp({
    required String reference,
    required String otp,
  }) async {
    return await _client.post(
      '/charge/submit_otp',
      data: {
        'reference': reference,
        'otp': otp,
      },
      fromJson: (data) => Transaction.fromJson(data),
    );
  }

  /// Submit phone for card charge
  Future<ApiResponse<Transaction>> submitPhone({
    required String reference,
    required String phone,
  }) async {
    return await _client.post(
      '/charge/submit_phone',
      data: {
        'reference': reference,
        'phone': phone,
      },
      fromJson: (data) => Transaction.fromJson(data),
    );
  }

  /// Submit birthday for card charge
  Future<ApiResponse<Transaction>> submitBirthday({
    required String reference,
    required String birthday,
  }) async {
    return await _client.post(
      '/charge/submit_birthday',
      data: {
        'reference': reference,
        'birthday': birthday,
      },
      fromJson: (data) => Transaction.fromJson(data),
    );
  }

  /// Check pending charge
  Future<ApiResponse<Transaction>> checkPendingCharge(String reference) async {
    return await _client.get(
      '/charge/$reference',
      fromJson: (data) => Transaction.fromJson(data),
    );
  }

  // CUSTOMER ENDPOINTS

  /// Create customer
  Future<ApiResponse<Customer>> createCustomer(
    CustomerRequest request,
  ) async {
    return await _client.post(
      '/customer',
      data: request.toJson(),
      fromJson: (data) => Customer.fromJson(data),
    );
  }

  /// List customers
  Future<ApiResponse<List<Customer>>> listCustomers({
    int page = 1,
    int perPage = 50,
    DateTime? from,
    DateTime? to,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'perPage': perPage,
    };

    if (from != null) queryParams['from'] = from.toIso8601String();
    if (to != null) queryParams['to'] = to.toIso8601String();

    return await _client.get(
      '/customer',
      queryParameters: queryParams,
      fromJson: (data) => (data as List)
          .map((item) => Customer.fromJson(item))
          .toList(),
    );
  }

  /// Fetch customer
  Future<ApiResponse<Customer>> fetchCustomer(String emailOrCode) async {
    return await _client.get(
      '/customer/$emailOrCode',
      fromJson: (data) => Customer.fromJson(data),
    );
  }

  /// Update customer
  Future<ApiResponse<Customer>> updateCustomer(
    String customerCode,
    CustomerRequest request,
  ) async {
    return await _client.put(
      '/customer/$customerCode',
      data: request.toJson(),
      fromJson: (data) => Customer.fromJson(data),
    );
  }

  /// Whitelist/Blacklist customer
  Future<ApiResponse<Customer>> setCustomerRiskAction({
    required String customer,
    required String riskAction, // 'default', 'allow', 'deny'
  }) async {
    return await _client.post(
      '/customer/set_risk_action',
      data: {
        'customer': customer,
        'risk_action': riskAction,
      },
      fromJson: (data) => Customer.fromJson(data),
    );
  }

  /// Deactivate authorization
  Future<ApiResponse<Map<String, dynamic>>> deactivateAuthorization(
    String authorizationCode,
  ) async {
    return await _client.post(
      '/customer/authorization/deactivate',
      data: {
        'authorization_code': authorizationCode,
      },
    );
  }

  // DEDICATED VIRTUAL ACCOUNT ENDPOINTS

  /// Create dedicated virtual account
  Future<ApiResponse<Map<String, dynamic>>> createDedicatedAccount(
    DedicatedAccountRequest request,
  ) async {
    return await _client.post(
      '/dedicated_account',
      data: request.toJson(),
    );
  }

  /// List dedicated virtual accounts
  Future<ApiResponse<List<Map<String, dynamic>>>> listDedicatedAccounts({
    bool? active,
    String? currency,
    String? providerSlug,
    String? bankId,
    String? customer,
  }) async {
    final queryParams = <String, dynamic>{};

    if (active != null) queryParams['active'] = active;
    if (currency != null) queryParams['currency'] = currency;
    if (providerSlug != null) queryParams['provider_slug'] = providerSlug;
    if (bankId != null) queryParams['bank_id'] = bankId;
    if (customer != null) queryParams['customer'] = customer;

    return await _client.get(
      '/dedicated_account',
      queryParameters: queryParams,
      fromJson: (data) => List<Map<String, dynamic>>.from(data),
    );
  }

  /// Fetch dedicated virtual account
  Future<ApiResponse<Map<String, dynamic>>> fetchDedicatedAccount(
    int dedicatedAccountId,
  ) async {
    return await _client.get('/dedicated_account/$dedicatedAccountId');
  }

  /// Requery dedicated account
  Future<ApiResponse<Map<String, dynamic>>> requeryDedicatedAccount({
    required String accountNumber,
    required String providerSlug,
    String? date,
  }) async {
    final queryParams = {
      'account_number': accountNumber,
      'provider_slug': providerSlug,
    };

    if (date != null) queryParams['date'] = date;

    return await _client.get(
      '/dedicated_account/requery',
      queryParameters: queryParams,
    );
  }

  /// Get available bank providers
  Future<ApiResponse<List<Map<String, dynamic>>>> getBankProviders() async {
    return await _client.get(
      '/dedicated_account/available_providers',
      fromJson: (data) => List<Map<String, dynamic>>.from(data),
    );
  }

  // APPLE PAY ENDPOINTS

  /// Register Apple Pay domain
  Future<ApiResponse<Map<String, dynamic>>> registerApplePayDomain(
    String domainName,
  ) async {
    return await _client.post(
      '/apple-pay/domain',
      data: {'domainName': domainName},
    );
  }

  /// List Apple Pay domains
  Future<ApiResponse<Map<String, dynamic>>> listApplePayDomains({
    bool? useCursor,
    String? next,
    String? previous,
  }) async {
    final queryParams = <String, dynamic>{};
    if (useCursor != null) queryParams['use_cursor'] = useCursor;
    if (next != null) queryParams['next'] = next;
    if (previous != null) queryParams['previous'] = previous;

    return await _client.get(
      '/apple-pay/domain',
      queryParameters: queryParams,
    );
  }

  /// Unregister Apple Pay domain
  Future<ApiResponse<Map<String, dynamic>>> unregisterApplePayDomain(
    String domainName,
  ) async {
    return await _client.delete(
      '/apple-pay/domain',
      data: {'domainName': domainName},
    );
  }

  // PLANS ENDPOINTS

  /// Create plan
  Future<ApiResponse<Plan>> createPlan(PlanRequest request) async {
    return await _client.post(
      '/plan',
      data: request.toJson(),
      fromJson: (data) => Plan.fromJson(data),
    );
  }

  /// List plans
  Future<ApiResponse<List<Plan>>> listPlans({
    int page = 1,
    int perPage = 50,
    String? status,
    String? interval,
    int? amount,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'perPage': perPage,
    };

    if (status != null) queryParams['status'] = status;
    if (interval != null) queryParams['interval'] = interval;
    if (amount != null) queryParams['amount'] = amount;

    return await _client.get(
      '/plan',
      queryParameters: queryParams,
      fromJson: (data) => (data as List)
          .map((item) => Plan.fromJson(item))
          .toList(),
    );
  }

  /// Fetch plan
  Future<ApiResponse<Plan>> fetchPlan(String idOrCode) async {
    return await _client.get(
      '/plan/$idOrCode',
      fromJson: (data) => Plan.fromJson(data),
    );
  }

  /// Update plan
  Future<ApiResponse<Map<String, dynamic>>> updatePlan(
    String idOrCode,
    PlanRequest request,
  ) async {
    return await _client.put(
      '/plan/$idOrCode',
      data: request.toJson(),
    );
  }

  // SUBSCRIPTIONS ENDPOINTS

  /// Create subscription
  Future<ApiResponse<Subscription>> createSubscription(
    SubscriptionRequest request,
  ) async {
    return await _client.post(
      '/subscription',
      data: request.toJson(),
      fromJson: (data) => Subscription.fromJson(data),
    );
  }

  /// List subscriptions
  Future<ApiResponse<List<Subscription>>> listSubscriptions({
    int page = 1,
    int perPage = 50,
    int? customer,
    int? plan,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'perPage': perPage,
    };

    if (customer != null) queryParams['customer'] = customer;
    if (plan != null) queryParams['plan'] = plan;

    return await _client.get(
      '/subscription',
      queryParameters: queryParams,
      fromJson: (data) => (data as List)
          .map((item) => Subscription.fromJson(item))
          .toList(),
    );
  }

  /// Fetch subscription
  Future<ApiResponse<Subscription>> fetchSubscription(String idOrCode) async {
    return await _client.get(
      '/subscription/$idOrCode',
      fromJson: (data) => Subscription.fromJson(data),
    );
  }

  /// Enable subscription
  Future<ApiResponse<Map<String, dynamic>>> enableSubscription({
    required String code,
    required String token,
  }) async {
    return await _client.post(
      '/subscription/enable',
      data: {
        'code': code,
        'token': token,
      },
    );
  }

  /// Disable subscription
  Future<ApiResponse<Map<String, dynamic>>> disableSubscription({
    required String code,
    required String token,
  }) async {
    return await _client.post(
      '/subscription/disable',
      data: {
        'code': code,
        'token': token,
      },
    );
  }

  /// Generate subscription update link
  Future<ApiResponse<Map<String, dynamic>>> generateSubscriptionUpdateLink(
    String code,
  ) async {
    return await _client.get('/subscription/$code/manage/link');
  }

  /// Send subscription update link
  Future<ApiResponse<Map<String, dynamic>>> sendSubscriptionUpdateLink(
    String code,
  ) async {
    return await _client.post('/subscription/$code/manage/email');
  }

  // PRODUCTS ENDPOINTS

  /// Create product
  Future<ApiResponse<Product>> createProduct(ProductRequest request) async {
    return await _client.post(
      '/product',
      data: request.toJson(),
      fromJson: (data) => Product.fromJson(data),
    );
  }

  /// List products
  Future<ApiResponse<List<Product>>> listProducts({
    int page = 1,
    int perPage = 50,
    DateTime? from,
    DateTime? to,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'perPage': perPage,
    };

    if (from != null) queryParams['from'] = from.toIso8601String();
    if (to != null) queryParams['to'] = to.toIso8601String();

    return await _client.get(
      '/product',
      queryParameters: queryParams,
      fromJson: (data) => (data as List)
          .map((item) => Product.fromJson(item))
          .toList(),
    );
  }

  /// Fetch product
  Future<ApiResponse<Product>> fetchProduct(String id) async {
    return await _client.get(
      '/product/$id',
      fromJson: (data) => Product.fromJson(data),
    );
  }

  /// Update product
  Future<ApiResponse<Product>> updateProduct(
    String id,
    ProductRequest request,
  ) async {
    return await _client.put(
      '/product/$id',
      data: request.toJson(),
      fromJson: (data) => Product.fromJson(data),
    );
  }

  // PAYMENT PAGES ENDPOINTS

  /// Create payment page
  Future<ApiResponse<PaymentPage>> createPaymentPage(
    PaymentPageRequest request,
  ) async {
    return await _client.post(
      '/page',
      data: request.toJson(),
      fromJson: (data) => PaymentPage.fromJson(data),
    );
  }

  /// List payment pages
  Future<ApiResponse<List<PaymentPage>>> listPaymentPages({
    int page = 1,
    int perPage = 50,
    DateTime? from,
    DateTime? to,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'perPage': perPage,
    };

    if (from != null) queryParams['from'] = from.toIso8601String();
    if (to != null) queryParams['to'] = to.toIso8601String();

    return await _client.get(
      '/page',
      queryParameters: queryParams,
      fromJson: (data) => (data as List)
          .map((item) => PaymentPage.fromJson(item))
          .toList(),
    );
  }

  /// Fetch payment page
  Future<ApiResponse<PaymentPage>> fetchPaymentPage(String idOrSlug) async {
    return await _client.get(
      '/page/$idOrSlug',
      fromJson: (data) => PaymentPage.fromJson(data),
    );
  }

  /// Update payment page
  Future<ApiResponse<PaymentPage>> updatePaymentPage(
    String idOrSlug,
    PaymentPageRequest request,
  ) async {
    return await _client.put(
      '/page/$idOrSlug',
      data: request.toJson(),
      fromJson: (data) => PaymentPage.fromJson(data),
    );
  }

  /// Check slug availability
  Future<ApiResponse<Map<String, dynamic>>> checkSlugAvailability(
    String slug,
  ) async {
    return await _client.get('/page/check_slug_availability/$slug');
  }

  // SUBACCOUNTS ENDPOINTS

  /// Create subaccount
  Future<ApiResponse<Subaccount>> createSubaccount(
    SubaccountRequest request,
  ) async {
    return await _client.post(
      '/subaccount',
      data: request.toJson(),
      fromJson: (data) => Subaccount.fromJson(data),
    );
  }

  /// List subaccounts
  Future<ApiResponse<List<Subaccount>>> listSubaccounts({
    int page = 1,
    int perPage = 50,
    DateTime? from,
    DateTime? to,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'perPage': perPage,
    };

    if (from != null) queryParams['from'] = from.toIso8601String();
    if (to != null) queryParams['to'] = to.toIso8601String();

    return await _client.get(
      '/subaccount',
      queryParameters: queryParams,
      fromJson: (data) => (data as List)
          .map((item) => Subaccount.fromJson(item))
          .toList(),
    );
  }

  /// Fetch subaccount
  Future<ApiResponse<Subaccount>> fetchSubaccount(String idOrCode) async {
    return await _client.get(
      '/subaccount/$idOrCode',
      fromJson: (data) => Subaccount.fromJson(data),
    );
  }

  /// Update subaccount
  Future<ApiResponse<Subaccount>> updateSubaccount(
    String idOrCode,
    SubaccountRequest request,
  ) async {
    return await _client.put(
      '/subaccount/$idOrCode',
      data: request.toJson(),
      fromJson: (data) => Subaccount.fromJson(data),
    );
  }

  // SETTLEMENTS ENDPOINTS

  /// List settlements
  Future<ApiResponse<List<Map<String, dynamic>>>> listSettlements({
    int page = 1,
    int perPage = 50,
    String? status,
    String? subaccount,
    DateTime? from,
    DateTime? to,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'perPage': perPage,
    };

    if (status != null) queryParams['status'] = status;
    if (subaccount != null) queryParams['subaccount'] = subaccount;
    if (from != null) queryParams['from'] = from.toIso8601String();
    if (to != null) queryParams['to'] = to.toIso8601String();

    return await _client.get(
      '/settlement',
      queryParameters: queryParams,
      fromJson: (data) => List<Map<String, dynamic>>.from(data),
    );
  }

  /// List settlement transactions
  Future<ApiResponse<List<Transaction>>> listSettlementTransactions(
    String settlementId, {
    int page = 1,
    int perPage = 50,
    DateTime? from,
    DateTime? to,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'perPage': perPage,
    };

    if (from != null) queryParams['from'] = from.toIso8601String();
    if (to != null) queryParams['to'] = to.toIso8601String();

    return await _client.get(
      '/settlement/$settlementId/transactions',
      queryParameters: queryParams,
      fromJson: (data) => (data as List)
          .map((item) => Transaction.fromJson(item))
          .toList(),
    );
  }

  // TRANSFER RECIPIENTS ENDPOINTS

  /// Create transfer recipient
  Future<ApiResponse<TransferRecipient>> createTransferRecipient(
    TransferRecipientRequest request,
  ) async {
    return await _client.post(
      '/transferrecipient',
      data: request.toJson(),
      fromJson: (data) => TransferRecipient.fromJson(data),
    );
  }

  /// Bulk create transfer recipients
  Future<ApiResponse<Map<String, dynamic>>> bulkCreateTransferRecipients(
    BulkTransferRecipientRequest request,
  ) async {
    return await _client.post(
      '/transferrecipient/bulk',
      data: request.toJson(),
    );
  }

  /// List transfer recipients
  Future<ApiResponse<List<TransferRecipient>>> listTransferRecipients({
    int page = 1,
    int perPage = 50,
    DateTime? from,
    DateTime? to,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'perPage': perPage,
    };

    if (from != null) queryParams['from'] = from.toIso8601String();
    if (to != null) queryParams['to'] = to.toIso8601String();

    return await _client.get(
      '/transferrecipient',
      queryParameters: queryParams,
      fromJson: (data) => (data as List)
          .map((item) => TransferRecipient.fromJson(item))
          .toList(),
    );
  }

  /// Fetch transfer recipient
  Future<ApiResponse<TransferRecipient>> fetchTransferRecipient(
    String idOrCode,
  ) async {
    return await _client.get(
      '/transferrecipient/$idOrCode',
      fromJson: (data) => TransferRecipient.fromJson(data),
    );
  }

  /// Update transfer recipient
  Future<ApiResponse<TransferRecipient>> updateTransferRecipient(
    String idOrCode, {
    required String name,
    String? email,
  }) async {
    final data = {'name': name};
    if (email != null) data['email'] = email;

    return await _client.put(
      '/transferrecipient/$idOrCode',
      data: data,
      fromJson: (data) => TransferRecipient.fromJson(data),
    );
  }

  /// Delete transfer recipient
  Future<ApiResponse<Map<String, dynamic>>> deleteTransferRecipient(
    String idOrCode,
  ) async {
    return await _client.delete('/transferrecipient/$idOrCode');
  }

  // TRANSFERS ENDPOINTS

  /// Initiate transfer
  Future<ApiResponse<Transfer>> initiateTransfer(
    TransferRequest request,
  ) async {
    return await _client.post(
      '/transfer',
      data: request.toJson(),
      fromJson: (data) => Transfer.fromJson(data),
    );
  }

  /// Finalize transfer
  Future<ApiResponse<Transfer>> finalizeTransfer({
    required String transferCode,
    required String otp,
  }) async {
    return await _client.post(
      '/transfer/finalize_transfer',
      data: {
        'transfer_code': transferCode,
        'otp': otp,
      },
      fromJson: (data) => Transfer.fromJson(data),
    );
  }

  /// Initiate bulk transfer
  Future<ApiResponse<List<Map<String, dynamic>>>> initiateBulkTransfer(
    BulkTransferRequest request,
  ) async {
    return await _client.post(
      '/transfer/bulk',
      data: request.toJson(),
      fromJson: (data) => List<Map<String, dynamic>>.from(data),
    );
  }

  /// List transfers
  Future<ApiResponse<List<Transfer>>> listTransfers({
    int page = 1,
    int perPage = 50,
    int? recipient,
    DateTime? from,
    DateTime? to,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'perPage': perPage,
    };

    if (recipient != null) queryParams['recipient'] = recipient;
    if (from != null) queryParams['from'] = from.toIso8601String();
    if (to != null) queryParams['to'] = to.toIso8601String();

    return await _client.get(
      '/transfer',
      queryParameters: queryParams,
      fromJson: (data) => (data as List)
          .map((item) => Transfer.fromJson(item))
          .toList(),
    );
  }

  /// Fetch transfer
  Future<ApiResponse<Transfer>> fetchTransfer(String idOrCode) async {
    return await _client.get(
      '/transfer/$idOrCode',
      fromJson: (data) => Transfer.fromJson(data),
    );
  }

  /// Verify transfer
  Future<ApiResponse<Transfer>> verifyTransfer(String reference) async {
    return await _client.get(
      '/transfer/verify/$reference',
      fromJson: (data) => Transfer.fromJson(data),
    );
  }

  // TRANSFERS CONTROL ENDPOINTS

  /// Check balance
  Future<ApiResponse<List<Map<String, dynamic>>>> checkBalance() async {
    return await _client.get(
      '/balance',
      fromJson: (data) => List<Map<String, dynamic>>.from(data),
    );
  }

  /// Fetch balance ledger
  Future<ApiResponse<List<Map<String, dynamic>>>> fetchBalanceLedger() async {
    return await _client.get(
      '/balance/ledger',
      fromJson: (data) => List<Map<String, dynamic>>.from(data),
    );
  }

  /// Resend OTP
  Future<ApiResponse<Map<String, dynamic>>> resendOtp({
    required String transferCode,
    required String reason,
  }) async {
    return await _client.post(
      '/transfer/resend_otp',
      data: {
        'transfer_code': transferCode,
        'reason': reason,
      },
    );
  }

  /// Disable OTP
  Future<ApiResponse<Map<String, dynamic>>> disableOtp() async {
    return await _client.post('/transfer/disable_otp');
  }

  /// Finalize disable OTP
  Future<ApiResponse<Map<String, dynamic>>> finalizeDisableOtp(
    String otp,
  ) async {
    return await _client.post(
      '/transfer/disable_otp_finalize',
      data: {'otp': otp},
    );
  }

  /// Enable OTP
  Future<ApiResponse<Map<String, dynamic>>> enableOtp() async {
    return await _client.post('/transfer/enable_otp');
  }

  // BULK CHARGES ENDPOINTS

  /// Initiate bulk charge
  Future<ApiResponse<Map<String, dynamic>>> initiateBulkCharge(
    BulkChargeRequest request,
  ) async {
    return await _client.post(
      '/bulkcharge',
      data: request.toJson(),
    );
  }

  /// List bulk charge batches
  Future<ApiResponse<List<Map<String, dynamic>>>> listBulkChargeBatches({
    int page = 1,
    int perPage = 50,
    DateTime? from,
    DateTime? to,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'perPage': perPage,
    };

    if (from != null) queryParams['from'] = from.toIso8601String();
    if (to != null) queryParams['to'] = to.toIso8601String();

    return await _client.get(
      '/bulkcharge',
      queryParameters: queryParams,
      fromJson: (data) => List<Map<String, dynamic>>.from(data),
    );
  }

  /// Fetch bulk charge batch
  Future<ApiResponse<Map<String, dynamic>>> fetchBulkChargeBatch(
    String idOrCode,
  ) async {
    return await _client.get('/bulkcharge/$idOrCode');
  }

  /// Pause bulk charge batch
  Future<ApiResponse<Map<String, dynamic>>> pauseBulkChargeBatch(
    String batchCode,
  ) async {
    return await _client.get('/bulkcharge/pause/$batchCode');
  }

  /// Resume bulk charge batch
  Future<ApiResponse<Map<String, dynamic>>> resumeBulkChargeBatch(
    String batchCode,
  ) async {
    return await _client.get('/bulkcharge/resume/$batchCode');
  }

  // DISPUTES ENDPOINTS

  /// List disputes
  Future<ApiResponse<List<Map<String, dynamic>>>> listDisputes({
    int page = 1,
    int perPage = 50,
    DateTime? from,
    DateTime? to,
    String? transaction,
    String? status,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'perPage': perPage,
    };

    if (from != null) queryParams['from'] = from.toIso8601String();
    if (to != null) queryParams['to'] = to.toIso8601String();
    if (transaction != null) queryParams['transaction'] = transaction;
    if (status != null) queryParams['status'] = status;

    return await _client.get(
      '/dispute',
      queryParameters: queryParams,
      fromJson: (data) => List<Map<String, dynamic>>.from(data),
    );
  }

  /// Fetch dispute
  Future<ApiResponse<Map<String, dynamic>>> fetchDispute(String id) async {
    return await _client.get('/dispute/$id');
  }

  /// Update dispute
  Future<ApiResponse<Map<String, dynamic>>> updateDispute(
    String id, {
    required int refundAmount,
    String? uploadedFilename,
  }) async {
    final data = {'refund_amount': refundAmount};
    if (uploadedFilename != null) data['uploaded_filename'] = uploadedFilename;

    return await _client.put('/dispute/$id', data: data);
  }

  // REFUNDS ENDPOINTS

  /// Create refund
  Future<ApiResponse<Map<String, dynamic>>> createRefund({
    required String transaction,
    int? amount,
    String? currency,
    String? customerNote,
    String? merchantNote,
  }) async {
    final data = {'transaction': transaction};
    if (amount != null) data['amount'] = amount;
    if (currency != null) data['currency'] = currency;
    if (customerNote != null) data['customer_note'] = customerNote;
    if (merchantNote != null) data['merchant_note'] = merchantNote;

    return await _client.post('/refund', data: data);
  }

  /// List refunds
  Future<ApiResponse<List<Map<String, dynamic>>>> listRefunds({
    int page = 1,
    int perPage = 50,
    String? transaction,
    String? currency,
    DateTime? from,
    DateTime? to,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'perPage': perPage,
    };

    if (transaction != null) queryParams['transaction'] = transaction;
    if (currency != null) queryParams['currency'] = currency;
    if (from != null) queryParams['from'] = from.toIso8601String();
    if (to != null) queryParams['to'] = to.toIso8601String();

    return await _client.get(
      '/refund',
      queryParameters: queryParams,
      fromJson: (data) => List<Map<String, dynamic>>.from(data),
    );
  }

  /// Fetch refund
  Future<ApiResponse<Map<String, dynamic>>> fetchRefund(String id) async {
    return await _client.get('/refund/$id');
  }

  // VERIFICATION ENDPOINTS

  /// Resolve account
  Future<ApiResponse<AccountResolution>> resolveAccount(
    String accountNumber,
    String bankCode,
  ) async {
    return await _client.get(
      '/bank/resolve',
      queryParameters: {
        'account_number': accountNumber,
        'bank_code': bankCode,
      },
      fromJson: (data) => AccountResolution.fromJson(data),
    );
  }

  /// Validate account
  Future<ApiResponse<AccountValidation>> validateAccount(
    AccountValidationRequest request,
  ) async {
    return await _client.post(
      '/bank/validate',
      data: request.toJson(),
      fromJson: (data) => AccountValidation.fromJson(data),
    );
  }

  /// Resolve card BIN
  Future<ApiResponse<CardBin>> resolveCardBin(String bin) async {
    return await _client.get(
      '/decision/bin/$bin',
      fromJson: (data) => CardBin.fromJson(data),
    );
  }

  // MISCELLANEOUS ENDPOINTS

  /// List banks
  Future<ApiResponse<List<Bank>>> listBanks({
    String? country,
    bool? useCursor,
    int? perPage,
    bool? payWithBankTransfer,
    bool? payWithBank,
    bool? enabledForVerification,
    String? next,
    String? previous,
    String? gateway,
    String? type,
    String? currency,
    bool? includeNipSortCode,
  }) async {
    final queryParams = <String, dynamic>{};
    if (country != null) queryParams['country'] = country;
    if (useCursor != null) queryParams['use_cursor'] = useCursor;
    if (perPage != null) queryParams['perPage'] = perPage;
    if (payWithBankTransfer != null) queryParams['pay_with_bank_transfer'] = payWithBankTransfer;
    if (payWithBank != null) queryParams['pay_with_bank'] = payWithBank;
    if (enabledForVerification != null) queryParams['enabled_for_verification'] = enabledForVerification;
    if (next != null) queryParams['next'] = next;
    if (previous != null) queryParams['previous'] = previous;
    if (gateway != null) queryParams['gateway'] = gateway;
    if (type != null) queryParams['type'] = type;
    if (currency != null) queryParams['currency'] = currency;
    if (includeNipSortCode != null) queryParams['include_nip_sort_code'] = includeNipSortCode;

    return await _client.get(
      '/bank',
      queryParameters: queryParams,
      fromJson: (data) => (data as List)
          .map((item) => Bank.fromJson(item))
          .toList(),
    );
  }

  /// List countries
  Future<ApiResponse<List<Country>>> listCountries() async {
    return await _client.get(
      '/country',
      fromJson: (data) => (data as List)
          .map((item) => Country.fromJson(item))
          .toList(),
    );
  }

  /// List states (AVS)
  Future<ApiResponse<List<State>>> listStates(String country) async {
    return await _client.get(
      '/address_verification/states',
      queryParameters: {'country': country},
      fromJson: (data) => (data as List)
          .map((item) => State.fromJson(item))
          .toList(),
    );
  }
}