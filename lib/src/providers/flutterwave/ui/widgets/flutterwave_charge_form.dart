import 'package:flutter/material.dart';
import '../../../../models/flutterwave_models.dart';
import '../../data/flutterwave_data_service.dart';

class FlutterwaveChargeForm extends StatefulWidget {
  final FlutterwaveDataService dataService;
  final String? customerId;

  const FlutterwaveChargeForm({
    Key? key,
    required this.dataService,
    this.customerId,
  }) : super(key: key);

  @override
  State<FlutterwaveChargeForm> createState() => _FlutterwaveChargeFormState();
}

class _FlutterwaveChargeFormState extends State<FlutterwaveChargeForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _referenceController = TextEditingController();
  final _customerIdController = TextEditingController();
  final _paymentMethodIdController = TextEditingController();
  final _redirectUrlController = TextEditingController();
  
  String _selectedCurrency = 'NGN';
  bool _recurring = false;
  bool _isLoading = false;

  final List<String> _currencies = ['NGN', 'USD', 'GHS', 'KES', 'UGX', 'TZS'];

  @override
  void initState() {
    super.initState();
    if (widget.customerId != null) {
      _customerIdController.text = widget.customerId!;
    }
    _referenceController.text = 'CHG_${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  void dispose() {
    _amountController.dispose();
    _referenceController.dispose();
    _customerIdController.dispose();
    _paymentMethodIdController.dispose();
    _redirectUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.credit_card, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Create Charge',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildTextField(
                            controller: _amountController,
                            label: 'Amount',
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value?.isEmpty ?? true) return 'Amount is required';
                              final amount = double.tryParse(value!);
                              if (amount == null || amount <= 0) return 'Invalid amount';
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildCurrencyDropdown(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _referenceController,
                      label: 'Reference',
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Reference is required';
                        if (value!.length < 6) return 'Reference must be at least 6 characters';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _customerIdController,
                      label: 'Customer ID',
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Customer ID is required';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _paymentMethodIdController,
                      label: 'Payment Method ID',
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Payment Method ID is required';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _redirectUrlController,
                      label: 'Redirect URL (Optional)',
                      keyboardType: TextInputType.url,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(\n                          value: _recurring,\n                          onChanged: (value) => setState(() => _recurring = value ?? false),\n                        ),\n                        const Text('Recurring charge'),\n                      ],\n                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _createCharge,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                'Create Charge',
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildCurrencyDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Currency',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedCurrency,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          ),
          items: _currencies.map((currency) {
            return DropdownMenuItem(
              value: currency,
              child: Text(currency),
            );
          }).toList(),
          onChanged: (value) => setState(() => _selectedCurrency = value!),
        ),
      ],
    );
  }

  Future<void> _createCharge() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final request = FlutterwaveChargeRequest(
        amount: double.parse(_amountController.text),
        currency: _selectedCurrency,
        reference: _referenceController.text,
        customerId: _customerIdController.text,
        paymentMethodId: _paymentMethodIdController.text,
        redirectUrl: _redirectUrlController.text.isEmpty ? null : _redirectUrlController.text,
        recurring: _recurring,
      );

      final response = await widget.dataService.createCharge(request);
      
      if (response.success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Charge created successfully')),
        );
        Navigator.of(context).pop(response.data);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create charge: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}