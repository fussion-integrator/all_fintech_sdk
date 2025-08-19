import 'package:flutter/material.dart';
import '../../models/open_banking_models.dart';

class OpenBankingAccountSheet extends StatefulWidget {
  final List<OpenBankingAccount> accounts;
  final Function(OpenBankingAccount) onAccountSelected;
  final Function()? onCancel;

  const OpenBankingAccountSheet({
    Key? key,
    required this.accounts,
    required this.onAccountSelected,
    this.onCancel,
  }) : super(key: key);

  @override
  State<OpenBankingAccountSheet> createState() => _OpenBankingAccountSheetState();
}

class _OpenBankingAccountSheetState extends State<OpenBankingAccountSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Select Account',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: widget.onCancel,
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: widget.accounts.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final account = widget.accounts[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    child: Text(
                      account.accountType.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                        color: Colors.blue[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    account.accountName,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(account.accountNumber),
                      Text(
                        '${account.currency} ${account.availableBalance.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.green[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => widget.onAccountSelected(account),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}