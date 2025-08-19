import 'package:flutter/material.dart';
import '../../../models/customer.dart';

class CustomerForm extends StatefulWidget {
  final Function(CustomerRequest) onSubmit;
  final CustomerRequest? initialData;
  final String submitButtonText;

  const CustomerForm({
    super.key,
    required this.onSubmit,
    this.initialData,
    this.submitButtonText = 'Create Customer',
  });

  @override
  State<CustomerForm> createState() => _CustomerFormState();
}

class _CustomerFormState extends State<CustomerForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _emailController.text = widget.initialData!.email;
      _firstNameController.text = widget.initialData!.firstName ?? '';
      _lastNameController.text = widget.initialData!.lastName ?? '';
      _phoneController.text = widget.initialData!.phone ?? '';
    }
  }

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
            _buildEmailField(),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildFirstNameField()),
                const SizedBox(width: 16),
                Expanded(child: _buildLastNameField()),
              ],
            ),
            const SizedBox(height: 16),
            _buildPhoneField(),
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
          'Customer Information',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: 'Email Address *',
        hintText: 'customer@example.com',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.email),
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Email is required';
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
          return 'Enter a valid email address';
        }
        return null;
      },
    );
  }

  Widget _buildFirstNameField() {
    return TextFormField(
      controller: _firstNameController,
      decoration: const InputDecoration(
        labelText: 'First Name',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.person),
      ),
    );
  }

  Widget _buildLastNameField() {
    return TextFormField(
      controller: _lastNameController,
      decoration: const InputDecoration(
        labelText: 'Last Name',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      decoration: const InputDecoration(
        labelText: 'Phone Number',
        hintText: '+2348123456789',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.phone),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: _handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[600],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(widget.submitButtonText),
      ),
    );
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final request = CustomerRequest(
      email: _emailController.text.trim(),
      firstName: _firstNameController.text.trim().isEmpty 
          ? null 
          : _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim().isEmpty 
          ? null 
          : _lastNameController.text.trim(),
      phone: _phoneController.text.trim().isEmpty 
          ? null 
          : _phoneController.text.trim(),
    );

    widget.onSubmit(request);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}