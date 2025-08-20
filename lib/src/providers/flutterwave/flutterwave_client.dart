import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/api_response.dart';
import '../../core/fintech_config.dart';
import '../../core/exceptions.dart';

/// Flutterwave HTTP client for API communication.
class FlutterwaveClient {
  final FintechConfig _config;
  late final http.Client _httpClient;

  /// Creates a new Flutterwave client with the given configuration.
  FlutterwaveClient(this._config) {
    _httpClient = http.Client();
  }

  /// Gets the base URL based on environment configuration.
  String get _baseUrl => !_config.isLive
      ? 'https://api.flutterwave.com/v3'
      : 'https://api.flutterwave.com/v3';

  /// Gets the HTTP headers for API requests.
  Map<String, String> get _headers => {
        'Authorization': 'Bearer ${_config.apiKey}',
        'Content-Type': 'application/json',
      };

  /// Performs a GET request to the specified endpoint.
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final finalUri = queryParams != null
          ? uri.replace(queryParameters: queryParams.map((k, v) => MapEntry(k, v.toString())))
          : uri;

      final response = await _httpClient.get(finalUri, headers: _headers);
      return _handleResponse(response, fromJson);
    } catch (e) {
      throw FintechException(message: 'Network error: $e');
    }
  }

  /// Performs a POST request to the specified endpoint.
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
      throw FintechException(message: 'Network error: $e');
    }
  }

  /// Performs a PUT request to the specified endpoint.
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
      throw FintechException(message: 'Network error: $e');
    }
  }

  /// Performs a DELETE request to the specified endpoint.
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final response = await _httpClient.delete(uri, headers: _headers);
      return _handleResponse(response, fromJson);
    } catch (e) {
      throw FintechException(message: 'Network error: $e');
    }
  }

  /// Handles HTTP response and converts to ApiResponse.
  ApiResponse<T> _handleResponse<T>(
    http.Response response,
    T Function(dynamic)? fromJson,
  ) {
    final Map<String, dynamic> body = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = body['data'];
      return ApiResponse<T>(
        status: true,
        message: body['message'] ?? 'Success',
        data: fromJson != null ? fromJson(data) : data as T,
      );
    } else {
      throw FintechException(
        message: body['message'] ?? 'Request failed',
        statusCode: response.statusCode,
      );
    }
  }

  /// Disposes the HTTP client.
  void dispose() {
    _httpClient.close();
  }
}