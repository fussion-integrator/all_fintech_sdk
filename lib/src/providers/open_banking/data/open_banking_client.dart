import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import '../../../core/exceptions.dart';

class OpenBankingClient {
  final String clientId;
  final String clientSecret;
  final String baseUrl;
  String? _bearerToken;

  OpenBankingClient({
    required this.clientId,
    required this.clientSecret,
    required this.baseUrl,
  });

  String _generateIdempotencyKey() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  String _generateSignature(String idempotencyKey, String bearerToken) {
    final data = '$clientId;$idempotencyKey;$bearerToken';
    return sha256.convert(utf8.encode(data)).toString();
  }

  String _encryptConsentToken(String consentToken) {
    // Simplified encryption - in production, use proper AES-256-CBC
    final secretHash = sha256.convert(utf8.encode(clientSecret)).toString();
    return base64.encode(utf8.encode('$consentToken:$secretHash'));
  }

  Future<String> _getAccessToken() async {
    if (_bearerToken != null) return _bearerToken!;

    try {
      final credentials = base64.encode(utf8.encode('$clientId:$clientSecret'));
      final response = await http.post(
        Uri.parse('$baseUrl/token'),
        headers: {
          'Authorization': 'Basic $credentials',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'grant_type=client_credentials',
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _bearerToken = data['access_token'];
        return _bearerToken!;
      } else {
        throw FintechException('Failed to get access token: ${response.body}');
      }
    } catch (e) {
      throw FintechException('Authentication error: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> _makeRequest(
    String endpoint, {
    String method = 'GET',
    Map<String, dynamic>? body,
    Map<String, String>? queryParams,
    String? consentToken,
  }) async {
    try {
      final token = await _getAccessToken();
      final idempotencyKey = _generateIdempotencyKey();
      final signature = _generateSignature(idempotencyKey, token);

      var uri = Uri.parse('$baseUrl$endpoint');
      if (queryParams != null) {
        uri = uri.replace(queryParameters: queryParams);
      }

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'idempotency_key': idempotencyKey,
        'signature': signature,
      };

      if (consentToken != null) {
        headers['consent_token'] = _encryptConsentToken(consentToken);
      }

      http.Response response;
      switch (method.toUpperCase()) {
        case 'GET':
          response = await http.get(uri, headers: headers);
          break;
        case 'POST':
          response = await http.post(
            uri,
            headers: headers,
            body: body != null ? json.encode(body) : null,
          );
          break;
        case 'PUT':
          response = await http.put(
            uri,
            headers: headers,
            body: body != null ? json.encode(body) : null,
          );
          break;
        case 'DELETE':
          response = await http.delete(uri, headers: headers);
          break;
        default:
          throw FintechException('Unsupported HTTP method: $method');
      }

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return responseData;
      } else if (response.statusCode == 401) {
        _bearerToken = null; // Reset token for retry
        throw FintechException('Unauthorized: Token expired or invalid');
      } else {
        final error = responseData['message'] ?? 'Unknown error';
        throw FintechException('HTTP ${response.statusCode}: $error');
      }
    } catch (e) {
      if (e is FintechException) rethrow;
      throw FintechException('Network error: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> getSavings({String? consentToken}) async {
    return await _makeRequest('/savings', consentToken: consentToken);
  }

  Future<Map<String, dynamic>> getSavingsTransactions(
    String savingsId, {
    String? from,
    String? to,
    int? page,
    String? consentToken,
  }) async {
    final queryParams = <String, String>{};
    if (from != null) queryParams['from'] = from;
    if (to != null) queryParams['to'] = to;
    if (page != null) queryParams['page'] = page.toString();

    return await _makeRequest(
      '/savings/$savingsId/transactions',
      queryParams: queryParams,
      consentToken: consentToken,
    );
  }

  Future<Map<String, dynamic>> getAccounts({String? consentToken}) async {
    return await _makeRequest('/accounts', consentToken: consentToken);
  }

  Future<Map<String, dynamic>> getAccountTransactions(
    String accountNumber, {
    String? from,
    String? to,
    int? page,
    int? limit,
    String? consentToken,
  }) async {
    final queryParams = <String, String>{};
    if (from != null) queryParams['from'] = from;
    if (to != null) queryParams['to'] = to;
    if (page != null) queryParams['page'] = page.toString();
    if (limit != null) queryParams['limit'] = limit.toString();

    return await _makeRequest(
      '/accounts/$accountNumber/transactions',
      queryParams: queryParams,
      consentToken: consentToken,
    );
  }

  Future<Map<String, dynamic>> getAccountBalance(
    String accountNumber, {
    String? consentToken,
  }) async {
    return await _makeRequest(
      '/accounts/$accountNumber/balance',
      consentToken: consentToken,
    );
  }
}