import 'package:flutter/material.dart';
import '../../../models/payment_request.dart';
import '../../../models/transaction.dart';
import '../data/paystack_data_service.dart';

class PaystackPaymentSheet extends StatefulWidget {
  final PaymentRequest paymentRequest;
  final PaystackDataService dataService;
  final Function(Transaction) onSuccess;
  final Function(String) onError;
  final Function()? onCancel;

  const PaystackPaymentSheet({
    Key? key,
    required this.paymentRequest,
    required this.dataService,
    required this.onSuccess,
    required this.onError,
    this.onCancel,
  }) : super(key: key);

  @override
  State<PaystackPaymentSheet> createState() => _PaystackPaymentSheetState();
}

class _PaystackPaymentSheetState extends State<PaystackPaymentSheet> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _pinController = TextEditingController();
  
  bool _isLoading = false;
  bool _showPinField = false;
  bool _showOtpField = false;
  String? _currentReference;
  String? _otpMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildPaymentForm(),
          const SizedBox(height: 24),
          _buildActionButtons(),
        ],
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
          'Complete Payment',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Amount: ${_formatAmount(widget.paymentRequest.amount)} ${widget.paymentRequest.currency}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.green[600],
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          if (!_showOtpField) ...[
            _buildCardNumberField(),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildExpiryField()),
                const SizedBox(width: 16),
                Expanded(child: _buildCvvField()),
              ],
            ),
            if (_showPinField) ...[
              const SizedBox(height: 16),
              _buildPinField(),
            ],
          ] else ...[
            _buildOtpField(),
          ],
        ],
      ),
    );
  }

  Widget _buildCardNumberField() {
    return TextFormField(
      controller: _cardNumberController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Card Number',
        hintText: '1234 5678 9012 3456',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.credit_card),
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Card number is required';
        if (value!.replaceAll(' ', '').length < 16) return 'Invalid card number';
        return null;
      },
    );
  }

  Widget _buildExpiryField() {
    return TextFormField(
      controller: _expiryController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'MM/YY',
        hintText: '12/25',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Expiry is required';
        if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value!)) return 'Invalid format';
        return null;
      },
    );
  }

  Widget _buildCvvField() {
    return TextFormField(
      controller: _cvvController,
      keyboardType: TextInputType.number,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: 'CVV',
        hintText: '123',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) return 'CVV is required';
        if (value!.length < 3) return 'Invalid CVV';
        return null;
      },
    );
  }

  Widget _buildPinField() {
    return TextFormField(
      controller: _pinController,
      keyboardType: TextInputType.number,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: 'Card PIN',
        hintText: '1234',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.lock),
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) return 'PIN is required';
        return null;
      },
    );
  }

  Widget _buildOtpField() {
    return Column(
      children: [
        if (_otpMessage != null) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Text(
              _otpMessage!,
              style: TextStyle(color: Colors.blue[800]),
            ),
          ),
          const SizedBox(height: 16),
        ],
        TextFormField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Enter OTP',
            hintText: '123456',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.sms),
          ),
          onChanged: (value) {
            if (value.length == 6) {
              _submitOtp(value);
            }
          },
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handlePayment,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(_showOtpField ? 'Verifying...' : 'Pay Now'),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: _isLoading ? null : () {
            widget.onCancel?.call();
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  Future<void> _handlePayment() async {
    if (_showOtpField) return;

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final expiry = _expiryController.text.split('/');
      final response = await widget.dataService.chargeCard(
        email: widget.paymentRequest.email,
        amount: widget.paymentRequest.amount,
        cardNumber: _cardNumberController.text.replaceAll(' ', ''),
        expiryMonth: expiry[0],
        expiryYear: '20${expiry[1]}',
        cvv: _cvvController.text,
        pin: _pinController.text.isNotEmpty ? _pinController.text : null,
        metadata: widget.paymentRequest.metadata,
      );

      if (response.isSuccess && response.data != null) {
        final transaction = response.data!;
        _currentReference = transaction.reference;

        if (transaction.status == 'success') {
          widget.onSuccess(transaction);
          Navigator.of(context).pop();
        } else if (transaction.status == 'send_pin') {
          setState(() => _showPinField = true);
        } else if (transaction.status == 'send_otp') {
          setState(() {
            _showOtpField = true;
            _otpMessage = response.data?.gatewayResponse;
          });
        }
      } else {
        widget.onError(response.message);
      }
    } catch (e) {
      widget.onError(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _submitOtp(String otp) async {
    if (_currentReference == null) return;

    setState(() => _isLoading = true);

    try {
      final response = await widget.dataService.submitOtp(
        reference: _currentReference!,
        otp: otp,
      );

      if (response.isSuccess && response.data != null) {
        final transaction = response.data!;
        if (transaction.status == 'success') {
          widget.onSuccess(transaction);
          Navigator.of(context).pop();
        } else {
          widget.onError('Transaction failed: ${transaction.gatewayResponse}');
        }
      } else {
        widget.onError(response.message);
      }
    } catch (e) {
      widget.onError(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _formatAmount(int amount) {
    return (amount / 100).toStringAsFixed(2);
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _pinController.dispose();
    super.dispose();
  }
}