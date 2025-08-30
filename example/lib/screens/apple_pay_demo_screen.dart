import 'package:flutter/material.dart';
import 'package:all_fintech_flutter_sdk/all_fintech_flutter_sdk.dart';

/// Apple Pay demo screen showcasing all features.
class ApplePayDemoScreen extends StatefulWidget {
  const ApplePayDemoScreen({super.key});

  @override
  State<ApplePayDemoScreen> createState() => _ApplePayDemoScreenState();
}

class _ApplePayDemoScreenState extends State<ApplePayDemoScreen> {
  late AllFintechSDK sdk;
  ApplePayAvailability? _availability;
  bool _isLoading = false;
  String? _lastResult;

  @override
  void initState() {
    super.initState();
    _initializeSDK();
    _checkAvailability();
  }

  void _initializeSDK() {
    sdk = AllFintechSDK.initialize(
      provider: FintechProvider.applePay,
      apiKey: 'merchant.com.example.app',
      publicKey: 'Demo Store',
      isLive: false,
    );
  }

  Future<void> _checkAvailability() async {
    setState(() => _isLoading = true);
    
    try {
      final availability = await sdk.applePay.data.checkAvailability();
      setState(() {
        _availability = availability;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _lastResult = 'Error checking availability: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apple Pay Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAvailabilityCard(),
            const SizedBox(height: 16.0),
            _buildButtonDemos(),
            const SizedBox(height: 16.0),
            _buildDataOperations(),
            const SizedBox(height: 16.0),
            _buildResultCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailabilityCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Apple Pay Availability',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            if (_isLoading)
              const Row(
                children: [
                  SizedBox(
                    width: 16.0,
                    height: 16.0,
                    child: CircularProgressIndicator(strokeWidth: 2.0),
                  ),
                  SizedBox(width: 8.0),
                  Text('Checking availability...'),
                ],
              )
            else if (_availability != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _availability!.isAvailable ? Icons.check_circle : Icons.error,
                        color: _availability!.isAvailable ? Colors.green : Colors.red,
                        size: 20.0,
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        _availability!.isAvailable ? 'Available' : 'Not Available',
                        style: TextStyle(
                          color: _availability!.isAvailable ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  if (!_availability!.isAvailable && _availability!.reason != null) ...[
                    const SizedBox(height: 4.0),
                    Text(
                      'Reason: ${_availability!.reason}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            const SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: _checkAvailability,
              child: const Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonDemos() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Apple Pay Buttons',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            
            sdk.applePay.ui.showApplePayButton(
              paymentRequest: const ApplePayRequest(
                amount: 29.99,
                currencyCode: 'USD',
                label: 'Apple Pay Button',
              ),
              buttonConfig: const ApplePayButtonConfig(),
              onPaymentSuccess: _handlePaymentSuccess,
              onPaymentError: _handlePaymentError,
            ),
            
            const SizedBox(height: 12.0),
            
            sdk.applePay.ui.createSimpleButton(
              amount: 19.99,
              onSuccess: _handlePaymentSuccess,
              onError: _handlePaymentError,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataOperations() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Data Operations',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            
            ElevatedButton(
              onPressed: _requestPaymentToken,
              child: const Text('Request Payment Token'),
            ),
            
            const SizedBox(height: 8.0),
            
            ElevatedButton(
              onPressed: _getMerchantInfo,
              child: const Text('Get Merchant Info'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    if (_lastResult == null) return const SizedBox.shrink();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Last Result',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() => _lastResult = null),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                _lastResult!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _requestPaymentToken() async {
    try {
      final token = await sdk.applePay.data.requestPaymentToken(
        const ApplePayRequest(amount: 29.99, currencyCode: 'USD', label: 'Demo'),
      );
      setState(() => _lastResult = 'Token: ${token.transactionIdentifier}');
    } catch (e) {
      setState(() => _lastResult = 'Error: $e');
    }
  }

  void _getMerchantInfo() {
    final info = sdk.applePay.data.getMerchantInfo();
    setState(() => _lastResult = 'Merchant info: $info');
  }

  void _handlePaymentSuccess(ApplePayToken token) {
    setState(() => _lastResult = 'Payment successful: ${token.transactionIdentifier}');
  }

  void _handlePaymentError(ApplePayException error) {
    setState(() => _lastResult = 'Payment failed: ${error.message}');
  }
}