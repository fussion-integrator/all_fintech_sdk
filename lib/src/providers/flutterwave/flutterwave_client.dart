import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/api_response.dart';
import '../../core/fintech_config.dart';
import '../../core/exceptions.dart';

class FlutterwaveClient {
  final FintechConfig _config;
  late final http.Client _httpClient;

  FlutterwaveClient(this._config) {
    _httpClient = http.Client();
  }

  String get _baseUrl => _config.environment == Environment.sandbox
      ? 'https://api.flutterwave.com/v3'
      : 'https://api.flutterwave.com/v3';

  Map<String, String> get _headers => {
        'Authorization': 'Bearer ${_config.secretKey}',
        'Content-Type': 'application/json',
      };

  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final finalUri = queryParameters != null
          ? uri.replace(queryParameters: queryParameters.map((k, v) => MapEntry(k, v.toString())))
          : uri;

      final response = await _httpClient.get(finalUri, headers: _headers);
      return _handleResponse(response, fromJson);
    } catch (e) {
      throw FintechException('Network error: $e');
    }
  }

  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? data,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final response = await _httpClient.post(
        uri,
        headers: _headers,
        body: data != null ? jsonEncode(data) : null,
      );
      return _handleResponse(response, fromJson);
    } catch (e) {
      throw FintechException('Network error: $e');
    }
  }

  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? data,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final response = await _httpClient.put(
        uri,
        headers: _headers,
        body: data != null ? jsonEncode(data) : null,
      );
      return _handleResponse(response, fromJson);
    } catch (e) {
      throw FintechException('Network error: $e');
    }
  }

  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final response = await _httpClient.delete(uri, headers: _headers);
      return _handleResponse(response, fromJson);
    } catch (e) {
      throw FintechException('Network error: $e');
    }
  }

  ApiResponse<T> _handleResponse<T>(
    http.Response response,
    T Function(dynamic)? fromJson,
  ) {
    final Map<String, dynamic> body = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = body['data'];
      return ApiResponse<T>(
        success: true,
        message: body['message'] ?? 'Success',
        data: fromJson != null ? fromJson(data) : data as T,
      );
    } else {
      throw FintechException(
        body['message'] ?? 'Request failed',
        statusCode: response.statusCode,
      );
    }
  }

  void dispose() {
    _httpClient.close();
  }
}