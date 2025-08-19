import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/fintech_config.dart';
import '../../core/exceptions.dart';
import '../../core/api_response.dart';

class PaystackClient {
  static const String _baseUrl = 'https://api.paystack.co';
  final FintechConfig config;
  final String baseUrl;

  PaystackClient(this.config) : baseUrl = config.baseUrl ?? _baseUrl;

  Map<String, String> get _headers => {
    'Authorization': config.authHeader,
    'Content-Type': 'application/json',
  };

  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      var uri = Uri.parse('$baseUrl$path');
      if (queryParameters != null) {
        uri = uri.replace(queryParameters: queryParameters.map((k, v) => MapEntry(k, v.toString())));
      }
      final response = await http.get(uri, headers: _headers);
      final data = json.decode(response.body);
      return ApiResponse.fromJson(data, fromJson);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    Map<String, dynamic>? data,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$path'),
        headers: _headers,
        body: data != null ? json.encode(data) : null,
      );
      final responseData = json.decode(response.body);
      return ApiResponse.fromJson(responseData, fromJson);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<ApiResponse<T>> put<T>(
    String path, {
    Map<String, dynamic>? data,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$path'),
        headers: _headers,
        body: data != null ? json.encode(data) : null,
      );
      final responseData = json.decode(response.body);
      return ApiResponse.fromJson(responseData, fromJson);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<ApiResponse<T>> delete<T>(
    String path, {
    Map<String, dynamic>? data,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$path'),
        headers: _headers,
        body: data != null ? json.encode(data) : null,
      );
      final responseData = json.decode(response.body);
      return ApiResponse.fromJson(responseData, fromJson);
    } catch (e) {
      throw _handleError(e);
    }
  }

  PaystackException _handleError(dynamic error) {
    if (error is http.Response) {
      try {
        final data = json.decode(error.body) as Map<String, dynamic>;
        return PaystackException(
          message: data['message'] ?? 'An error occurred',
          statusCode: error.statusCode,
          data: data,
        );
      } catch (_) {
        return PaystackException(
          message: 'HTTP ${error.statusCode}: ${error.body}',
          statusCode: error.statusCode,
        );
      }
    }
    return PaystackException(message: error.toString());
  }
}