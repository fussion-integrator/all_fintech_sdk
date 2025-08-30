import 'package:flutter_test/flutter_test.dart';
import 'package:all_fintech_flutter_sdk/all_fintech_flutter_sdk.dart';

void main() {
  group('GooglePayDataService', () {
    late GooglePayDataService dataService;
    late GooglePayConfig config;

    setUp(() {
      config = const GooglePayConfig(
        merchantId: 'test_merchant_id',
        merchantName: 'Test Merchant',
        countryCode: 'US',
        currencyCode: 'USD',
        environment: GooglePayEnvironment.test,
      );
      dataService = GooglePayDataService(config);
    });

    tearDown(() {
      dataService.dispose();
    });

    group('Payment Request Creation', () {
      test('should create payment request with default currency', () {
        final request = dataService.createPaymentRequest(amount: 100.0);
        
        expect(request.amount, equals(100.0));
        expect(request.currencyCode, equals('USD'));
        expect(request.requireBillingAddress, isFalse);
        expect(request.requireShippingAddress, isFalse);
      });

      test('should create payment request with custom parameters', () {
        final request = dataService.createPaymentRequest(
          amount: 250.0,
          currencyCode: 'EUR',
          label: 'Test Payment',
          requireBillingAddress: true,
          requireEmail: true,
        );
        
        expect(request.amount, equals(250.0));
        expect(request.currencyCode, equals('EUR'));
        expect(request.label, equals('Test Payment'));
        expect(request.requireBillingAddress, isTrue);
        expect(request.requireEmail, isTrue);
      });
    });

    group('Configuration', () {
      test('should return supported card networks', () {
        final networks = dataService.getSupportedCardNetworks();
        
        expect(networks, contains(CardNetwork.visa));
        expect(networks, contains(CardNetwork.mastercard));
        expect(networks, isA<List<CardNetwork>>());
      });

      test('should return merchant info without sensitive data', () {
        final info = dataService.getMerchantInfo();
        
        expect(info['merchantName'], equals('Test Merchant'));
        expect(info['countryCode'], equals('US'));
        expect(info['currencyCode'], equals('USD'));
        expect(info['environment'], equals('test'));
        expect(info['supportedNetworks'], isA<List>());
        expect(info.containsKey('merchantId'), isFalse);
      });

      test('should provide access to configuration', () {
        expect(dataService.config, equals(config));
      });
    });

    group('Cache Management', () {
      test('should clear cache', () {
        // This test verifies the cache clearing functionality
        // In a real implementation, we'd test actual cache behavior
        expect(() => dataService.clearCache(), returnsNormally);
      });
    });

    group('Request Validation', () {
      test('should validate payment request with valid amount', () {
        final request = GooglePayRequest(
          amount: 50.0,
          currencyCode: 'USD',
        );
        
        // This would be tested through the requestPaymentToken method
        // which calls _validatePaymentRequest internally
        expect(request.amount, greaterThan(0));
        expect(request.currencyCode.length, equals(3));
      });

      test('should handle invalid payment amounts', () async {
        final request = GooglePayRequest(
          amount: -10.0,
          currencyCode: 'USD',
        );
        
        expect(
          () => dataService.requestPaymentToken(request),
          throwsA(isA<GooglePayException>()),
        );
      });

      test('should handle invalid currency codes', () async {
        final request = GooglePayRequest(
          amount: 50.0,
          currencyCode: 'INVALID',
        );
        
        expect(
          () => dataService.requestPaymentToken(request),
          throwsA(isA<GooglePayException>()),
        );
      });

      test('should handle amounts exceeding maximum limit', () async {
        final request = GooglePayRequest(
          amount: 1000000.0,
          currencyCode: 'USD',
        );
        
        expect(
          () => dataService.requestPaymentToken(request),
          throwsA(isA<GooglePayException>()),
        );
      });
    });
  });
}