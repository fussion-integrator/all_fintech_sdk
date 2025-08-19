import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import '../../../core/exceptions.dart';

class OpayClient {
  final String websiteId;
  final String password;
  final String baseUrl;
  final bool isTestMode;

  OpayClient({
    required this.websiteId,
    required this.password,
    this.baseUrl = 'https://gateway.opay.lt',
    this.isTestMode = false,
  });

  String _generateSignature(Map<String, dynamic> data) {
    final sortedKeys = data.keys.toList()..sort();
    final signatureString = sortedKeys
        .where((key) => key != 'password_signature')
        .map((key) => '$key=${data[key] ?? ''}')
        .join('&');
    
    final combined = '$signatureString$password';
    return md5.convert(utf8.encode(combined)).toString();
  }

  Map<String, String> _prepareFormData(Map<String, dynamic> data) {
    final formData = <String, String>{};
    
    data.forEach((key, value) {
      if (value != null) {
        formData[key] = value.toString();
      }
    });
    
    formData['password_signature'] = _generateSignature(data);
    return formData;
  }

  Future<Map<String, dynamic>> _makeRequest(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final formData = _prepareFormData(data);
      
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: formData,
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        
        if (jsonResponse['response'] != null) {
          final responseData = jsonResponse['response'];
          final errors = responseData['errors'];
          
          if (errors != null && errors != '[]' && errors.isNotEmpty) {
            throw FintechException('Opay API Error: $errors');
          }
          
          return responseData['result'] ?? {};
        }
        
        return jsonResponse;
      } else {
        throw FintechException('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      if (e is FintechException) rethrow;
      throw FintechException('Network error: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> createTransaction(Map<String, dynamic> data) async {
    data['website_id'] = websiteId;
    return await _makeRequest('/api/createtransaction/', data);
  }

  Future<Map<String, dynamic>> getTransaction(String transactionId) async {
    final data = {
      'website_id': websiteId,
      'language': 'ENG',
      'service_name': 'getPaymentById',
    };
    return await _makeRequest('/api/transactions/$transactionId', data);
  }

  Future<List<Map<String, dynamic>>> getTransactionsByOrderNumber(String orderNr) async {
    final data = {
      'website_id': websiteId,
      'language': 'ENG',
      'service_name': 'getPaymentsByOrderNumber',
      'filter': json.encode({'order_nr': orderNr}),
      'test': isTestMode ? 'Y' : 'N',
    };
    
    final result = await _makeRequest('/api/transactions/', data);
    return List<Map<String, dynamic>>.from(result);
  }

  Future<Map<String, dynamic>> listChannels(Map<String, dynamic> data) async {
    data['website_id'] = websiteId;
    return await _makeRequest('/api/listchannels/', data);
  }

  Future<Map<String, dynamic>> makeRecurringPayment(Map<String, dynamic> data) async {
    data['website_id'] = websiteId;
    data['service_name'] = 'cardMakeRecurringPayment';
    return await _makeRequest('/api/recurring/', data);
  }

  Future<Map<String, dynamic>> updateCardDetails(Map<String, dynamic> data) async {
    data['website_id'] = websiteId;
    data['service_name'] = 'cardOverwriteData';
    return await _makeRequest('/api/recurring/', data);
  }

  Future<Map<String, dynamic>> getCardOperationStatus(Map<String, dynamic> data) async {
    data['website_id'] = websiteId;
    data['service_name'] = 'cardGetOperationStatus';
    return await _makeRequest('/api/recurring/', data);
  }

  Future<Map<String, dynamic>> createRefund(Map<String, dynamic> data) async {
    data['website_id'] = websiteId;
    data['service_name'] = 'refundRequest';
    return await _makeRequest('/api/refunds/', data);
  }

  Future<Map<String, dynamic>> getRefundStatus(String uniqueRefundToken) async {
    final data = {
      'website_id': websiteId,
      'service_name': 'getRefundRequestStatus',
      'unique_refund_token': uniqueRefundToken,
      'language': 'ENG',
    };
    return await _makeRequest('/api/refunds/', data);
  }
}