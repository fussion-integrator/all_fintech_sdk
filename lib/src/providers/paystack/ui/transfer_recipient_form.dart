import 'package:flutter/material.dart';
import '../../../models/transfer_recipient.dart';

class TransferRecipientForm extends StatefulWidget {
  final Function(TransferRecipientRequest) onSubmit;

  const TransferRecipientForm({
    super.key,
    required this.onSubmit,
  });

  @override
  State<TransferRecipientForm> createState() => _TransferRecipientFormState();
}

class _TransferRecipientFormState extends State<TransferRecipientForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _bankCodeController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _type = 'nuban';
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
            _buildTypeDropdown(),
            const SizedBox(height: 16),
            _buildNameField(),
            const SizedBox(height: 16),
            _buildAccountNumberField(),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildBankCodeField()),
                const SizedBox(width: 16),
                Expanded(child: _buildCurrencyDropdown()),
              ],
            ),
            const SizedBox(height: 16),
            _buildDescriptionField(),
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
          'Add Transfer Recipient',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: _type,
      decoration: const InputDecoration(
        labelText: 'Recipient Type *',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.account_balance),
      ),
      items: const [
        DropdownMenuItem(value: 'nuban', child: Text('NUBAN')),
        DropdownMenuItem(value: 'ghipss', child: Text('GHIPSS')),
        DropdownMenuItem(value: 'mobile_money', child: Text('Mobile Money')),
        DropdownMenuItem(value: 'basa', child: Text('BASA')),
      ],
      onChanged: (value) {
        setState(() => _type = value!);
      },
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Recipient Name *',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.person),
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Name is required';
        return null;
      },
    );
  }

  Widget _buildAccountNumberField() {
    return TextFormField(
      controller: _accountNumberController,
      decoration: const InputDecoration(
        labelText: 'Account Number *',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.account_balance_wallet),
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Account number is required';
        return null;
      },
    );
  }

  Widget _buildBankCodeField() {
    return TextFormField(
      controller: _bankCodeController,
      decoration: const InputDecoration(
        labelText: 'Bank Code *',
        hintText: 'e.g. 058',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Bank code is required';
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

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: const InputDecoration(
        labelText: 'Description (Optional)',
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
        child: const Text('Add Recipient'),
      ),
    );
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final request = TransferRecipientRequest(
      type: _type,
      name: _nameController.text.trim(),
      accountNumber: _accountNumberController.text.trim(),
      bankCode: _bankCodeController.text.trim(),
      currency: _currency,
      description: _descriptionController.text.trim().isEmpty 
          ? null 
          : _descriptionController.text.trim(),
    );

    widget.onSubmit(request);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _accountNumberController.dispose();
    _bankCodeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}