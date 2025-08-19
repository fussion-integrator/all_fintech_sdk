import 'package:flutter/material.dart';
import '../../../models/monnify_models.dart';
import '../data/monnify_data_service.dart';
import 'widgets/monnify_payment_sheet.dart';

class MonnifyUIService {
  final MonnifyDataService _dataService;

  MonnifyUIService(this._dataService);

  Future<MonnifyTransaction?> showPaymentSheet(
    BuildContext context, {
    required double amount,
    required String customerName,
    required String customerEmail,
    required String paymentDescription,
    required String contractCode,
  }) async {
    return await showModalBottomSheet<MonnifyTransaction>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MonnifyPaymentSheet(
        amount: amount,
        customerName: customerName,
        customerEmail: customerEmail,
        paymentDescription: paymentDescription,
        contractCode: contractCode,
        dataService: _dataService,
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  Future<void> showTransactionStatus(
    BuildContext context,
    String transactionReference,
  ) async {
    try {
      final result = await _dataService.getTransactionStatus(transactionReference);
      
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Transaction Status'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Reference: ${result.data?['transactionReference']}'),
                Text('Status: ${result.data?['paymentStatus']}'),
                Text('Amount: ₦${result.data?['amountPaid']}'),
                if (result.data?['paidOn'] != null)
                  Text('Paid On: ${result.data?['paidOn']}'),
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
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> showWalletBalance(
    BuildContext context,
    String accountNumber,
  ) async {
    try {
      final result = await _dataService.getWalletBalance(accountNumber);
      
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Wallet Balance'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Available Balance: ₦${result.data?.availableBalance.toStringAsFixed(2)}'),
                Text('Ledger Balance: ₦${result.data?.ledgerBalance.toStringAsFixed(2)}'),
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
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}