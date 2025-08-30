import 'package:flutter/material.dart';
import 'package:all_fintech_flutter_sdk/all_fintech_flutter_sdk.dart';

class PaystackDemoScreen extends StatefulWidget {
  const PaystackDemoScreen({super.key});

  @override
  State<PaystackDemoScreen> createState() => _PaystackDemoScreenState();
}

class _PaystackDemoScreenState extends State<PaystackDemoScreen> {
  late AllFintechSDK sdk;
  String? _lastResult;

  @override
  void initState() {
    super.initState();
    sdk = AllFintechSDK.initialize(
      provider: FintechProvider.paystack,
      apiKey: 'pk_test_demo_key',
      isLive: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paystack Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildPaymentSection(),
            const SizedBox(height: 16.0),
            _buildTransferSection(),
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
              'Payments',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _initializeTransaction,
              child: const Text('Initialize Transaction (₦5,000)'),
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

  Widget _buildTransferSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Transfers',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _createTransferRecipient,
              child: const Text('Create Transfer Recipient'),
            ),
            const SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: _initiateTransfer,
              child: const Text('Initiate Transfer (₦1,000)'),
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
              'Customers',
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
              onPressed: _showCustomerForm,
              child: const Text('Show Customer Form'),
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

  Future<void> _initializeTransaction() async {
    try {
      setState(() {
        _lastResult = 'Transaction Initialized:\n'
            'Reference: txn_${DateTime.now().millisecondsSinceEpoch}\n'
            'Amount: ₦5,000.00\n'
            'Status: Pending\n'
            'Authorization URL: https://checkout.paystack.com/demo';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transaction initialized successfully!'),
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
            'Email: demo@example.com\n'
            'Amount: ₦5,000.00\n'
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

  Future<void> _createTransferRecipient() async {
    try {
      setState(() {
        _lastResult = 'Transfer Recipient Created:\n'
            'Recipient Code: RCP_${DateTime.now().millisecondsSinceEpoch}\n'
            'Name: John Doe\n'
            'Account: 0123456789\n'
            'Bank: Access Bank';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transfer recipient created!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() => _lastResult = 'Error: $e');
    }
  }

  Future<void> _initiateTransfer() async {
    try {
      setState(() {
        _lastResult = 'Transfer Initiated:\n'
            'Transfer Code: TRF_${DateTime.now().millisecondsSinceEpoch}\n'
            'Amount: ₦1,000.00\n'
            'Recipient: John Doe\n'
            'Status: Pending';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transfer initiated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() => _lastResult = 'Error: $e');
    }
  }

  Future<void> _createCustomer() async {
    try {
      setState(() {
        _lastResult = 'Customer Created:\n'
            'Customer Code: CUS_${DateTime.now().millisecondsSinceEpoch}\n'
            'Email: demo@example.com\n'
            'First Name: John\n'
            'Last Name: Doe\n'
            'Phone: +2348123456789';
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

  Future<void> _showCustomerForm() async {
    try {
      setState(() {
        _lastResult = 'Customer Form Demo:\n'
            'Form displayed with fields:\n'
            '- Email\n'
            '- First Name\n'
            '- Last Name\n'
            '- Phone Number';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Customer form demo completed!'),
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