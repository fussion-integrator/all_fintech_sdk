import 'package:flutter/material.dart';
import '../../../../models/monnify_models.dart';
import '../../data/monnify_data_service.dart';

class MonnifyPaymentSheet extends StatefulWidget {
  final double amount;
  final String customerName;
  final String customerEmail;
  final String paymentDescription;
  final String contractCode;
  final MonnifyDataService dataService;
  final VoidCallback? onCancel;

  const MonnifyPaymentSheet({
    super.key,
    required this.amount,
    required this.customerName,
    required this.customerEmail,
    required this.paymentDescription,
    required this.contractCode,
    required this.dataService,
    this.onCancel,
  });

  @override
  State<MonnifyPaymentSheet> createState() => _MonnifyPaymentSheetState();
}

class _MonnifyPaymentSheetState extends State<MonnifyPaymentSheet> {
  bool _isLoading = false;
  MonnifyTransaction? _transaction;

  @override
  void initState() {
    super.initState();
    _initializePayment();
  }

  Future<void> _initializePayment() async {
    setState(() => _isLoading = true);

    try {
      final request = MonnifyTransactionRequest(
        amount: widget.amount,
        customerName: widget.customerName,
        customerEmail: widget.customerEmail,
        paymentReference: 'PAY_${DateTime.now().millisecondsSinceEpoch}',
        paymentDescription: widget.paymentDescription,
        currencyCode: 'NGN',
        contractCode: widget.contractCode,
        paymentMethods: ['CARD', 'ACCOUNT_TRANSFER'],
      );

      final result = await widget.dataService.initializeTransaction(request);
      setState(() {
        _transaction = result.data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Monnify Payment',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_transaction != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Amount:', style: TextStyle(color: Colors.grey[600])),
                      Text(
                        '₦${widget.amount.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Customer:', style: TextStyle(color: Colors.grey[600])),
                      Text(widget.customerName),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Reference:', style: TextStyle(color: Colors.grey[600])),
                      Text(_transaction!.paymentReference),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Payment Methods',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...(_transaction!.enabledPaymentMethod.map((method) => 
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Icon(
                    method == 'CARD' ? Icons.credit_card : Icons.account_balance,
                    color: Colors.blue,
                  ),
                  title: Text(method == 'CARD' ? 'Card Payment' : 'Bank Transfer'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _handlePaymentMethod(method),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
              ),
            )),
            const SizedBox(height: 20),
            Row(
              children: [
                if (widget.onCancel != null)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: widget.onCancel,
                      child: const Text('Cancel'),
                    ),
                  ),
                if (widget.onCancel != null) const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _openCheckout(),
                    child: const Text('Pay Now'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _handlePaymentMethod(String method) {
    if (method == 'ACCOUNT_TRANSFER') {
      _showBankTransferDetails();
    } else {
      _openCheckout();
    }
  }

  void _showBankTransferDetails() async {
    try {
      final result = await widget.dataService.payWithBankTransfer(
        transactionReference: _transaction!.transactionReference,
      );
      
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Bank Transfer Details'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Account Number: ${result.data?['accountNumber']}'),
                Text('Bank: ${result.data?['bankName']}'),
                Text('Amount: ₦${result.data?['totalPayable']}'),
                if (result.data?['ussdPayment'] != null)
                  Text('USSD: ${result.data?['ussdPayment']}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _openCheckout() {
    // Open Monnify checkout URL in webview or browser
    Navigator.pop(context, _transaction);
  }
}