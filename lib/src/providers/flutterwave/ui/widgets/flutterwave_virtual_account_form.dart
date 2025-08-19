import 'package:flutter/material.dart';
import '../../../../models/flutterwave_models.dart';

class FlutterwaveVirtualAccountForm extends StatefulWidget {
  final Function(FlutterwaveVirtualAccountRequest) onSubmit;
  final VoidCallback? onCancel;

  const FlutterwaveVirtualAccountForm({
    Key? key,
    required this.onSubmit,
    this.onCancel,
  }) : super(key: key);

  @override
  State<FlutterwaveVirtualAccountForm> createState() => _FlutterwaveVirtualAccountFormState();
}

class _FlutterwaveVirtualAccountFormState extends State<FlutterwaveVirtualAccountForm> {
  final _formKey = GlobalKey<FormState>();
  final _referenceController = TextEditingController();
  final _customerIdController = TextEditingController();
  final _amountController = TextEditingController();
  final _expiryController = TextEditingController();
  final _narrationController = TextEditingController();
  final _bvnController = TextEditingController();
  final _ninController = TextEditingController();
  final _customerAccountController = TextEditingController();

  String _selectedCurrency = 'NGN';
  String _selectedAccountType = 'static';

  final List<String> _currencies = ['NGN', 'USD', 'EUR', 'GBP'];
  final List<String> _accountTypes = ['static', 'dynamic'];

  @override
  void initState() {
    super.initState();
    _referenceController.text = 'VA_${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Create Virtual Account',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _referenceController,
                decoration: const InputDecoration(
                  labelText: 'Reference *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Reference is required';
                  }
                  if (value.length < 6 || value.length > 42) {
                    return 'Reference must be between 6 and 42 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _customerIdController,
                decoration: const InputDecoration(
                  labelText: 'Customer ID *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Customer ID is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount *',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Amount is required';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCurrency,
                decoration: const InputDecoration(
                  labelText: 'Currency *',
                  border: OutlineInputBorder(),
                ),
                items: _currencies.map((currency) {
                  return DropdownMenuItem(
                    value: currency,
                    child: Text(currency),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCurrency = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedAccountType,
                decoration: const InputDecoration(
                  labelText: 'Account Type *',
                  border: OutlineInputBorder(),
                ),
                items: _accountTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedAccountType = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _expiryController,
                decoration: const InputDecoration(
                  labelText: 'Expiry (seconds)',
                  hintText: '60 to 31536000',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final expiry = int.tryParse(value);
                    if (expiry == null || expiry < 60 || expiry > 31536000) {
                      return 'Expiry must be between 60 and 31536000 seconds';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _narrationController,
                decoration: const InputDecoration(
                  labelText: 'Narration',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bvnController,
                decoration: const InputDecoration(
                  labelText: 'BVN',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ninController,
                decoration: const InputDecoration(
                  labelText: 'NIN',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _customerAccountController,
                decoration: const InputDecoration(
                  labelText: 'Customer Account Number',
                  hintText: 'Required for EGP and KES',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
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
                      onPressed: _submitForm,
                      child: const Text('Create Virtual Account'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final request = FlutterwaveVirtualAccountRequest(
        reference: _referenceController.text,
        customerId: _customerIdController.text,
        amount: double.parse(_amountController.text),
        currency: _selectedCurrency,
        accountType: _selectedAccountType,
        expiry: _expiryController.text.isNotEmpty ? int.parse(_expiryController.text) : null,
        narration: _narrationController.text.isNotEmpty ? _narrationController.text : null,
        bvn: _bvnController.text.isNotEmpty ? _bvnController.text : null,
        nin: _ninController.text.isNotEmpty ? _ninController.text : null,
        customerAccountNumber: _customerAccountController.text.isNotEmpty ? _customerAccountController.text : null,
      );

      widget.onSubmit(request);
    }
  }

  @override
  void dispose() {
    _referenceController.dispose();
    _customerIdController.dispose();
    _amountController.dispose();
    _expiryController.dispose();
    _narrationController.dispose();
    _bvnController.dispose();
    _ninController.dispose();
    _customerAccountController.dispose();
    super.dispose();
  }
}