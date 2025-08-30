import 'package:flutter/material.dart';
import 'package:all_fintech_flutter_sdk/all_fintech_flutter_sdk.dart';

class TransactPayDemoScreen extends StatefulWidget {
  const TransactPayDemoScreen({super.key});

  @override
  State<TransactPayDemoScreen> createState() => _TransactPayDemoScreenState();
}

class _TransactPayDemoScreenState extends State<TransactPayDemoScreen> {
  late AllFintechSDK sdk;
  String? _lastResult;

  @override
  void initState() {
    super.initState();
    sdk = AllFintechSDK.initialize(
      provider: FintechProvider.transactpay,
      apiKey: 'PGW-PUBLICKEY-TEST-5D9411AB210740019FF1374C896D86D0',
      publicKey: 'PGW-SECRETKEY-TEST-AA5F84F420514F7DB6CD7938B398727C',
      isLive: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TransactPay Demo'),
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
            _buildCustomerSection(),
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
              'Payment Operations',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _initializePayment,
              child: const Text('Initialize Payment (₦75,000)'),
            ),
            const SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: _verifyPayment,
              child: const Text('Verify Payment'),
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
              onPressed: _createOrder,
              child: const Text('Create Order'),
            ),
            const SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: _generateReference,
              child: const Text('Generate Reference'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customer & Config',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _createCustomer,
              child: const Text('Create Customer'),
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

  Future<void> _initializePayment() async {
    try {
      final customer = sdk.transactpay.data.createCustomer(
        firstname: 'John',
        lastname: 'Doe',
        email: 'john.doe@example.com',
        mobile: '+2348064255905',
        country: 'NG',
      );

      final order = sdk.transactpay.data.createOrder(
        amount: 75000.00,
        reference: sdk.transactpay.data.generateReference(prefix: 'TXP'),
        description: 'Payment for premium services',
        currency: 'NGN',
      );

      final request = sdk.transactpay.data.createPaymentRequest(
        customer: customer,
        order: order,
        redirectUrl: 'https://example.com/success',
      );

      setState(() {
        _lastResult = 'Payment Request Created:\n'
            'Customer: ${customer.firstname} ${customer.lastname}\n'
            'Email: ${customer.email}\n'
            'Mobile: ${customer.mobile}\n'
            'Amount: ₦${order.amount.toStringAsFixed(2)}\n'
            'Reference: ${order.reference}\n'
            'Description: ${order.description}\n'
            'Currency: ${order.currency}\n'
            'Redirect URL: ${request.payment.redirectUrl}\n'
            'Status: Demo Mode - Use actual SDK for real payments';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment initialized successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() => _lastResult = 'Error: $e');
    }
  }

  Future<void> _verifyPayment() async {
    try {
      final reference = 'TXP_${DateTime.now().millisecondsSinceEpoch}_1234';
      
      setState(() {
        _lastResult = 'Payment Verification:\n'
            'Reference: $reference\n'
            'Status: SUCCESSFUL\n'
            'Amount: ₦75,000.00\n'
            'Currency: NGN\n'
            'Message: Payment completed successfully\n'
            'Timestamp: ${DateTime.now().toString().substring(0, 19)}\n'
            'Note: This is a demo simulation';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment verified successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() => _lastResult = 'Error: $e');
    }
  }

  void _createOrder() {
    try {
      final order = sdk.transactpay.data.createOrder(
        amount: 45000.00,
        reference: sdk.transactpay.data.generateReference(prefix: 'ORD'),
        description: 'Digital product purchase',
        currency: 'NGN',
      );

      setState(() {
        _lastResult = 'Order Created:\n'
            'Reference: ${order.reference}\n'
            'Amount: ₦${order.amount.toStringAsFixed(2)}\n'
            'Description: ${order.description}\n'
            'Currency: ${order.currency}\n'
            'Created: ${DateTime.now().toString().substring(0, 19)}';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() => _lastResult = 'Error: $e');
    }
  }

  void _generateReference() {
    try {
      final reference1 = sdk.transactpay.data.generateReference();
      final reference2 = sdk.transactpay.data.generateReference(prefix: 'PAY');
      final reference3 = sdk.transactpay.data.generateReference(prefix: 'SUB');

      setState(() {
        _lastResult = 'Generated References:\n'
            'Default: $reference1\n'
            'Payment: $reference2\n'
            'Subscription: $reference3\n'
            'Generated: ${DateTime.now().toString().substring(0, 19)}';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('References generated!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() => _lastResult = 'Error: $e');
    }
  }

  void _createCustomer() {
    try {
      final customer = sdk.transactpay.data.createCustomer(
        firstname: 'Jane',
        lastname: 'Smith',
        email: 'jane.smith@example.com',
        mobile: '+2347012345678',
        country: 'NG',
      );

      setState(() {
        _lastResult = 'Customer Created:\n'
            'Name: ${customer.firstname} ${customer.lastname}\n'
            'Email: ${customer.email}\n'
            'Mobile: ${customer.mobile}\n'
            'Country: ${customer.country}\n'
            'Created: ${DateTime.now().toString().substring(0, 19)}';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Customer created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() => _lastResult = 'Error: $e');
    }
  }

  void _getMerchantInfo() {
    final info = sdk.transactpay.data.getMerchantInfo();
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
    sdk.transactpay.dispose();
    super.dispose();
  }
}