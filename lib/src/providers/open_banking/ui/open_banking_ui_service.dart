import 'package:flutter/material.dart';
import '../models/open_banking_models.dart';
import '../data/open_banking_data_service.dart';
import 'widgets/open_banking_account_sheet.dart';
import 'widgets/open_banking_savings_sheet.dart';

class OpenBankingUIService {
  final OpenBankingDataService _dataService;

  OpenBankingUIService(this._dataService);

  Future<void> showAccountSelector({
    required BuildContext context,
    String? consentToken,
    required Function(OpenBankingAccount) onAccountSelected,
    required Function(String) onError,
    Function()? onCancel,
  }) async {
    try {
      final accounts = await _dataService.getAccounts(consentToken: consentToken);
      
      if (!context.mounted) return;
      
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => OpenBankingAccountSheet(
          accounts: accounts,
          onAccountSelected: (account) {
            Navigator.of(context).pop();
            onAccountSelected(account);
          },
          onCancel: () {
            Navigator.of(context).pop();
            onCancel?.call();
          },
        ),
      );
    } catch (e) {
      onError(e.toString());
    }
  }

  Future<void> showSavingsSelector({
    required BuildContext context,
    String? consentToken,
    required Function(OpenBankingSavings) onSavingsSelected,
    required Function(String) onError,
    Function()? onCancel,
  }) async {
    try {
      final savings = await _dataService.getSavings(consentToken: consentToken);
      
      if (!context.mounted) return;
      
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => OpenBankingSavingsSheet(
          savings: savings,
          onSavingsSelected: (savingsItem) {
            Navigator.of(context).pop();
            onSavingsSelected(savingsItem);
          },
          onCancel: () {
            Navigator.of(context).pop();
            onCancel?.call();
          },
        ),
      );
    } catch (e) {
      onError(e.toString());
    }
  }

  Future<void> showTransactionHistory({
    required BuildContext context,
    required String accountNumber,
    String? consentToken,
    String? from,
    String? to,
    required Function(String) onError,
  }) async {
    try {
      final transactions = await _dataService.getAccountTransactions(
        accountNumber,
        from: from,
        to: to,
        consentToken: consentToken,
      );

      if (!context.mounted) return;

      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Transaction History',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              Expanded(
                child: ListView.separated(
                  itemCount: transactions.data.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final transaction = transactions.data[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: transaction.amount > 0 
                            ? Colors.green[100] 
                            : Colors.red[100],
                        child: Icon(
                          transaction.amount > 0 
                              ? Icons.arrow_downward 
                              : Icons.arrow_upward,
                          color: transaction.amount > 0 
                              ? Colors.green[700] 
                              : Colors.red[700],
                        ),
                      ),
                      title: Text(
                        transaction.description,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        transaction.transactionDate.toString().split(' ')[0],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${transaction.amount > 0 ? '+' : ''}${transaction.amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: transaction.amount > 0 
                                  ? Colors.green[700] 
                                  : Colors.red[700],
                            ),
                          ),
                          Text(
                            'Bal: ${transaction.balance.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      onError(e.toString());
    }
  }

  Future<void> showAccountBalance({
    required BuildContext context,
    required String accountNumber,
    String? consentToken,
    required Function(String) onError,
  }) async {
    try {
      final account = await _dataService.getAccountBalance(
        accountNumber,
        consentToken: consentToken,
      );

      if (!context.mounted) return;

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.account_balance_wallet, color: Colors.blue),
              SizedBox(width: 8),
              Text('Account Balance'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      account.accountName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(account.accountNumber),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Available Balance:'),
                        Text(
                          '${account.currency} ${account.availableBalance.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Ledger Balance:'),
                        Text(
                          '${account.currency} ${account.ledgerBalance.toStringAsFixed(2)}',
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
    } catch (e) {
      onError(e.toString());
    }
  }
}