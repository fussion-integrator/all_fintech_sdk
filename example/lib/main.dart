import 'package:flutter/material.dart';
import 'package:all_fintech_flutter_sdk/all_fintech_flutter_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'All Fintech SDK Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const DemoScreen(),
    );
  }
}

class DemoScreen extends StatefulWidget {
  const DemoScreen({Key? key}) : super(key: key);

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  late AllFintechSDK sdk;

  @override
  void initState() {
    super.initState();
    // Initialize SDK with test credentials
    sdk = AllFintechSDK.initialize(
      provider: FintechProvider.paystack,
      apiKey: 'pk_test_your_paystack_public_key',
      isLive: false,
    );
  }

  Future<void> _processPaystackPayment() async {
    await sdk.paystack.ui.showPaymentSheet(
      context: context,
      email: 'customer@example.com',
      amount: 50000, // ₦500.00 in kobo
      onSuccess: (transaction) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment successful: ${transaction.reference}')),
        );
      },
      onError: (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment failed: $error')),
        );
      },
    );
  }

  Future<void> _processFlutterwavePayment() async {
    final flutterwaveSDK = AllFintechSDK.initialize(
      provider: FintechProvider.flutterwave,
      apiKey: 'FLWPUBK_TEST-your_flutterwave_public_key',
      isLive: false,
    );

    await flutterwaveSDK.flutterwave.ui.showPaymentSheet(
      context: context,
      amount: 25000,
      currency: 'NGN',
      customerEmail: 'customer@example.com',
      onSuccess: (charge) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Flutterwave payment successful: ${charge.id}')),
        );
      },
      onError: (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment failed: $error')),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Fintech SDK Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Nigerian Fintech Integration Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            ElevatedButton.icon(
              onPressed: _processPaystackPayment,
              icon: const Icon(Icons.payment),
              label: const Text('Pay with Paystack (₦500)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 16),
            
            ElevatedButton.icon(
              onPressed: _processFlutterwavePayment,
              icon: const Icon(Icons.credit_card),
              label: const Text('Pay with Flutterwave (₦250)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 32),
            
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Supported Providers:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('✅ Paystack - Payments, Transfers, Subscriptions'),
                    Text('✅ Flutterwave - Charges, Virtual Accounts'),
                    Text('✅ Monnify - Reserved Accounts, Transfers'),
                    Text('✅ Opay - Payment Channels, Recurring'),
                    Text('✅ Open Banking - Account Data, Savings'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}