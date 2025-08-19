import 'package:flutter/material.dart';
import '../../../../models/flutterwave_models.dart';
import '../../data/flutterwave_data_service.dart';

class FlutterwavePaymentSheet extends StatefulWidget {
  final String txRef;
  final int amount;
  final String currency;
  final String redirectUrl;
  final FlutterwaveCustomer customer;
  final Map<String, dynamic>? customizations;
  final FlutterwaveDataService dataService;

  const FlutterwavePaymentSheet({
    Key? key,
    required this.txRef,
    required this.amount,
    required this.currency,
    required this.redirectUrl,
    required this.customer,
    this.customizations,
    required this.dataService,
  }) : super(key: key);

  @override
  State<FlutterwavePaymentSheet> createState() => _FlutterwavePaymentSheetState();
}

class _FlutterwavePaymentSheetState extends State<FlutterwavePaymentSheet> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.payment, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Flutterwave Payment',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildPaymentDetails(),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _processPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Pay Now',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Details',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          _buildDetailRow('Amount', '${widget.currency} ${widget.amount}'),
          _buildDetailRow('Reference', widget.txRef),
          _buildDetailRow('Customer', widget.customer.email),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Future<void> _processPayment() async {
    setState(() => _isLoading = true);

    try {
      final request = FlutterwavePaymentRequest(
        txRef: widget.txRef,
        amount: widget.amount,
        currency: widget.currency,
        redirectUrl: widget.redirectUrl,
        customer: widget.customer,
        customizations: widget.customizations,
      );

      final response = await widget.dataService.initializePayment(request);
      
      if (response.success && mounted) {
        // In a real implementation, you would open the payment URL
        // For now, we'll simulate a successful payment
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment initialized successfully')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}