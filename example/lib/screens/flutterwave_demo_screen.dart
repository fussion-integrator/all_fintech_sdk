import 'package:flutter/material.dart';
import 'package:all_fintech_flutter_sdk/all_fintech_flutter_sdk.dart';

class FlutterwaveDemoScreen extends StatefulWidget {
  const FlutterwaveDemoScreen({super.key});

  @override
  State<FlutterwaveDemoScreen> createState() => _FlutterwaveDemoScreenState();
}

class _FlutterwaveDemoScreenState extends State<FlutterwaveDemoScreen> {
  late AllFintechSDK sdk;
  String? _lastResult;

  @override
  void initState() {
    super.initState();
    sdk = AllFintechSDK.initialize(
      provider: FintechProvider.flutterwave,
      apiKey: 'FLWPUBK_TEST-demo-key',
      isLive: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutterwave Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildChargeSection(),
            const SizedBox(height: 16.0),
            _buildVirtualAccountSection(),
            const SizedBox(height: 16.0),
            _buildTransferSection(),
            const SizedBox(height: 16.0),
            _buildResultCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildChargeSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Charges',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _createCharge,
              child: const Text('Create Charge (₦2,500)'),
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

  Widget _buildVirtualAccountSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Virtual Accounts',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _createVirtualAccount,
              child: const Text('Create Virtual Account'),
            ),
            const SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: _getVirtualAccountBalance,
              child: const Text('Get Account Balance'),
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
              onPressed: _initiateTransfer,
              child: const Text('Initiate Transfer (₦1,500)'),
            ),
            const SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: _getBanks,
              child: const Text('Get Banks List'),
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

  Future<void> _createCharge() async {
    try {
      setState(() {
        _lastResult = 'Charge Created:\n'
            'Charge ID: CHG_${DateTime.now().millisecondsSinceEpoch}\n'
            'Amount: ₦2,500.00\n'
            'Currency: NGN\n'
            'Customer: demo@example.com\n'
            'Status: Pending';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Charge created successfully!'),
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
            'Customer Email: demo@example.com\n'
            'Amount: ₦2,500.00\n'
            'Payment Methods: Card, Bank Transfer, USSD\n'
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

  Future<void> _createVirtualAccount() async {
    try {
      setState(() {
        _lastResult = 'Virtual Account Created:\n'
            'Account Number: 1234567890\n'
            'Bank Name: Wema Bank\n'
            'Account Name: John Doe\n'
            'Reference: VA_${DateTime.now().millisecondsSinceEpoch}\n'
            'Status: Active';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Virtual account created!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() => _lastResult = 'Error: $e');
    }
  }

  Future<void> _getVirtualAccountBalance() async {
    try {
      setState(() {
        _lastResult = 'Account Balance:\n'
            'Available Balance: ₦15,750.00\n'
            'Ledger Balance: ₦15,750.00\n'
            'Currency: NGN\n'
            'Last Updated: ${DateTime.now().toString().substring(0, 19)}';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Balance retrieved successfully!'),
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
            'Transfer ID: TXN_${DateTime.now().millisecondsSinceEpoch}\n'
            'Amount: ₦1,500.00\n'
            'Recipient: 0987654321\n'
            'Bank: GTBank\n'
            'Status: Processing';
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

  Future<void> _getBanks() async {
    try {
      setState(() {
        _lastResult = 'Nigerian Banks:\n'
            '• Access Bank - 044\n'
            '• GTBank - 058\n'
            '• First Bank - 011\n'
            '• Zenith Bank - 057\n'
            '• UBA - 033\n'
            '• Fidelity Bank - 070\n'
            '• Union Bank - 032\n'
            '• Sterling Bank - 232\n'
            '• Wema Bank - 035\n'
            '• FCMB - 214';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Banks list retrieved!'),
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