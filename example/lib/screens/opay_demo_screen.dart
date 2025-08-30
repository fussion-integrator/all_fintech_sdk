import 'package:flutter/material.dart';
import 'package:all_fintech_flutter_sdk/all_fintech_flutter_sdk.dart';

class OpayDemoScreen extends StatefulWidget {
  const OpayDemoScreen({super.key});

  @override
  State<OpayDemoScreen> createState() => _OpayDemoScreenState();
}

class _OpayDemoScreenState extends State<OpayDemoScreen> {
  late AllFintechSDK sdk;
  String? _lastResult;

  @override
  void initState() {
    super.initState();
    sdk = AllFintechSDK.initialize(
      provider: FintechProvider.opay,
      apiKey: 'demo_website_id',
      publicKey: 'demo_password',
      isLive: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Opay Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildPaymentSection(),
            const SizedBox(height: 16.0),
            _buildChannelSection(),
            const SizedBox(height: 16.0),
            _buildRecurringSection(),
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
              onPressed: _initializePayment,
              child: const Text('Initialize Payment (₦4,000)'),
            ),
            const SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: _showPaymentSheet,
              child: const Text('Show Payment Sheet'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChannelSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Channels',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _payWithCard,
              child: const Text('Pay with Card'),
            ),
            const SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: _payWithBankTransfer,
              child: const Text('Pay with Bank Transfer'),
            ),
            const SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: _payWithUSSD,
              child: const Text('Pay with USSD'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecurringSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recurring Payments',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _setupRecurringPayment,
              child: const Text('Setup Recurring Payment'),
            ),
            const SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: _checkPaymentStatus,
              child: const Text('Check Payment Status'),
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
      setState(() {
        _lastResult = 'Payment Initialized:\n'
            'Order Number: ORD_${DateTime.now().millisecondsSinceEpoch}\n'
            'Amount: ₦4,000.00\n'
            'Currency: NGN\n'
            'Redirect URL: https://demo.com/success\n'
            'Webhook URL: https://demo.com/webhook\n'
            'Status: Pending';
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

  Future<void> _showPaymentSheet() async {
    try {
      setState(() {
        _lastResult = 'Payment Sheet Demo:\n'
            'Amount: ₦4,000.00\n'
            'Order Number: ORD_${DateTime.now().millisecondsSinceEpoch}\n'
            'Available Channels: Card, Transfer, USSD\n'
            'Standard: opay_8.1\n'
            'Status: Demo Mode - No actual payment processed';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment sheet demo completed!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() => _lastResult = 'Error: $e');
    }
  }

  Future<void> _payWithCard() async {
    try {
      setState(() {
        _lastResult = 'Card Payment:\n'
            'Transaction ID: TXN_${DateTime.now().millisecondsSinceEpoch}\n'
            'Amount: ₦4,000.00\n'
            'Payment Method: Card\n'
            'Card Type: Visa\n'
            'Last 4 Digits: 1234\n'
            'Status: Processing';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Card payment initiated!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() => _lastResult = 'Error: $e');
    }
  }

  Future<void> _payWithBankTransfer() async {
    try {
      setState(() {
        _lastResult = 'Bank Transfer Payment:\n'
            'Transaction ID: TXN_${DateTime.now().millisecondsSinceEpoch}\n'
            'Amount: ₦4,000.00\n'
            'Payment Method: Bank Transfer\n'
            'Account Number: 1234567890\n'
            'Bank: Opay\n'
            'Account Name: Demo Merchant\n'
            'Status: Awaiting Transfer';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bank transfer details generated!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() => _lastResult = 'Error: $e');
    }
  }

  Future<void> _payWithUSSD() async {
    try {
      setState(() {
        _lastResult = 'USSD Payment:\n'
            'Transaction ID: TXN_${DateTime.now().millisecondsSinceEpoch}\n'
            'Amount: ₦4,000.00\n'
            'Payment Method: USSD\n'
            'USSD Code: *955*123*456#\n'
            'Instructions: Dial the code and follow prompts\n'
            'Status: Awaiting USSD Dial';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('USSD payment code generated!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() => _lastResult = 'Error: $e');
    }
  }

  Future<void> _setupRecurringPayment() async {
    try {
      setState(() {
        _lastResult = 'Recurring Payment Setup:\n'
            'Subscription ID: SUB_${DateTime.now().millisecondsSinceEpoch}\n'
            'Amount: ₦4,000.00\n'
            'Frequency: Monthly\n'
            'Start Date: ${DateTime.now().toString().substring(0, 10)}\n'
            'Next Payment: ${DateTime.now().add(const Duration(days: 30)).toString().substring(0, 10)}\n'
            'Status: Active';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Recurring payment setup completed!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() => _lastResult = 'Error: $e');
    }
  }

  Future<void> _checkPaymentStatus() async {
    try {
      setState(() {
        _lastResult = 'Payment Status Check:\n'
            'Transaction ID: TXN_${DateTime.now().millisecondsSinceEpoch}\n'
            'Status: Successful\n'
            'Amount: ₦4,000.00\n'
            'Payment Method: Card\n'
            'Completed At: ${DateTime.now().toString().substring(0, 19)}\n'
            'Reference: OPY${DateTime.now().millisecondsSinceEpoch}';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment status retrieved!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() => _lastResult = 'Error: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}