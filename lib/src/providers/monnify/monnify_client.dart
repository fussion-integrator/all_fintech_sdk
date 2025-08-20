import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/api_response.dart';
import '../../core/fintech_config.dart';
import '../../core/enhanced_exceptions.dart';
import '../../models/monnify_models.dart';

class MonnifyClient {
  final FintechConfig _config;
  String? _accessToken;
  DateTime? _tokenExpiry;

  MonnifyClient(this._config);

  String get _baseUrl => _config.isLive 
      ? 'https://api.monnify.com' 
      : 'https://sandbox.monnify.com';

  Future<void> _authenticate() async {
    if (_accessToken != null && _tokenExpiry != null && DateTime.now().isBefore(_tokenExpiry!)) {
      return;
    }

    final credentials = base64Encode(utf8.encode('${_config.apiKey}:${_config.publicKey}'));
    
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/v1/auth/login'),
        headers: {
          'Authorization': 'Basic $credentials',
          'Content-Type': 'application/json',
        },
        body: '{}',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['requestSuccessful'] == true) {
          final authResponse = MonnifyAuthResponse.fromJson(data['responseBody']);
          _accessToken = authResponse.accessToken;
          _tokenExpiry = DateTime.now().add(Duration(seconds: authResponse.expiresIn - 60));
        } else {
          throw EnhancedException.authentication(data['responseMessage'] ?? 'Authentication failed');
        }
      } else {
        throw EnhancedException.network('Authentication failed', statusCode: response.statusCode);
      }
    } catch (e) {
      if (e is EnhancedException) rethrow;
      throw EnhancedException.network('Network error during authentication: $e');
    }
  }

  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, String>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    await _authenticate();
    
    final uri = Uri.parse('$_baseUrl$endpoint').replace(queryParameters: queryParameters);
    
    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $_accessToken',
          'Content-Type': 'application/json',
        },
      );

      return _handleResponse(response, fromJson);
    } catch (e) {
      if (e is EnhancedException) rethrow;
      throw EnhancedException.network('Network error: $e');
    }
  }

  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? data,
    T Function(dynamic)? fromJson,
  }) async {
    await _authenticate();
    
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl$endpoint'),
        headers: {
          'Authorization': 'Bearer $_accessToken',
          'Content-Type': 'application/json',
        },
        body: data != null ? jsonEncode(data) : null,
      );

      return _handleResponse(response, fromJson);
    } catch (e) {
      if (e is EnhancedException) rethrow;
      throw EnhancedException.network('Network error: $e');
    }
  }

  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? data,
    T Function(dynamic)? fromJson,
  }) async {
    await _authenticate();
    
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl$endpoint'),
        headers: {
          'Authorization': 'Bearer $_accessToken',
          'Content-Type': 'application/json',
        },
        body: data != null ? jsonEncode(data) : null,
      );

      return _handleResponse(response, fromJson);
    } catch (e) {
      if (e is EnhancedException) rethrow;
      throw EnhancedException.network('Network error: $e');
    }
  }

  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    T Function(dynamic)? fromJson,
  }) async {
    await _authenticate();
    
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl$endpoint'),
        headers: {
          'Authorization': 'Bearer $_accessToken',
          'Content-Type': 'application/json',
        },
      );

      return _handleResponse(response, fromJson);
    } catch (e) {
      if (e is EnhancedException) rethrow;
      throw EnhancedException.network('Network error: $e');
    }
  }

  ApiResponse<T> _handleResponse<T>(http.Response response, T Function(dynamic)? fromJson) {
    final data = jsonDecode(response.body);
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (data['requestSuccessful'] == true) {
        final responseData = fromJson != null ? fromJson(data['responseBody']) : data['responseBody'] as T;
        return ApiResponse(
          status: true,
          data: responseData,
          message: data['responseMessage'] ?? 'Success',
        );
      } else {
        throw EnhancedException.server(
          data['responseMessage'] ?? 'Request failed',
          statusCode: response.statusCode,
          errorCode: data['responseCode'],
        );
      }
    } else {
      throw EnhancedException.server(
        data['responseMessage'] ?? 'Server error',
        statusCode: response.statusCode,
        errorCode: data['responseCode'],
      );
    }
  }
}