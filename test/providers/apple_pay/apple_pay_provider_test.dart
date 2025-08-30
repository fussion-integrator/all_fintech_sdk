import 'package:flutter_test/flutter_test.dart';
import 'package:all_fintech_flutter_sdk/all_fintech_flutter_sdk.dart';

void main() {
  group('ApplePayProvider', () {
    late ApplePayProvider provider;
    late ApplePayConfig config;

    setUp(() {
      config = const ApplePayConfig(
        merchantId: 'merchant.com.example.app',
        merchantName: 'Test Merchant',
        countryCode: 'US',
        currencyCode: 'USD',
        environment: ApplePayEnvironment.sandbox,
      );
      provider = ApplePayProvider(config);
    });

    tearDown(() {
      provider.dispose();
    });

    test('should initialize with correct configuration', () {
      expect(provider.config.merchantId, equals('merchant.com.example.app'));
      expect(provider.config.merchantName, equals('Test Merchant'));
      expect(provider.config.countryCode, equals('US'));
      expect(provider.config.currencyCode, equals('USD'));
      expect(provider.config.environment, equals(ApplePayEnvironment.sandbox));
    });

    test('should provide data service', () {
      expect(provider.data, isA<ApplePayDataService>());
    });

    test('should provide UI service', () {
      expect(provider.ui, isA<ApplePayUIService>());
    });

    test('should report as configured when all required fields are present', () {
      expect(provider.isConfigured, isTrue);
    });

    test('should report as not configured when merchant ID is empty', () {
      final invalidConfig = ApplePayConfig(
        merchantId: '',
        merchantName: 'Test Merchant',
        countryCode: 'US',
        currencyCode: 'USD',
      );
      final invalidProvider = ApplePayProvider(invalidConfig);
      
      expect(invalidProvider.isConfigured, isFalse);
      invalidProvider.dispose();
    });

    test('should provide environment info', () {
      final info = provider.environmentInfo;
      
      expect(info['environment'], equals('sandbox'));
      expect(info['merchantId'], equals('merchant.com.example.app'));
      expect(info['merchantName'], equals('Test Merchant'));
      expect(info['countryCode'], equals('US'));
      expect(info['currencyCode'], equals('USD'));
      expect(info['isConfigured'], isTrue);
      expect(info['supportedNetworks'], isA<List>());
      expect(info['merchantCapabilities'], isA<List>());
    });

    test('should initialize with factory constructor', () {
      final factoryProvider = ApplePayProvider.initialize(
        merchantId: 'merchant.com.factory.app',
        merchantName: 'Factory Merchant',
        countryCode: 'CA',
        currencyCode: 'CAD',
        environment: ApplePayEnvironment.production,
      );

      expect(factoryProvider.config.merchantId, equals('merchant.com.factory.app'));
      expect(factoryProvider.config.environment, equals(ApplePayEnvironment.production));
      
      factoryProvider.dispose();
    });

    test('should handle custom supported networks', () {
      final customProvider = ApplePayProvider.initialize(
        merchantId: 'merchant.com.custom.app',
        merchantName: 'Custom Merchant',
        countryCode: 'US',
        currencyCode: 'USD',
        supportedNetworks: [
          ApplePayNetwork.visa,
          ApplePayNetwork.masterCard,
          ApplePayNetwork.amex,
          ApplePayNetwork.discover,
        ],
      );

      expect(customProvider.config.supportedNetworks.length, equals(4));
      expect(customProvider.config.supportedNetworks, contains(ApplePayNetwork.discover));
      
      customProvider.dispose();
    });
  });
}