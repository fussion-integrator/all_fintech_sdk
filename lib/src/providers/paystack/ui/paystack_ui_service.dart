import 'package:flutter/material.dart';
import '../../../models/payment_request.dart';
import '../../../models/transaction.dart';
import '../../../models/customer.dart';
import '../../../models/subscription.dart';
import '../data/paystack_data_service.dart';
import 'payment_sheet.dart';
import 'customer_form.dart';
import 'subscription_form.dart';
import 'product_form.dart';
import 'transfer_recipient_form.dart';
import 'transfer_form.dart';

class PaystackUIService {
  final PaystackDataService _dataService;

  PaystackUIService(this._dataService);

  /// Show payment sheet with card input
  Future<Transaction?> showPaymentSheet(
    BuildContext context,
    PaymentRequest paymentRequest,
  ) async {
    Transaction? result;
    String? error;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: PaystackPaymentSheet(
          paymentRequest: paymentRequest,
          dataService: _dataService,
          onSuccess: (transaction) {
            result = transaction;
          },
          onError: (errorMessage) {
            error = errorMessage;
          },
        ),
      ),
    );

    if (error != null) {
      throw Exception(error);
    }

    return result;
  }

  /// Show success dialog
  static void showSuccessDialog(
    BuildContext context,
    Transaction transaction,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.green[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check,
                size: 40,
                color: Colors.green[600],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Payment Successful!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.green[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Amount: ${_formatAmount(transaction.amount)} ${transaction.currency}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Reference: ${transaction.reference}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  /// Show error dialog
  static void showErrorDialog(
    BuildContext context,
    String message,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.red[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 40,
                color: Colors.red[600],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Payment Failed',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.red[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  /// Show loading dialog
  static void showLoadingDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Show customer form
  Future<Customer?> showCustomerForm(
    BuildContext context, {
    CustomerRequest? initialData,
    String submitButtonText = 'Create Customer',
  }) async {
    Customer? result;
    String? error;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: CustomerForm(
          initialData: initialData,
          submitButtonText: submitButtonText,
          onSubmit: (request) async {
            try {
              showLoadingDialog(context, 'Creating customer...');
              final response = await _dataService.createCustomer(request);
              Navigator.of(context).pop(); // Close loading
              
              if (response.isSuccess && response.data != null) {
                result = response.data;
                Navigator.of(context).pop(); // Close form
              } else {
                error = response.message;
              }
            } catch (e) {
              Navigator.of(context).pop(); // Close loading
              error = e.toString();
            }
          },
        ),
      ),
    );

    if (error != null) {
      showErrorDialog(context, error!);
    }

    return result;
  }

  /// Show customer list
  Future<Customer?> showCustomerList(
    BuildContext context, {
    bool allowSelection = true,
  }) async {
    return await Navigator.of(context).push<Customer>(
      MaterialPageRoute(
        builder: (context) => CustomerListScreen(
          dataService: _dataService,
          allowSelection: allowSelection,
        ),
      ),
    );
  }

  /// Show transaction history for customer
  Future<void> showCustomerTransactions(
    BuildContext context,
    String customerCode,
  ) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CustomerTransactionsScreen(
          dataService: _dataService,
          customerCode: customerCode,
        ),
      ),
    );
  }

  /// Show product form
  Future<Product?> showProductForm(
    BuildContext context, {
    ProductRequest? initialData,
  }) async {
    Product? result;
    String? error;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ProductForm(
          initialData: initialData,
          onSubmit: (request) async {
            try {
              showLoadingDialog(context, 'Saving product...');
              final response = await _dataService.createProduct(request);
              Navigator.of(context).pop();
              
              if (response.isSuccess && response.data != null) {
                result = response.data;
                Navigator.of(context).pop();
              } else {
                error = response.message;
              }
            } catch (e) {
              Navigator.of(context).pop();
              error = e.toString();
            }
          },
        ),
      ),
    );

    if (error != null) {
      showErrorDialog(context, error!);
    }

    return result;
  }

  /// Show transfer form
  Future<Transfer?> showTransferForm(BuildContext context) async {
    Transfer? result;
    String? error;

    final recipientsResponse = await _dataService.listTransferRecipients();
    if (!recipientsResponse.isSuccess) {
      showErrorDialog(context, 'Failed to load recipients');
      return null;
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: TransferForm(
          recipients: recipientsResponse.data!,
          onSubmit: (request) async {
            try {
              showLoadingDialog(context, 'Sending money...');
              final response = await _dataService.initiateTransfer(request);
              Navigator.of(context).pop();
              
              if (response.isSuccess && response.data != null) {
                result = response.data;
                Navigator.of(context).pop();
              } else {
                error = response.message;
              }
            } catch (e) {
              Navigator.of(context).pop();
              error = e.toString();
            }
          },
        ),
      ),
    );

    if (error != null) {
      showErrorDialog(context, error!);
    }

    return result;
  }

  /// Show transfer recipient form
  Future<TransferRecipient?> showTransferRecipientForm(
    BuildContext context,
  ) async {
    TransferRecipient? result;
    String? error;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: TransferRecipientForm(
          onSubmit: (request) async {
            try {
              showLoadingDialog(context, 'Adding recipient...');
              final response = await _dataService.createTransferRecipient(request);
              Navigator.of(context).pop();
              
              if (response.isSuccess && response.data != null) {
                result = response.data;
                Navigator.of(context).pop();
              } else {
                error = response.message;
              }
            } catch (e) {
              Navigator.of(context).pop();
              error = e.toString();
            }
          },
        ),
      ),
    );

    if (error != null) {
      showErrorDialog(context, error!);
    }

    return result;
  }

  /// Show subscription form
  Future<Subscription?> showSubscriptionForm(BuildContext context) async {
    Subscription? result;
    String? error;

    final plansResponse = await _dataService.listPlans();
    final customersResponse = await _dataService.listCustomers();

    if (!plansResponse.isSuccess || !customersResponse.isSuccess) {
      showErrorDialog(context, 'Failed to load required data');
      return null;
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SubscriptionForm(
          plans: plansResponse.data!,
          customers: customersResponse.data!,
          onSubmit: (request) async {
            try {
              showLoadingDialog(context, 'Creating subscription...');
              final response = await _dataService.createSubscription(request);
              Navigator.of(context).pop();
              
              if (response.isSuccess && response.data != null) {
                result = response.data;
                Navigator.of(context).pop();
              } else {
                error = response.message;
              }
            } catch (e) {
              Navigator.of(context).pop();
              error = e.toString();
            }
          },
        ),
      ),
    );

    if (error != null) {
      showErrorDialog(context, error!);
    }

    return result;
  }

  static String _formatAmount(int amount) {
    return (amount / 100).toStringAsFixed(2);
  }
}

// Customer List Screen
class CustomerListScreen extends StatefulWidget {
  final PaystackDataService dataService;
  final bool allowSelection;

  const CustomerListScreen({
    super.key,
    required this.dataService,
    this.allowSelection = true,
  });

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  List<Customer> customers = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  Future<void> _loadCustomers() async {
    try {
      final response = await widget.dataService.listCustomers();
      if (response.isSuccess && response.data != null) {
        setState(() {
          customers = response.data!;
          isLoading = false;
        });
      } else {
        setState(() {
          error = response.message;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, size: 64, color: Colors.red[400]),
                      const SizedBox(height: 16),
                      Text(error!, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                            error = null;
                          });
                          _loadCustomers();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: customers.length,
                  itemBuilder: (context, index) {
                    final customer = customers[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue[100],
                        child: Text(
                          customer.email[0].toUpperCase(),
                          style: TextStyle(color: Colors.blue[800]),
                        ),
                      ),
                      title: Text(
                        '${customer.firstName ?? ''} ${customer.lastName ?? ''}'.trim().isEmpty
                            ? customer.email
                            : '${customer.firstName ?? ''} ${customer.lastName ?? ''}'.trim(),
                      ),
                      subtitle: Text(customer.email),
                      trailing: widget.allowSelection
                          ? const Icon(Icons.arrow_forward_ios)
                          : null,
                      onTap: widget.allowSelection
                          ? () => Navigator.of(context).pop(customer)
                          : null,
                    );
                  },
                ),
    );
  }
}

// Customer Transactions Screen
class CustomerTransactionsScreen extends StatefulWidget {
  final PaystackDataService dataService;
  final String customerCode;

  const CustomerTransactionsScreen({
    super.key,
    required this.dataService,
    required this.customerCode,
  });

  @override
  State<CustomerTransactionsScreen> createState() => _CustomerTransactionsScreenState();
}

class _CustomerTransactionsScreenState extends State<CustomerTransactionsScreen> {
  List<Transaction> transactions = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    try {
      final response = await widget.dataService.listTransactions(
        customer: widget.customerCode,
      );
      if (response.isSuccess && response.data != null) {
        setState(() {
          transactions = response.data!;
          isLoading = false;
        });
      } else {
        setState(() {
          error = response.message;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Transactions'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, size: 64, color: Colors.red[400]),
                      const SizedBox(height: 16),
                      Text(error!, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                            error = null;
                          });
                          _loadTransactions();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : transactions.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.receipt_long, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('No transactions found'),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = transactions[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: transaction.isSuccessful
                                  ? Colors.green[100]
                                  : transaction.isPending
                                      ? Colors.orange[100]
                                      : Colors.red[100],
                              child: Icon(
                                transaction.isSuccessful
                                    ? Icons.check
                                    : transaction.isPending
                                        ? Icons.pending
                                        : Icons.close,
                                color: transaction.isSuccessful
                                    ? Colors.green[600]
                                    : transaction.isPending
                                        ? Colors.orange[600]
                                        : Colors.red[600],
                              ),
                            ),
                            title: Text(
                              '${(transaction.amount / 100).toStringAsFixed(2)} ${transaction.currency}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(transaction.reference),
                                Text(
                                  transaction.transactionDate.toString().split('.')[0],
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                            trailing: Chip(
                              label: Text(
                                transaction.status.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              backgroundColor: transaction.isSuccessful
                                  ? Colors.green[100]
                                  : transaction.isPending
                                      ? Colors.orange[100]
                                      : Colors.red[100],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}