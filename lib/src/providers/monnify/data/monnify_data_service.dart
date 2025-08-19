import '../../../core/api_response.dart';
import '../../../models/monnify_models.dart';
import '../monnify_client.dart';

/// Monnify data service for API operations.
class MonnifyDataService {
  final MonnifyClient _client;

  MonnifyDataService(this._client);

  // TRANSACTION ENDPOINTS
  Future<ApiResponse<MonnifyTransaction>> initializeTransaction(
    MonnifyTransactionRequest request,
  ) async {
    return await _client.post(
      '/api/v1/merchant/transactions/init-transaction',
      data: request.toJson(),
      fromJson: (data) => MonnifyTransaction.fromJson(data),
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> payWithBankTransfer({
    required String transactionReference,
    String? bankCode,
  }) async {
    return await _client.post(
      '/api/v1/merchant/bank-transfer/init-payment',
      data: {
        'transactionReference': transactionReference,
        if (bankCode != null) 'bankCode': bankCode,
      },
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> getTransactionStatus(String transactionReference) async {
    final encodedRef = Uri.encodeComponent(transactionReference);
    return await _client.get('/api/v2/transactions/$encodedRef');
  }

  Future<ApiResponse<Map<String, dynamic>>> getAllTransactions({
    int page = 0,
    int size = 10,
    String? paymentReference,
    String? transactionReference,
    double? fromAmount,
    double? toAmount,
    String? customerName,
    String? customerEmail,
    String? paymentStatus,
    int? from,
    int? to,
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'size': size.toString(),
    };
    if (paymentReference != null) queryParams['paymentReference'] = paymentReference;
    if (transactionReference != null) queryParams['transactionReference'] = transactionReference;
    if (fromAmount != null) queryParams['fromAmount'] = fromAmount.toString();
    if (toAmount != null) queryParams['toAmount'] = toAmount.toString();
    if (customerName != null) queryParams['customerName'] = customerName;
    if (customerEmail != null) queryParams['customerEmail'] = customerEmail;
    if (paymentStatus != null) queryParams['paymentStatus'] = paymentStatus;
    if (from != null) queryParams['from'] = from.toString();
    if (to != null) queryParams['to'] = to.toString();

    return await _client.get('/api/v1/transactions/search', queryParameters: queryParams);
  }

  // RESERVED ACCOUNT ENDPOINTS
  Future<ApiResponse<MonnifyReservedAccount>> createReservedAccount(
    MonnifyReservedAccountRequest request,
  ) async {
    return await _client.post(
      '/api/v2/bank-transfer/reserved-accounts',
      data: request.toJson(),
      fromJson: (data) => MonnifyReservedAccount.fromJson(data),
    );
  }

  Future<ApiResponse<MonnifyReservedAccount>> getReservedAccount(String accountReference) async {
    return await _client.get(
      '/api/v2/bank-transfer/reserved-accounts/$accountReference',
      fromJson: (data) => MonnifyReservedAccount.fromJson(data),
    );
  }

  // TRANSFER ENDPOINTS
  Future<ApiResponse<MonnifyTransfer>> initiateSingleTransfer(
    MonnifyTransferRequest request,
  ) async {
    return await _client.post(
      '/api/v2/disbursements/single',
      data: request.toJson(),
      fromJson: (data) => MonnifyTransfer.fromJson(data),
    );
  }

  Future<ApiResponse<MonnifyWalletBalance>> getWalletBalance(String accountNumber) async {
    return await _client.get(
      '/api/v2/disbursements/wallet-balance',
      queryParameters: {'accountNumber': accountNumber},
      fromJson: (data) => MonnifyWalletBalance.fromJson(data),
    );
  }

  // BANK ENDPOINTS
  Future<ApiResponse<List<MonnifyBank>>> getBanks() async {
    return await _client.get(
      '/api/v1/banks',
      fromJson: (data) => (data as List).map((e) => MonnifyBank.fromJson(e)).toList(),
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> validateBankAccount({
    required String accountNumber,
    required String bankCode,
  }) async {
    return await _client.get(
      '/api/v1/disbursements/account/validate',
      queryParameters: {
        'accountNumber': accountNumber,
        'bankCode': bankCode,
      },
    );
  }
}