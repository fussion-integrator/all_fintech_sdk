import 'package:flutter/material.dart';
import '../../../models/flutterwave_models.dart';
import '../data/flutterwave_data_service.dart';
import 'widgets/flutterwave_payment_sheet.dart';
import 'widgets/flutterwave_transfer_form.dart';
import 'widgets/flutterwave_customer_form.dart';
import 'widgets/flutterwave_charge_form.dart';
import 'widgets/flutterwave_orchestration_form.dart';
import 'widgets/flutterwave_direct_transfer_form.dart';
import 'widgets/flutterwave_recipient_form.dart';
import 'widgets/flutterwave_sender_form.dart';
import 'widgets/flutterwave_order_form.dart';
import 'widgets/flutterwave_virtual_account_form.dart';

class FlutterwaveUIService {
  final FlutterwaveDataService _dataService;

  FlutterwaveUIService(this._dataService);

  /// Show payment sheet
  Future<FlutterwaveTransaction?> showPaymentSheet(
    BuildContext context, {
    required String txRef,
    required int amount,
    required String currency,
    required String redirectUrl,
    required FlutterwaveCustomer customer,
    Map<String, dynamic>? customizations,
  }) async {
    return await showModalBottomSheet<FlutterwaveTransaction>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FlutterwavePaymentSheet(
        txRef: txRef,
        amount: amount,
        currency: currency,
        redirectUrl: redirectUrl,
        customer: customer,
        customizations: customizations,
        dataService: _dataService,
      ),
    );
  }

  /// Show transfer form
  Future<FlutterwaveTransfer?> showTransferForm(
    BuildContext context, {
    String currency = 'NGN',
  }) async {
    return await showModalBottomSheet<FlutterwaveTransfer>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FlutterwaveTransferForm(
        currency: currency,
        dataService: _dataService,
      ),
    );
  }

  /// Show customer form
  Future<FlutterwaveCustomer?> showCustomerForm(
    BuildContext context, {
    FlutterwaveCustomer? customer,
  }) async {
    return await showModalBottomSheet<FlutterwaveCustomer>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FlutterwaveCustomerForm(
        dataService: _dataService,
        customer: customer,
      ),
    );
  }

  /// Show charge form
  Future<FlutterwaveCharge?> showChargeForm(
    BuildContext context, {
    String? customerId,
  }) async {
    return await showModalBottomSheet<FlutterwaveCharge>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FlutterwaveChargeForm(
        dataService: _dataService,
        customerId: customerId,
      ),
    );
  }

  /// Show orchestration charge form
  Future<dynamic> showOrchestrationChargeForm(BuildContext context) async {
    return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FlutterwaveOrchestrationForm(
        dataService: _dataService,
        isOrder: false,
      ),
    );
  }

  /// Show orchestration order form
  Future<dynamic> showOrchestrationOrderForm(BuildContext context) async {
    return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FlutterwaveOrchestrationForm(
        dataService: _dataService,
        isOrder: true,
      ),
    );
  }

  /// Show direct transfer form
  Future<FlutterwaveTransfer?> showDirectTransferForm(BuildContext context) async {
    return await showModalBottomSheet<FlutterwaveTransfer>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FlutterwaveDirectTransferForm(
        dataService: _dataService,
      ),
    );
  }

  /// Show transfer recipient form
  Future<FlutterwaveTransferRecipient?> showRecipientForm(BuildContext context) async {
    return await showModalBottomSheet<FlutterwaveTransferRecipient>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FlutterwaveRecipientForm(
        dataService: _dataService,
      ),
    );
  }

  /// Show transfer sender form
  Future<FlutterwaveTransferSender?> showSenderForm(BuildContext context) async {
    return await showModalBottomSheet<FlutterwaveTransferSender>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FlutterwaveSenderForm(
        dataService: _dataService,
      ),
    );
  }

  /// Show order form
  Future<FlutterwaveOrder?> showOrderForm(BuildContext context) async {
    return await showModalBottomSheet<FlutterwaveOrder>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FlutterwaveOrderForm(
        dataService: _dataService,
      ),
    );
  }

  /// Show virtual account form
  Future<FlutterwaveVirtualAccount?> showVirtualAccountForm(BuildContext context) async {
    return await showModalBottomSheet<FlutterwaveVirtualAccount>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(16),
        child: FlutterwaveVirtualAccountForm(
          onSubmit: (request) async {
            try {
              final result = await _dataService.createVirtualAccount(request);
              Navigator.of(context).pop(result.data);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: $e')),
              );
            }
          },
          onCancel: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}