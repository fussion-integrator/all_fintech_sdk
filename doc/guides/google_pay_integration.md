# Google Pay Integration Guide

This guide covers how to integrate Google Pay into your Flutter app using the All Fintech SDK.

## 🚀 Quick Start

### 1. Installation

Add the SDK to your `pubspec.yaml`:

```yaml
dependencies:
  all_fintech_flutter_sdk: ^1.2.0
```

### 2. Basic Setup

```dart
import 'package:all_fintech_flutter_sdk/all_fintech_flutter_sdk.dart';

// Initialize SDK with Google Pay
final sdk = AllFintechSDK.initialize(
  provider: FintechProvider.googlePay,
  apiKey: 'your_merchant_id',
  publicKey: 'Your Merchant Name',
  isLive: false, // Set to true for production
);
```

### 3. Check Availability

```dart
final availability = await sdk.googlePay.data.checkAvailability();
if (availability.isAvailable) {
  // Google Pay is available
  print('Supported networks: ${availability.supportedNetworks}');
} else {
  // Handle unavailability
  print('Reason: ${availability.reason}');
}
```

## 💳 Payment Integration

### Simple Button

```dart
sdk.googlePay.ui.createSimpleButton(
  amount: 29.99,
  onSuccess: (token) {
    print('Payment successful: ${token.token}');
    // Process payment with your backend
  },
  onError: (error) {
    print('Payment failed: ${error.message}');
  },
)
```

### Custom Button

```dart
sdk.googlePay.ui.showGooglePayButton(
  paymentRequest: GooglePayRequest(
    amount: 49.99,
    currencyCode: 'USD',
    label: 'Premium Subscription',
    requireEmail: true,
    requireBillingAddress: true,
  ),
  buttonConfig: GooglePayButtonConfig(
    type: GooglePayButtonType.buy,
    theme: GooglePayButtonTheme.dark,
    width: double.infinity,
  ),
  onPaymentSuccess: (token) {
    // Handle successful payment
    _processPayment(token);
  },
  onPaymentError: (error) {
    // Handle payment error
    _showError(error.message);
  },
)
```

### Payment Sheet

```dart
await sdk.googlePay.ui.showPaymentSheet(
  context: context,
  paymentRequest: GooglePayRequest(
    amount: 99.99,
    currencyCode: 'USD',
    label: 'Order #12345',
    requireShippingAddress: true,
  ),
  onPaymentSuccess: (token) {
    Navigator.of(context).pop();
    _completeOrder(token);
  },
  onPaymentError: (error) {
    _handleError(error);
  },
  title: 'Complete Your Purchase',
  description: 'Secure payment with Google Pay',
);
```

## 🔧 Advanced Configuration

### Custom Merchant Configuration

```dart
final provider = GooglePayProvider.initialize(
  merchantId: 'your_merchant_id',
  merchantName: 'Your Store Name',
  countryCode: 'US',
  currencyCode: 'USD',
  environment: GooglePayEnvironment.production,
  allowedCardNetworks: [
    CardNetwork.visa,
    CardNetwork.mastercard,
    CardNetwork.amex,
  ],
  gateway: 'stripe', // Optional
  gatewayMerchantId: 'your_gateway_merchant_id', // Optional
);
```

### Payment Gateway Integration

For Stripe integration:

```dart
GooglePayConfig(
  merchantId: 'your_merchant_id',
  merchantName: 'Your Store',
  countryCode: 'US',
  currencyCode: 'USD',
  gateway: 'stripe',
  gatewayMerchantId: 'acct_1234567890',
)
```

For direct integration:

```dart
GooglePayConfig(
  merchantId: 'your_merchant_id',
  merchantName: 'Your Store',
  countryCode: 'US',
  currencyCode: 'USD',
  // No gateway specified - uses direct integration
)
```

## 📱 UI Customization

### Button Themes

```dart
// Dark theme (default)
GooglePayButtonConfig(
  theme: GooglePayButtonTheme.dark,
  type: GooglePayButtonType.pay,
)

// Light theme
GooglePayButtonConfig(
  theme: GooglePayButtonTheme.light,
  type: GooglePayButtonType.buy,
)
```

### Button Types

```dart
GooglePayButtonType.book      // "Book with Google Pay"
GooglePayButtonType.buy       // "Buy with Google Pay"
GooglePayButtonType.checkout  // "Checkout with Google Pay"
GooglePayButtonType.donate    // "Donate with Google Pay"
GooglePayButtonType.order     // "Order with Google Pay"
GooglePayButtonType.pay       // "Pay with Google Pay"
GooglePayButtonType.plain     // "Google Pay"
GooglePayButtonType.subscribe // "Subscribe with Google Pay"
```

### Custom Styling

```dart
GooglePayButtonConfig(
  width: 300.0,
  height: 48.0,
  cornerRadius: 12.0,
  type: GooglePayButtonType.buy,
  theme: GooglePayButtonTheme.dark,
)
```

## 🔒 Security Best Practices

### 1. Environment Configuration

```dart
// Development
GooglePayEnvironment.test

// Production
GooglePayEnvironment.production
```

### 2. Token Handling

```dart
void _processPayment(GooglePayToken token) {
  // Send token to your secure backend
  // Never store the token locally
  _sendToBackend({
    'payment_token': token.token,
    'token_type': token.tokenType,
    'amount': paymentAmount,
    'currency': 'USD',
  });
}
```

### 3. Error Handling

```dart
void _handlePaymentError(GooglePayException error) {
  switch (error.code) {
    case 'GOOGLE_PAY_NOT_AVAILABLE':
      _showAlternativePaymentMethods();
      break;
    case 'PAYMENT_CANCELLED':
      // User cancelled - no action needed
      break;
    case 'PAYMENT_FAILED':
      _showRetryOption();
      break;
    default:
      _showGenericError();
  }
}
```

## 📊 Data Operations

### Request Payment Token (Headless)

```dart
try {
  final request = sdk.googlePay.data.createPaymentRequest(
    amount: 25.00,
    currencyCode: 'USD',
    requireBillingAddress: true,
  );
  
  final token = await sdk.googlePay.data.requestPaymentToken(request);
  
  // Process token
  await _processPaymentToken(token);
} catch (e) {
  // Handle error
  print('Payment failed: $e');
}
```

### Get Merchant Information

```dart
final merchantInfo = sdk.googlePay.data.getMerchantInfo();
print('Merchant: ${merchantInfo['merchantName']}');
print('Country: ${merchantInfo['countryCode']}');
print('Supported Networks: ${merchantInfo['supportedNetworks']}');
```

### Check Supported Networks

```dart
final networks = sdk.googlePay.data.getSupportedCardNetworks();
print('Supported: ${networks.map((n) => n.name).join(', ')}');
```

## 🧪 Testing

### Test Configuration

```dart
final testSDK = AllFintechSDK.initialize(
  provider: FintechProvider.googlePay,
  apiKey: 'test_merchant_id',
  publicKey: 'Test Merchant',
  isLive: false, // Always false for testing
);
```

### Mock Responses

The SDK automatically provides mock responses in test environment:

```dart
// This will return a simulated token in test mode
final token = await testSDK.googlePay.data.requestPaymentToken(request);
print('Test token: ${token.token}'); // Returns simulated token
```

## 🚨 Error Handling

### Common Error Codes

| Code | Description | Action |
|------|-------------|--------|
| `GOOGLE_PAY_NOT_AVAILABLE` | Google Pay not available on device | Show alternative payment methods |
| `INVALID_AMOUNT` | Payment amount is invalid | Validate amount before request |
| `INVALID_CURRENCY` | Currency code is invalid | Use valid ISO 4217 codes |
| `PAYMENT_CANCELLED` | User cancelled payment | No action needed |
| `PAYMENT_FAILED` | Payment processing failed | Show retry option |
| `TOKEN_REQUEST_FAILED` | Failed to get payment token | Check network and retry |

### Error Handling Example

```dart
try {
  final token = await sdk.googlePay.data.requestPaymentToken(request);
  await _processPayment(token);
} on GooglePayException catch (e) {
  switch (e.code) {
    case 'GOOGLE_PAY_NOT_AVAILABLE':
      _showAlternativePaymentMethods();
      break;
    case 'INVALID_AMOUNT':
      _showAmountError();
      break;
    default:
      _showGenericError(e.message);
  }
} catch (e) {
  _showGenericError('Unexpected error: $e');
}
```

## 🌍 Internationalization

### Supported Countries

Google Pay is available in many countries. Configure accordingly:

```dart
GooglePayConfig(
  countryCode: 'US', // United States
  currencyCode: 'USD',
)

GooglePayConfig(
  countryCode: 'GB', // United Kingdom
  currencyCode: 'GBP',
)

GooglePayConfig(
  countryCode: 'CA', // Canada
  currencyCode: 'CAD',
)
```

### Currency Support

```dart
// Major currencies supported
'USD' // US Dollar
'EUR' // Euro
'GBP' // British Pound
'CAD' // Canadian Dollar
'AUD' // Australian Dollar
'JPY' // Japanese Yen
```

## 📱 Platform Configuration

### Android Setup

Add to `android/app/build.gradle`:

```gradle
dependencies {
    implementation 'com.google.android.gms:play-services-wallet:19.2.1'
}
```

### iOS Setup

Add to `ios/Runner/Info.plist`:

```xml
<key>com.apple.developer.in-app-payments</key>
<array>
    <string>merchant.your.merchant.id</string>
</array>
```

## 🔄 Migration Guide

### From Other Payment SDKs

If migrating from other payment solutions:

1. **Replace initialization**:
   ```dart
   // Old
   PaymentSDK.initialize(apiKey: 'key');
   
   // New
   AllFintechSDK.initialize(
     provider: FintechProvider.googlePay,
     apiKey: 'merchant_id',
     publicKey: 'merchant_name',
   );
   ```

2. **Update payment flow**:
   ```dart
   // Old
   PaymentSDK.showPaymentSheet(amount: 100);
   
   // New
   sdk.googlePay.ui.showPaymentSheet(
     context: context,
     paymentRequest: GooglePayRequest(amount: 100, currencyCode: 'USD'),
     onPaymentSuccess: (token) => processPayment(token),
     onPaymentError: (error) => handleError(error),
   );
   ```

## 📚 Additional Resources

- [Google Pay API Documentation](https://developers.google.com/pay/api)
- [Google Pay Brand Guidelines](https://developers.google.com/pay/api/web/guides/brand-guidelines)
- [All Fintech SDK API Reference](https://pub.dev/documentation/all_fintech_flutter_sdk/latest/)
- [Example App](https://github.com/chidiebere-edeh/all_fintech_sdk/tree/main/example)

## 🆘 Support

Need help? Reach out:

- [GitHub Issues](https://github.com/chidiebere-edeh/all_fintech_sdk/issues)
- [Documentation](https://pub.dev/documentation/all_fintech_flutter_sdk/latest/)
- Email: support@allfintech.dev