import 'package:flutter/material.dart';
import '../../../../models/flutterwave_models.dart';
import '../../data/flutterwave_data_service.dart';

class FlutterwaveOrchestrationForm extends StatefulWidget {
  final FlutterwaveDataService dataService;
  final bool isOrder;

  const FlutterwaveOrchestrationForm({
    super.key,
    required this.dataService,
    this.isOrder = false,
  });

  @override
  State<FlutterwaveOrchestrationForm> createState() => _FlutterwaveOrchestrationFormState();
}

class _FlutterwaveOrchestrationFormState extends State<FlutterwaveOrchestrationForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _referenceController = TextEditingController();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _redirectUrlController = TextEditingController();
  
  String _selectedCurrency = 'NGN';
  String _selectedPaymentMethod = 'card';
  bool _isLoading = false;

  final List<String> _currencies = ['NGN', 'USD', 'GHS', 'KES', 'UGX', 'TZS'];
  final List<String> _paymentMethods = ['card', 'bank_account', 'mobile_money', 'ussd', 'bank_transfer'];

  @override
  void initState() {
    super.initState();
    _referenceController.text = 'ORD_${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  void dispose() {
    _amountController.dispose();
    _referenceController.dispose();
    _emailController.dispose();
    _nameController.dispose();
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
                          child: const Icon(Icons.auto_awesome, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          widget.isOrder ? 'Create Order' : 'Create Charge',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                      controller: _emailController,
                      label: 'Customer Email',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Email is required';
                        if (!value!.contains('@')) return 'Invalid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _nameController,
                      label: 'Customer Name',
                    ),
                    const SizedBox(height: 16),
                    _buildPaymentMethodDropdown(),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _redirectUrlController,
                      label: 'Redirect URL (Optional)',
                      keyboardType: TextInputType.url,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _createTransaction,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                                widget.isOrder ? 'Create Order' : 'Create Charge',
                                style: const TextStyle(fontSize: 16, color: Colors.white),
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

  Widget _buildPaymentMethodDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Method',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedPaymentMethod,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          ),
          items: _paymentMethods.map((method) {
            return DropdownMenuItem(
              value: method,
              child: Text(method.replaceAll('_', ' ').toUpperCase()),
            );
          }).toList(),
          onChanged: (value) => setState(() => _selectedPaymentMethod = value!),
        ),
      ],
    );
  }

  Future<void> _createTransaction() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final customer = FlutterwaveCustomer(
        email: _emailController.text,
        name: _nameController.text.isNotEmpty 
            ? FlutterwaveName(first: _nameController.text) 
            : null,
      );

      final paymentMethod = {_selectedPaymentMethod: {}};

      final request = FlutterwaveOrchestrationRequest(
        amount: double.parse(_amountController.text),
        currency: _selectedCurrency,
        reference: _referenceController.text,
        customer: customer,
        paymentMethod: paymentMethod,
        redirectUrl: _redirectUrlController.text.isEmpty ? null : _redirectUrlController.text,
      );

      final response = widget.isOrder
          ? await widget.dataService.createOrchestratorOrder(request)
          : await widget.dataService.createOrchestratorCharge(request);
      
      if (response.status && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${widget.isOrder ? 'Order' : 'Charge'} created successfully')),
        );
        Navigator.of(context).pop(response.data);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create ${widget.isOrder ? 'order' : 'charge'}: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}