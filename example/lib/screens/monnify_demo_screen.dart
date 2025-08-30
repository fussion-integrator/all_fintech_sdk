import 'package:flutter/material.dart';
import 'package:all_fintech_flutter_sdk/all_fintech_flutter_sdk.dart';

class MonnifyDemoScreen extends StatefulWidget {
  const MonnifyDemoScreen({super.key});

  @override
  State<MonnifyDemoScreen> createState() => _MonnifyDemoScreenState();
}

class _MonnifyDemoScreenState extends State<MonnifyDemoScreen> {
  late AllFintechSDK sdk;
  String? _lastResult;

  @override
  void initState() {
    super.initState();
    sdk = AllFintechSDK.initialize(
      provider: FintechProvider.monnify,
      apiKey: 'MK_TEST_demo_key',
      publicKey: 'MK_TEST_demo_secret',
      isLive: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monnify Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildReservedAccountSection(),
            const SizedBox(height: 16.0),
            _buildPaymentSection(),
            const SizedBox(height: 16.0),
            _buildTransferSection(),
            const SizedBox(height: 16.0),
            _buildResultCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildReservedAccountSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reserved Accounts',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _createReservedAccount,
              child: const Text('Create Reserved Account'),
            ),
            const SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: _getReservedAccountDetails,
              child: const Text('Get Account Details'),
            ),
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
              child: const Text('Initialize Transaction (₦3,000)'),
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
              onPressed: _initiateSingleTransfer,
              child: const Text('Single Transfer (₦2,000)'),
            ),
            const SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: _initiateBulkTransfer,
              child: const Text('Bulk Transfer'),
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

  Future<void> _createReservedAccount() async {
    try {
      setState(() {
        _lastResult = 'Reserved Account Created:\n'
            'Account Reference: ACC_${DateTime.now().millisecondsSinceEpoch}\n'
            'Account Number: 2345678901\n'
            'Bank Name: Providus Bank\n'
            'Account Name: John Doe\n'
            'Customer Email: demo@example.com\n'
            'Status: Active';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reserved account created!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() => _lastResult = 'Error: $e');
    }
  }

  Future<void> _getReservedAccountDetails() async {
    try {
      setState(() {
        _lastResult = 'Account Details:\n'
            'Account Number: 2345678901\n'
            'Bank Name: Providus Bank\n'
            'Account Name: John Doe\n'
            'Available Balance: ₦25,500.00\n'
            'Reserved Balance: ₦0.00\n'
            'Currency: NGN\n'
            'Status: Active\n'
            'Created: ${DateTime.now().toString().substring(0, 10)}';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account details retrieved!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() => _lastResult = 'Error: $e');
    }
  }

  Future<void> _initializeTransaction() async {
    try {
      setState(() {
        _lastResult = 'Transaction Initialized:\n'
            'Transaction Reference: TXN_${DateTime.now().millisecondsSinceEpoch}\n'
            'Amount: ₦3,000.00\n'
            'Customer Email: demo@example.com\n'
            'Payment Methods: Card, Bank Transfer, USSD\n'
            'Checkout URL: https://sandbox.monnify.com/checkout/demo\n'
            'Status: Pending';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transaction initialized!'),
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
            'Customer Name: John Doe\n'
            'Customer Email: demo@example.com\n'
            'Amount: ₦3,000.00\n'
            'Payment Reference: PAY_${DateTime.now().millisecondsSinceEpoch}\n'
            'Available Methods: Card, Transfer, USSD\n'
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

  Future<void> _initiateSingleTransfer() async {
    try {
      setState(() {
        _lastResult = 'Single Transfer Initiated:\n'
            'Transfer Reference: STF_${DateTime.now().millisecondsSinceEpoch}\n'
            'Amount: ₦2,000.00\n'
            'Recipient Name: Jane Smith\n'
            'Account Number: 0123456789\n'
            'Bank: Access Bank\n'
            'Narration: Payment for services\n'
            'Status: Processing';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Single transfer initiated!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() => _lastResult = 'Error: $e');
    }
  }

  Future<void> _initiateBulkTransfer() async {
    try {
      setState(() {
        _lastResult = 'Bulk Transfer Initiated:\n'
            'Batch Reference: BTF_${DateTime.now().millisecondsSinceEpoch}\n'
            'Total Amount: ₦5,000.00\n'
            'Number of Transfers: 3\n'
            '\nTransfers:\n'
            '1. Jane Smith - ₦2,000.00 (Access Bank)\n'
            '2. Mike Johnson - ₦1,500.00 (GTBank)\n'
            '3. Sarah Wilson - ₦1,500.00 (First Bank)\n'
            '\nStatus: Processing';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bulk transfer initiated!'),
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