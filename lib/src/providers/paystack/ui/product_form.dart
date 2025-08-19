import 'package:flutter/material.dart';
import '../../../models/product.dart';

class ProductForm extends StatefulWidget {
  final Function(ProductRequest) onSubmit;
  final ProductRequest? initialData;

  const ProductForm({
    super.key,
    required this.onSubmit,
    this.initialData,
  });

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  bool _unlimited = false;
  String _currency = 'NGN';

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _nameController.text = widget.initialData!.name;
      _descriptionController.text = widget.initialData!.description;
      _priceController.text = (widget.initialData!.price / 100).toString();
      _currency = widget.initialData!.currency;
      _unlimited = widget.initialData!.unlimited ?? false;
      if (widget.initialData!.quantity != null) {
        _quantityController.text = widget.initialData!.quantity.toString();
      }
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
            _buildNameField(),
            const SizedBox(height: 16),
            _buildDescriptionField(),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildPriceField()),
                const SizedBox(width: 16),
                Expanded(child: _buildCurrencyDropdown()),
              ],
            ),
            const SizedBox(height: 16),
            _buildUnlimitedSwitch(),
            if (!_unlimited) ...[
              const SizedBox(height: 16),
              _buildQuantityField(),
            ],
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
          'Product Information',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Product Name *',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.shopping_bag),
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Product name is required';
        return null;
      },
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      maxLines: 3,
      decoration: const InputDecoration(
        labelText: 'Description *',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.description),
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Description is required';
        return null;
      },
    );
  }

  Widget _buildPriceField() {
    return TextFormField(
      controller: _priceController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Price *',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.attach_money),
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Price is required';
        final price = double.tryParse(value!);
        if (price == null || price <= 0) return 'Enter valid price';
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

  Widget _buildUnlimitedSwitch() {
    return SwitchListTile(
      title: const Text('Unlimited Stock'),
      subtitle: const Text('Product has unlimited quantity'),
      value: _unlimited,
      onChanged: (value) {
        setState(() => _unlimited = value);
      },
    );
  }

  Widget _buildQuantityField() {
    return TextFormField(
      controller: _quantityController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Quantity *',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.inventory),
      ),
      validator: (value) {
        if (!_unlimited && (value?.isEmpty ?? true)) {
          return 'Quantity is required';
        }
        if (!_unlimited) {
          final quantity = int.tryParse(value!);
          if (quantity == null || quantity < 0) return 'Enter valid quantity';
        }
        return null;
      },
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
        child: const Text('Save Product'),
      ),
    );
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final price = double.parse(_priceController.text);
    final request = ProductRequest(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      price: (price * 100).toInt(), // Convert to subunit
      currency: _currency,
      unlimited: _unlimited,
      quantity: _unlimited ? null : int.tryParse(_quantityController.text),
    );

    widget.onSubmit(request);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }
}