import 'package:flutter/material.dart';
import '../../../models/subscription.dart';
import '../../../models/customer.dart';

class SubscriptionForm extends StatefulWidget {
  final Function(SubscriptionRequest) onSubmit;
  final List<Plan> plans;
  final List<Customer> customers;

  const SubscriptionForm({
    super.key,
    required this.onSubmit,
    required this.plans,
    required this.customers,
  });

  @override
  State<SubscriptionForm> createState() => _SubscriptionFormState();
}

class _SubscriptionFormState extends State<SubscriptionForm> {
  final _formKey = GlobalKey<FormState>();
  Customer? _selectedCustomer;
  Plan? _selectedPlan;
  DateTime? _startDate;

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
            _buildCustomerDropdown(),
            const SizedBox(height: 16),
            _buildPlanDropdown(),
            const SizedBox(height: 16),
            _buildStartDatePicker(),
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
          'Create Subscription',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerDropdown() {
    return DropdownButtonFormField<Customer>(
      value: _selectedCustomer,
      decoration: const InputDecoration(
        labelText: 'Customer *',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.person),
      ),
      items: widget.customers.map((customer) {
        return DropdownMenuItem<Customer>(
          value: customer,
          child: Text(
            '${customer.firstName ?? ''} ${customer.lastName ?? ''}'.trim().isEmpty
                ? customer.email ?? 'Unknown'
                : '${customer.firstName ?? ''} ${customer.lastName ?? ''}'.trim(),
          ),
        );
      }).toList(),
      onChanged: (customer) {
        setState(() => _selectedCustomer = customer);
      },
      validator: (value) {
        if (value == null) return 'Please select a customer';
        return null;
      },
    );
  }

  Widget _buildPlanDropdown() {
    return DropdownButtonFormField<Plan>(
      value: _selectedPlan,
      decoration: const InputDecoration(
        labelText: 'Plan *',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.credit_card),
      ),
      items: widget.plans.map((plan) {
        return DropdownMenuItem<Plan>(
          value: plan,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(plan.name),
              Text(
                '${(plan.amount / 100).toStringAsFixed(2)} ${plan.currency} - ${plan.interval}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: (plan) {
        setState(() => _selectedPlan = plan);
      },
      validator: (value) {
        if (value == null) return 'Please select a plan';
        return null;
      },
    );
  }

  Widget _buildStartDatePicker() {
    return InkWell(
      onTap: _selectStartDate,
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Start Date (Optional)',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.calendar_today),
        ),
        child: Text(
          _startDate != null
              ? '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'
              : 'Select start date',
          style: TextStyle(
            color: _startDate != null ? Colors.black : Colors.grey[600],
          ),
        ),
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
        child: const Text('Create Subscription'),
      ),
    );
  }

  Future<void> _selectStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() => _startDate = date);
    }
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final request = SubscriptionRequest(
      customer: _selectedCustomer!.customerCode ?? '',
      plan: _selectedPlan!.planCode,
      startDate: _startDate,
    );

    widget.onSubmit(request);
  }
}