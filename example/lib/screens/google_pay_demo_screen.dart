import 'package:flutter/material.dart';
import 'package:all_fintech_flutter_sdk/all_fintech_flutter_sdk.dart';

/// Google Pay demo screen showcasing all features.
class GooglePayDemoScreen extends StatefulWidget {
  const GooglePayDemoScreen({super.key});

  @override
  State<GooglePayDemoScreen> createState() => _GooglePayDemoScreenState();
}

class _GooglePayDemoScreenState extends State<GooglePayDemoScreen> {
  late AllFintechSDK sdk;
  GooglePayAvailability? _availability;
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
      provider: FintechProvider.googlePay,
      apiKey: 'demo_merchant_id',
      publicKey: 'Demo Merchant Store',
      isLive: false,
    );
  }

  Future<void> _checkAvailability() async {
    setState(() => _isLoading = true);
    
    try {
      final availability = await sdk.googlePay.data.checkAvailability();
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
        title: const Text('Google Pay Demo'),
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
            _buildSheetDemos(),
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
              'Google Pay Availability',
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
                  if (_availability!.supportedNetworks.isNotEmpty) ...[
                    const SizedBox(height: 8.0),
                    Text(
                      'Supported Networks: ${_availability!.supportedNetworks.map((n) => n.name).join(', ')}',
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
              'Google Pay Buttons',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            
            sdk.googlePay.ui.showGooglePayButton(
              paymentRequest: const GooglePayRequest(
                amount: 29.99,
                currencyCode: 'USD',
                label: 'Dark Theme Button',
              ),
              buttonConfig: const GooglePayButtonConfig(
                type: GooglePayButtonType.buy,
                theme: GooglePayButtonTheme.dark,
                width: double.infinity,
              ),
              onPaymentSuccess: _handlePaymentSuccess,
              onPaymentError: _handlePaymentError,
            ),
            
            const SizedBox(height: 12.0),
            
            sdk.googlePay.ui.createSimpleButton(
              amount: 19.99,
              onSuccess: _handlePaymentSuccess,
              onError: _handlePaymentError,
              type: GooglePayButtonType.donate,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSheetDemos() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Operations',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            
            ElevatedButton(
              onPressed: _showPaymentSheet,
              child: const Text('Show Payment Sheet'),
            ),
            
            const SizedBox(height: 8.0),
            
            ElevatedButton(
              onPressed: _showPaymentDialog,
              child: const Text('Show Payment Dialog'),
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

  void _showPaymentSheet() {
    setState(() => _lastResult = 'Payment sheet demo');
  }

  void _showPaymentDialog() {
    setState(() => _lastResult = 'Payment dialog demo');
  }

  Future<void> _requestPaymentToken() async {
    try {
      final token = await sdk.googlePay.data.requestPaymentToken(
        const GooglePayRequest(amount: 29.99, currencyCode: 'USD', label: 'Demo'),
      );
      setState(() => _lastResult = 'Token: ${token.token}');
    } catch (e) {
      setState(() => _lastResult = 'Error: $e');
    }
  }

  void _getMerchantInfo() {
    final info = sdk.googlePay.data.getMerchantInfo();
    setState(() => _lastResult = 'Merchant info: $info');
  }

  void _handlePaymentSuccess(GooglePayToken token) {
    setState(() => _lastResult = 'Payment successful: ${token.token}');
  }

  void _handlePaymentError(GooglePayException error) {
    setState(() => _lastResult = 'Payment failed: ${error.message}');
  }
}