import 'package:flutter/material.dart';
import '../../../../models/flutterwave_models.dart';
import '../../data/flutterwave_data_service.dart';

class FlutterwaveDirectTransferForm extends StatefulWidget {
  final FlutterwaveDataService dataService;

  const FlutterwaveDirectTransferForm({
    super.key,
    required this.dataService,
  });

  @override
  State<FlutterwaveDirectTransferForm> createState() => _FlutterwaveDirectTransferFormState();
}

class _FlutterwaveDirectTransferFormState extends State<FlutterwaveDirectTransferForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _referenceController = TextEditingController();
  final _narrationController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _bankCodeController = TextEditingController();
  
  String _selectedAction = 'instant';
  String _selectedTransferType = 'bank';
  String _selectedSourceCurrency = 'NGN';
  String _selectedDestinationCurrency = 'NGN';
  bool _isLoading = false;

  final List<String> _actions = ['instant', 'scheduled', 'deferred'];
  final List<String> _transferTypes = ['bank', 'mobile_money', 'wallet'];
  final List<String> _currencies = ['NGN', 'USD', 'GHS', 'KES', 'UGX', 'TZS'];

  @override
  void initState() {
    super.initState();
    _referenceController.text = 'TXF_${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  void dispose() {
    _amountController.dispose();
    _referenceController.dispose();
    _narrationController.dispose();
    _accountNumberController.dispose();
    _bankCodeController.dispose();
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
                          child: const Icon(Icons.send_outlined, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Direct Transfer',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildDropdown(
                      label: 'Transfer Type',
                      value: _selectedTransferType,
                      items: _transferTypes,
                      onChanged: (value) => setState(() => _selectedTransferType = value!),
                    ),
                    const SizedBox(height: 16),
                    _buildDropdown(
                      label: 'Action',
                      value: _selectedAction,
                      items: _actions,
                      onChanged: (value) => setState(() => _selectedAction = value!),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
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
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdown(
                            label: 'Source Currency',
                            value: _selectedSourceCurrency,
                            items: _currencies,
                            onChanged: (value) => setState(() => _selectedSourceCurrency = value!),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildDropdown(
                            label: 'Destination Currency',
                            value: _selectedDestinationCurrency,
                            items: _currencies,
                            onChanged: (value) => setState(() => _selectedDestinationCurrency = value!),
                          ),
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
                      controller: _narrationController,
                      label: 'Narration',
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Narration is required';
                        if (value!.length > 180) return 'Narration cannot exceed 180 characters';
                        return null;
                      },
                    ),
                    if (_selectedTransferType == 'bank') ...[
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _accountNumberController,
                        label: 'Account Number',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value?.isEmpty ?? true) return 'Account number is required';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _bankCodeController,
                        label: 'Bank Code',
                        validator: (value) {
                          if (value?.isEmpty ?? true) return 'Bank code is required';
                          return null;
                        },
                      ),
                    ],
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _createDirectTransfer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                'Create Transfer',
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

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          ),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item.replaceAll('_', ' ').toUpperCase()),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Future<void> _createDirectTransfer() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final paymentInstruction = {
        'source_currency': _selectedSourceCurrency,
        'destination_currency': _selectedDestinationCurrency,
        'amount': {
          'value': double.parse(_amountController.text),
          'applies_to': 'destination_currency',
        },
      };

      Map<String, dynamic>? transferData;
      if (_selectedTransferType == 'bank') {
        transferData = {
          'account_number': _accountNumberController.text,
          'account_bank': _bankCodeController.text,
        };
      }

      final request = FlutterwaveDirectTransferRequest(
        action: _selectedAction,
        reference: _referenceController.text,
        narration: _narrationController.text,
        paymentInstruction: paymentInstruction,
        bank: _selectedTransferType == 'bank' ? transferData : null,
        mobileMoney: _selectedTransferType == 'mobile_money' ? {} : null,
        wallet: _selectedTransferType == 'wallet' ? {} : null,
      );

      final response = await widget.dataService.createDirectTransfer(request);
      
      if (response.success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Direct transfer created successfully')),
        );
        Navigator.of(context).pop(response.data);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create transfer: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}