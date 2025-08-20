import 'package:flutter/material.dart';
import '../../../../models/flutterwave_models.dart';
import '../../data/flutterwave_data_service.dart';

class FlutterwaveTransferForm extends StatefulWidget {
  final String currency;
  final FlutterwaveDataService dataService;

  const FlutterwaveTransferForm({
    super.key,
    required this.currency,
    required this.dataService,
  });

  @override
  State<FlutterwaveTransferForm> createState() => _FlutterwaveTransferFormState();
}

class _FlutterwaveTransferFormState extends State<FlutterwaveTransferForm> {
  final _formKey = GlobalKey<FormState>();
  final _accountNumberController = TextEditingController();
  final _amountController = TextEditingController();
  final _narrationController = TextEditingController();
  final _beneficiaryNameController = TextEditingController();
  
  String? _selectedBank;
  List<FlutterwaveBank> _banks = [];
  bool _isLoading = false;
  bool _isLoadingBanks = false;

  @override
  void initState() {
    super.initState();
    _loadBanks();
  }

  @override
  void dispose() {
    _accountNumberController.dispose();
    _amountController.dispose();
    _narrationController.dispose();
    _beneficiaryNameController.dispose();
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
                          child: const Icon(Icons.send, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Send Money',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildBankDropdown(),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _accountNumberController,
                      label: 'Account Number',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Account number is required';
                        if (value!.length < 10) return 'Invalid account number';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _beneficiaryNameController,
                      label: 'Beneficiary Name (Optional)',
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
                    _buildTextField(
                      controller: _narrationController,
                      label: 'Narration',
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Narration is required';
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _processTransfer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                'Send Money',
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

  Widget _buildBankDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bank',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedBank,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          ),
          hint: _isLoadingBanks
              ? const Text('Loading banks...')
              : const Text('Select Bank'),
          items: _banks.map((bank) {
            return DropdownMenuItem(
              value: bank.code,
              child: Text(bank.name),
            );
          }).toList(),
          onChanged: _isLoadingBanks ? null : (value) {
            setState(() => _selectedBank = value);
          },
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Bank is required';
            return null;
          },
        ),
      ],
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

  Future<void> _loadBanks() async {
    setState(() => _isLoadingBanks = true);
    try {
      final response = await widget.dataService.listBanks('NG');
      if (response.status) {
        setState(() => _banks = response.data!);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load banks: $e')),
        );
      }
    } finally {
      setState(() => _isLoadingBanks = false);
    }
  }

  Future<void> _processTransfer() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final request = FlutterwaveTransferRequest(
        accountBank: _selectedBank!,
        accountNumber: _accountNumberController.text,
        amount: (double.parse(_amountController.text) * 100).toInt(),
        currency: widget.currency,
        reference: 'TXN_${DateTime.now().millisecondsSinceEpoch}',
        narration: _narrationController.text,
        beneficiaryName: _beneficiaryNameController.text.isEmpty 
            ? null 
            : _beneficiaryNameController.text,
      );

      final response = await widget.dataService.createTransfer(request);
      
      if (response.status && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transfer initiated successfully')),
        );
        Navigator.of(context).pop(response.data);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Transfer failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}