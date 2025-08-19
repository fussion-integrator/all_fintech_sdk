import 'package:flutter/material.dart';
import '../models/opay_models.dart';
import '../data/opay_data_service.dart';
import 'widgets/opay_payment_sheet.dart';

class OpayUIService {
  final OpayDataService _dataService;

  OpayUIService(this._dataService);

  Future<void> showPaymentSheet({
    required BuildContext context,
    required int amount,
    String currency = 'EUR',
    required String orderNr,
    required String redirectUrl,
    required String webServiceUrl,
    required String standard,
    String? customerEmail,
    String? customerMobile,
    String? paymentDescription,
    required Function(OpayTransaction) onSuccess,
    required Function(String) onError,
    Function()? onCancel,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: OpayPaymentSheet(
          amount: amount,
          currency: currency,
          orderNr: orderNr,
          redirectUrl: redirectUrl,
          webServiceUrl: webServiceUrl,
          standard: standard,
          customerEmail: customerEmail,
          customerMobile: customerMobile,
          paymentDescription: paymentDescription,
          onSuccess: (transaction) {
            Navigator.of(context).pop();
            onSuccess(transaction);
          },
          onError: (error) {
            Navigator.of(context).pop();
            onError(error);
          },
          onCancel: () {
            Navigator.of(context).pop();
            onCancel?.call();
          },
        ),
      ),
    );
  }

  Future<void> showTransactionStatusDialog({
    required BuildContext context,
    required OpayTransaction transaction,
  }) async {
    final status = OpayPaymentStatus.fromValue(int.tryParse(transaction.status) ?? 5);
    
    String title;
    String message;
    IconData icon;
    Color color;

    switch (status) {
      case OpayPaymentStatus.completed:
        title = 'Payment Successful';
        message = 'Your payment has been completed successfully.';
        icon = Icons.check_circle;
        color = Colors.green;
        break;
      case OpayPaymentStatus.created:
        title = 'Payment Created';
        message = 'Your payment request has been created. Please complete the payment.';
        icon = Icons.info;
        color = Colors.blue;
        break;
      case OpayPaymentStatus.cancelled:
        title = 'Payment Cancelled';
        message = 'The payment has been cancelled.';
        icon = Icons.cancel;
        color = Colors.red;
        break;
      case OpayPaymentStatus.timeLimitExceeded:
        title = 'Payment Expired';
        message = 'The payment time limit has been exceeded.';
        icon = Icons.access_time;
        color = Colors.orange;
        break;
      case OpayPaymentStatus.notFinished:
      default:
        title = 'Payment Pending';
        message = 'The payment is still being processed.';
        icon = Icons.hourglass_empty;
        color = Colors.orange;
        break;
    }

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Transaction ID:'),
                      Text(
                        transaction.transactionId ?? 'N/A',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Order Number:'),
                      Text(transaction.orderNr),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Amount:'),
                      Text(
                        '${(transaction.amount / 100).toStringAsFixed(2)} ${transaction.currency}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> showRefundStatusDialog({
    required BuildContext context,
    required OpayRefund refund,
  }) async {
    String title;
    String message;
    IconData icon;
    Color color;

    switch (refund.status?.toLowerCase()) {
      case 'approved':
        title = 'Refund Approved';
        message = 'Your refund has been approved and will be processed.';
        icon = Icons.check_circle;
        color = Colors.green;
        break;
      case 'declined':
        title = 'Refund Declined';
        message = refund.message ?? 'Your refund request has been declined.';
        icon = Icons.cancel;
        color = Colors.red;
        break;
      case 'pending':
      default:
        title = 'Refund Pending';
        message = 'Your refund request is being processed.';
        icon = Icons.hourglass_empty;
        color = Colors.orange;
        break;
    }

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Refund Token:'),
                  Text(
                    refund.uniqueRefundToken,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}