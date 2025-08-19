import 'package:flutter/material.dart';
import '../../../models/transfer.dart';
import '../../../models/transfer_recipient.dart';

class TransferForm extends StatefulWidget {
  final Function(TransferRequest) onSubmit;
  final List<TransferRecipient> recipients;

  const TransferForm({
    Key? key,
    required this.onSubmit,
    required this.recipients,
  }) : super(key: key);

  @override
  State<TransferForm> createState() => _TransferFormState();
}

class _TransferFormState extends State<TransferForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _reasonController = TextEditingController();
  TransferRecipient? _selectedRecipient;
  String _currency = 'NGN';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildRecipientDropdown(),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildAmountField()),
                const SizedBox(width: 16),
                Expanded(child: _buildCurrencyDropdown()),
              ],
            ),
            const SizedBox(height: 16),
            _buildReasonField(),
            const SizedBox(height: 24),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Send Money',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildRecipientDropdown() {
    return DropdownButtonFormField<TransferRecipient>(
      value: _selectedRecipient,
      decoration: const InputDecoration(
        labelText: 'Recipient *',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.person),
      ),
      items: widget.recipients.map((recipient) {
        return DropdownMenuItem<TransferRecipient>(
          value: recipient,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(recipient.name),
              Text(
                '${recipient.accountNumber} - ${recipient.bankName}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: (recipient) {
        setState(() => _selectedRecipient = recipient);
      },
      validator: (value) {
        if (value == null) return 'Please select a recipient';
        return null;
      },
    );
  }

  Widget _buildAmountField() {
    return TextFormField(
      controller: _amountController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Amount *',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.attach_money),
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Amount is required';
        final amount = double.tryParse(value!);
        if (amount == null || amount <= 0) return 'Enter valid amount';
        return null;
      },
    );
  }

  Widget _buildCurrencyDropdown() {
    return DropdownButtonFormField<String>(
      value: _currency,
      decoration: const InputDecoration(
        labelText: 'Currency',
        border: OutlineInputBorder(),
      ),
      items: ['NGN', 'USD', 'GHS', 'ZAR', 'KES'].map((currency) {
        return DropdownMenuItem<String>(
          value: currency,
          child: Text(currency),
        );
      }).toList(),
      onChanged: (value) {
        setState(() => _currency = value!);
      },
    );
  }

  Widget _buildReasonField() {
    return TextFormField(
      controller: _reasonController,
      decoration: const InputDecoration(
        labelText: 'Reason (Optional)',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.description),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: _handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green[600],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text('Send Money'),
      ),
    );
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.parse(_amountController.text);
    final request = TransferRequest(
      amount: (amount * 100).toInt(), // Convert to subunit
      recipient: _selectedRecipient!.recipientCode,
      currency: _currency,
      reason: _reasonController.text.trim().isEmpty 
          ? null 
          : _reasonController.text.trim(),
    );

    widget.onSubmit(request);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _reasonController.dispose();
    super.dispose();
  }
}