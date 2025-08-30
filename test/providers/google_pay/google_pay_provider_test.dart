import 'package:flutter_test/flutter_test.dart';
import 'package:all_fintech_flutter_sdk/all_fintech_flutter_sdk.dart';

void main() {
  group('GooglePayProvider', () {
    late GooglePayProvider provider;
    late GooglePayConfig config;

    setUp(() {
      config = const GooglePayConfig(
        merchantId: 'test_merchant_id',
        merchantName: 'Test Merchant',
        countryCode: 'US',
        currencyCode: 'USD',
        environment: GooglePayEnvironment.test,
      );
      provider = GooglePayProvider(config);
    });

    tearDown(() {
      provider.dispose();
    });

    test('should initialize with correct configuration', () {
      expect(provider.config.merchantId, equals('test_merchant_id'));
      expect(provider.config.merchantName, equals('Test Merchant'));
      expect(provider.config.countryCode, equals('US'));
      expect(provider.config.currencyCode, equals('USD'));
      expect(provider.config.environment, equals(GooglePayEnvironment.test));
    });

    test('should provide data service', () {
      expect(provider.data, isA<GooglePayDataService>());
    });

    test('should provide UI service', () {
      expect(provider.ui, isA<GooglePayUIService>());
    });

    test('should report as configured when all required fields are present', () {
      expect(provider.isConfigured, isTrue);
    });

    test('should report as not configured when merchant ID is empty', () {
      final invalidConfig = GooglePayConfig(
        merchantId: '',
        merchantName: 'Test Merchant',
        countryCode: 'US',
        currencyCode: 'USD',
      );
      final invalidProvider = GooglePayProvider(invalidConfig);
      
      expect(invalidProvider.isConfigured, isFalse);
      invalidProvider.dispose();
    });

    test('should provide environment info', () {
      final info = provider.environmentInfo;
      
      expect(info['environment'], equals('test'));
      expect(info['merchantId'], equals('test_merchant_id'));
      expect(info['merchantName'], equals('Test Merchant'));
      expect(info['countryCode'], equals('US'));
      expect(info['currencyCode'], equals('USD'));
      expect(info['isConfigured'], isTrue);
      expect(info['supportedNetworks'], isA<List>());
    });

    test('should initialize with factory constructor', () {
      final factoryProvider = GooglePayProvider.initialize(
        merchantId: 'factory_merchant',
        merchantName: 'Factory Merchant',
        countryCode: 'GB',
        currencyCode: 'GBP',
        environment: GooglePayEnvironment.production,
      );

      expect(factoryProvider.config.merchantId, equals('factory_merchant'));
      expect(factoryProvider.config.environment, equals(GooglePayEnvironment.production));
      
      factoryProvider.dispose();
    });
  });
}