import 'package:flutter_test/flutter_test.dart';
import 'package:all_fintech_flutter_sdk/all_fintech_flutter_sdk.dart';

void main() {
  group('AllFintechSDK', () {
    test('should initialize with valid configuration', () {
      final sdk = AllFintechSDK.initialize(
        provider: FintechProvider.paystack,
        apiKey: 'test_api_key',
        isLive: false,
      );

      expect(sdk, isNotNull);
      expect(sdk.isProviderSupported(FintechProvider.paystack), isTrue);
    });

    test('should support all declared providers', () {
      final supportedProviders = [
        FintechProvider.paystack,
        FintechProvider.flutterwave,
        FintechProvider.monnify,
        FintechProvider.opay,
        FintechProvider.openBanking,
        FintechProvider.transactpay,
        FintechProvider.googlePay,
        FintechProvider.applePay,
        FintechProvider.paypal,
      ];

      final sdk = AllFintechSDK.initialize(
        provider: FintechProvider.paystack,
        apiKey: 'test_key',
      );

      for (final provider in supportedProviders) {
        expect(sdk.isProviderSupported(provider), isTrue);
      }
    });

    test('should not support unsupported providers', () {
      final sdk = AllFintechSDK.initialize(
        provider: FintechProvider.paystack,
        apiKey: 'test_key',
      );

      // Test with a provider that doesn't exist in our enum
      expect(sdk.isProviderSupported(FintechProvider.kuda), isFalse);
    });

    group('Provider Access', () {
      late AllFintechSDK sdk;

      setUp(() {
        sdk = AllFintechSDK.initialize(
          provider: FintechProvider.paystack,
          apiKey: 'test_key',
          publicKey: 'test_public_key',
        );
      });

      test('should provide access to Paystack provider', () {
        expect(() => sdk.paystack, returnsNormally);
      });

      test('should provide access to Flutterwave provider', () {
        expect(() => sdk.flutterwave, returnsNormally);
      });

      test('should provide access to Monnify provider', () {
        expect(() => sdk.monnify, returnsNormally);
      });

      test('should provide access to Opay provider', () {
        expect(() => sdk.opay, returnsNormally);
      });

      test('should provide access to Google Pay provider', () {
        expect(() => sdk.googlePay, returnsNormally);
      });

      test('should provide access to Apple Pay provider', () {
        expect(() => sdk.applePay, returnsNormally);
      });

      test('should provide access to PayPal provider', () {
        expect(() => sdk.paypal, returnsNormally);
      });
    });
  });

  group('FintechProvider', () {
    test('should contain all expected providers', () {
      final expectedProviders = {
        'paystack',
        'flutterwave',
        'monnify',
        'opay',
        'openBanking',
        'transactpay',
        'googlePay',
        'applePay',
        'paypal',
      };

      final actualProviders = FintechProvider.values.map((e) => e.name).toSet();
      
      for (final provider in expectedProviders) {
        expect(actualProviders, contains(provider));
      }
    });
  });
}