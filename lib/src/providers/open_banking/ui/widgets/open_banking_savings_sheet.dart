import 'package:flutter/material.dart';
import '../../models/open_banking_models.dart';

class OpenBankingSavingsSheet extends StatefulWidget {
  final List<OpenBankingSavings> savings;
  final Function(OpenBankingSavings) onSavingsSelected;
  final Function()? onCancel;

  const OpenBankingSavingsSheet({
    super.key,
    required this.savings,
    required this.onSavingsSelected,
    this.onCancel,
  });

  @override
  State<OpenBankingSavingsSheet> createState() => _OpenBankingSavingsSheetState();
}

class _OpenBankingSavingsSheetState extends State<OpenBankingSavingsSheet> {
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
                'Savings Plans',
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
              itemCount: widget.savings.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final savings = widget.savings[index];
                return Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Savings Plan ${index + 1}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Chip(
                              label: Text(
                                savings.frequency,
                                style: const TextStyle(fontSize: 12),
                              ),
                              backgroundColor: Colors.blue[100],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Total Saved',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    '${savings.currency} ${savings.totalSavingsAmount.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Next Due',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    '${savings.currency} ${savings.nextSavingsDueAmount.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        
                        ElevatedButton(
                          onPressed: () => widget.onSavingsSelected(savings),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 40),
                          ),
                          child: const Text('View Details'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}