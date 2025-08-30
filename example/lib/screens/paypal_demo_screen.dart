import 'package:flutter/material.dart';
import 'package:all_fintech_flutter_sdk/all_fintech_flutter_sdk.dart';

class PayPalDemoScreen extends StatefulWidget {
  const PayPalDemoScreen({super.key});

  @override
  State<PayPalDemoScreen> createState() => _PayPalDemoScreenState();
}

class _PayPalDemoScreenState extends State<PayPalDemoScreen> {
  late AllFintechSDK sdk;
  String? _lastResult;

  @override
  void initState() {
    super.initState();
    sdk = AllFintechSDK.initialize(
      provider: FintechProvider.paypal,
      apiKey: 'demo_client_id',
      publicKey: 'demo_client_secret',
      isLive: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PayPal Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildPaymentSection(),
            const SizedBox(height: 16.0),
            _buildOrderSection(),
            const SizedBox(height: 16.0),
            _buildItemsSection(),
            const SizedBox(height: 16.0),
            _buildResultCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payments',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _createSimplePayment,
              child: const Text('Create Simple Payment (\$25.00)'),
            ),
            const SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: _createPaymentWithItems,
              child: const Text('Create Payment with Items'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Management',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _capturePayment,
              child: const Text('Capture Payment'),
            ),
            const SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: _getPaymentDetails,
              child: const Text('Get Payment Details'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Advanced Features',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _createSubscriptionPayment,
              child: const Text('Create Subscription Payment'),
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
                color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
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

  Future<void> _createSimplePayment() async {
    try {
      final request = sdk.paypal.data.createPaymentRequest(
        amount: 25.00,
        description: 'Simple PayPal Payment Demo',
      );
      
      final response = await sdk.paypal.data.createPayment(request);
      
      setState(() {
        _lastResult = 'Payment Created:\n'
            'Order ID: ${response.id}\n'
            'Status: ${response.status.name}\n'
            'Amount: \$${response.amount.value} ${response.amount.currencyCode}\n'
            'Intent: ${response.intent.name}\n'
            'Approval URL: ${response.approvalUrl ?? 'Not available'}\n'
            'Created: ${response.createTime?.toString().substring(0, 19) ?? 'Unknown'}';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() => _lastResult = 'Error: $e');
    }
  }

  Future<void> _createPaymentWithItems() async {
    try {
      final items = [
        sdk.paypal.data.createItem(
          name: 'Premium Subscription',
          unitPrice: 19.99,
          quantity: 1,
          description: 'Monthly premium subscription',
          sku: 'PREMIUM-001',
          category: 'DIGITAL_GOODS',
        ),
        sdk.paypal.data.createItem(
          name: 'Setup Fee',
          unitPrice: 5.00,
          quantity: 1,
          description: 'One-time setup fee',
          sku: 'SETUP-001',
          category: 'SERVICE',
        ),
      ];
      
      final request = sdk.paypal.data.createPaymentRequest(
        amount: 24.99,
        description: 'Premium Subscription with Setup',
        items: items,
      );
      
      final response = await sdk.paypal.data.createPayment(request);
      
      setState(() {
        _lastResult = 'Payment with Items Created:\n'
            'Order ID: ${response.id}\n'
            'Status: ${response.status.name}\n'
            'Total Amount: \$${response.amount.value}\n'
            'Items: ${items.length} items\n'
            'Item 1: ${items[0].name} - \$${items[0].unitAmount.value}\n'
            'Item 2: ${items[1].name} - \$${items[1].unitAmount.value}\n'
            'Approval URL: ${response.approvalUrl != null ? 'Available' : 'Not available'}';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment with items created!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() => _lastResult = 'Error: $e');
    }
  }

  Future<void> _capturePayment() async {
    try {
      // Simulate capturing a payment with a demo order ID
      final demoOrderId = 'ORDER_${DateTime.now().millisecondsSinceEpoch}';
      
      setState(() {
        _lastResult = 'Payment Capture Simulation:\n'
            'Order ID: $demoOrderId\n'
            'Capture ID: CAPTURE_${DateTime.now().millisecondsSinceEpoch}\n'
            'Status: COMPLETED\n'
            'Amount: \$25.00 USD\n'
            'Seller Protection: ELIGIBLE\n'
            'Final Capture: true\n'
            'Captured At: ${DateTime.now().toString().substring(0, 19)}\n'
            'Note: This is a demo simulation';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment capture simulated!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() => _lastResult = 'Error: $e');
    }
  }

  Future<void> _getPaymentDetails() async {
    try {
      final demoOrderId = 'ORDER_${DateTime.now().millisecondsSinceEpoch}';
      
      setState(() {
        _lastResult = 'Payment Details:\n'
            'Order ID: $demoOrderId\n'
            'Status: APPROVED\n'
            'Intent: CAPTURE\n'
            'Amount: \$25.00 USD\n'
            'Payer Email: demo@example.com\n'
            'Payer Name: John Doe\n'
            'Created: ${DateTime.now().subtract(const Duration(minutes: 5)).toString().substring(0, 19)}\n'
            'Updated: ${DateTime.now().toString().substring(0, 19)}\n'
            'Note: This is demo data';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment details retrieved!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() => _lastResult = 'Error: $e');
    }
  }

  Future<void> _createSubscriptionPayment() async {
    try {
      final address = sdk.paypal.data.createAddress(
        addressLine1: '123 Main Street',
        city: 'New York',
        state: 'NY',
        postalCode: '10001',
        countryCode: 'US',
      );
      
      final request = sdk.paypal.data.createPaymentRequest(
        amount: 29.99,
        description: 'Monthly Subscription Payment',
        intent: PayPalIntent.capture,
        shippingAddress: address,
      );
      
      final response = await sdk.paypal.data.createPayment(request);
      
      setState(() {
        _lastResult = 'Subscription Payment Created:\n'
            'Order ID: ${response.id}\n'
            'Status: ${response.status.name}\n'
            'Amount: \$${response.amount.value}\n'
            'Description: Monthly Subscription\n'
            'Shipping Address: 123 Main Street, New York, NY\n'
            'Intent: ${response.intent.name}\n'
            'Approval Required: ${response.approvalUrl != null ? 'Yes' : 'No'}';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Subscription payment created!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() => _lastResult = 'Error: $e');
    }
  }

  void _getMerchantInfo() {
    final info = sdk.paypal.data.getMerchantInfo();
    setState(() {
      _lastResult = 'Merchant Configuration:\n${info.entries.map((e) => '${e.key}: ${e.value}').join('\n')}';
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Merchant info retrieved!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    sdk.paypal.dispose();
    super.dispose();
  }
}