import 'package:flutter/material.dart';
import '../../models/opay_models.dart';
import '../../../../core/exceptions.dart';

class OpayPaymentSheet extends StatefulWidget {
  final int amount;
  final String currency;
  final String orderNr;
  final String redirectUrl;
  final String webServiceUrl;
  final String standard;
  final String? customerEmail;
  final String? customerMobile;
  final String? paymentDescription;
  final Function(OpayTransaction) onSuccess;
  final Function(String) onError;
  final Function()? onCancel;

  const OpayPaymentSheet({
    Key? key,
    required this.amount,
    this.currency = 'EUR',
    required this.orderNr,
    required this.redirectUrl,
    required this.webServiceUrl,
    required this.standard,
    this.customerEmail,
    this.customerMobile,
    this.paymentDescription,
    required this.onSuccess,
    required this.onError,
    this.onCancel,
  }) : super(key: key);

  @override
  State<OpayPaymentSheet> createState() => _OpayPaymentSheetState();
}

class _OpayPaymentSheetState extends State<OpayPaymentSheet> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  
  OpayPaymentChannel? _selectedChannel;
  String? _selectedBank;
  bool _isLoading = false;
  Map<String, OpayChannelGroup> _availableChannels = {};

  final Map<OpayPaymentChannel, String> _channelTitles = {
    OpayPaymentChannel.banklink: 'Internet Banking',
    OpayPaymentChannel.pis: 'Payment Initiation Service',
    OpayPaymentChannel.card: 'Payment Card',
    OpayPaymentChannel.banktransfer: 'Bank Transfer',
    OpayPaymentChannel.cash: 'Cash Payment',
    OpayPaymentChannel.financing: 'Financing',
  };

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.customerEmail ?? '';
    _mobileController.text = widget.customerMobile ?? '';
    _loadChannels();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  Future<void> _loadChannels() async {
    setState(() => _isLoading = true);
    
    try {
      // This would be called from the service
      // For now, we'll show the form directly
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      widget.onError(e.toString());
    }
  }

  Future<void> _processPayment() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedChannel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a payment method')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final request = OpayCreateTransactionRequest(
        orderNr: widget.orderNr,
        websiteId: '', // This would come from the service
        redirectUrl: widget.redirectUrl,
        webServiceUrl: widget.webServiceUrl,
        standard: widget.standard,
        amount: widget.amount,
        currency: widget.currency,
        cEmail: _emailController.text.isNotEmpty ? _emailController.text : null,
        cMobileNr: _mobileController.text.isNotEmpty ? _mobileController.text : null,
        paymentDescription: widget.paymentDescription,
        passThroughChannelName: _selectedChannel!.value,
      );

      // This would be processed by the service
      final transaction = OpayTransaction(
        orderNr: request.orderNr,
        websiteId: request.websiteId,
        amount: request.amount,
        currency: request.currency,
        status: '2', // Created
        transactionId: 'DEMO_${DateTime.now().millisecondsSinceEpoch}',
        redirectUrl: 'https://pay.opay.eu/demo',
      );

      widget.onSuccess(transaction);
    } catch (e) {
      widget.onError(e.toString());
    } finally {
      setState(() => _isLoading = false);
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Opay Payment',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: widget.onCancel,
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Payment Details', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Amount:'),
                    Text(
                      '${(widget.amount / 100).toStringAsFixed(2)} ${widget.currency}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Order:'),
                    Text(widget.orderNr),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value?.isNotEmpty == true && !value!.contains('@')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    controller: _mobileController,
                    decoration: const InputDecoration(
                      labelText: 'Mobile Number',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Select Payment Method',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),

                  ...OpayPaymentChannel.values.map((channel) => 
                    RadioListTile<OpayPaymentChannel>(
                      title: Text(_channelTitles[channel] ?? channel.value),
                      value: channel,
                      groupValue: _selectedChannel,
                      onChanged: (value) => setState(() => _selectedChannel = value),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),

                  const SizedBox(height: 32),

                  ElevatedButton(
                    onPressed: _isLoading ? null : _processPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
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
                        : const Text('Continue to Payment', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}