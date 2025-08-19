import '../models/open_banking_models.dart';
import 'open_banking_client.dart';

/// Open Banking data service for API operations.
class OpenBankingDataService {
  final OpenBankingClient _client;

  OpenBankingDataService(this._client);

  Future<List<OpenBankingSavings>> getSavings({String? consentToken}) async {
    final response = await _client.getSavings(consentToken: consentToken);
    
    final openBankingResponse = OpenBankingResponse.fromJson(
      response,
      (data) => data,
    );

    if (openBankingResponse.status != '00') {
      throw Exception(openBankingResponse.message);
    }

    final savingsData = openBankingResponse.data['savings'] as List;
    return savingsData
        .map((savings) => OpenBankingSavings.fromJson(savings))
        .toList();
  }

  Future<OpenBankingPaginatedResponse<OpenBankingTransaction>>
      getSavingsTransactions(
    String savingsId, {
    String? from,
    String? to,
    int? page,
    String? consentToken,
  }) async {
    final response = await _client.getSavingsTransactions(
      savingsId,
      from: from,
      to: to,
      page: page,
      consentToken: consentToken,
    );

    final openBankingResponse = OpenBankingResponse.fromJson(
      response,
      (data) => data,
    );

    if (openBankingResponse.status != '00') {
      throw Exception(openBankingResponse.message);
    }

    return OpenBankingPaginatedResponse.fromJson(
      openBankingResponse.data,
      (json) => OpenBankingTransaction.fromJson(json),
    );
  }

  Future<List<OpenBankingAccount>> getAccounts({String? consentToken}) async {
    final response = await _client.getAccounts(consentToken: consentToken);
    
    final openBankingResponse = OpenBankingResponse.fromJson(
      response,
      (data) => data,
    );

    if (openBankingResponse.status != '00') {
      throw Exception(openBankingResponse.message);
    }

    final accountsData = openBankingResponse.data['accounts'] as List;
    return accountsData
        .map((account) => OpenBankingAccount.fromJson(account))
        .toList();
  }

  Future<OpenBankingPaginatedResponse<OpenBankingTransaction>>
      getAccountTransactions(
    String accountNumber, {
    String? from,
    String? to,
    int? page,
    int? limit,
    String? consentToken,
  }) async {
    final response = await _client.getAccountTransactions(
      accountNumber,
      from: from,
      to: to,
      page: page,
      limit: limit,
      consentToken: consentToken,
    );

    final openBankingResponse = OpenBankingResponse.fromJson(
      response,
      (data) => data,
    );

    if (openBankingResponse.status != '00') {
      throw Exception(openBankingResponse.message);
    }

    return OpenBankingPaginatedResponse.fromJson(
      openBankingResponse.data,
      (json) => OpenBankingTransaction.fromJson(json),
    );
  }

  Future<OpenBankingAccount> getAccountBalance(
    String accountNumber, {
    String? consentToken,
  }) async {
    final response = await _client.getAccountBalance(
      accountNumber,
      consentToken: consentToken,
    );

    final openBankingResponse = OpenBankingResponse.fromJson(
      response,
      (data) => data,
    );

    if (openBankingResponse.status != '00') {
      throw Exception(openBankingResponse.message);
    }

    return OpenBankingAccount.fromJson(openBankingResponse.data);
  }
}