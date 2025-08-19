import '../../core/fintech_config.dart';
import 'paystack_client.dart';
import 'data/paystack_data_service.dart';
import 'ui/paystack_ui_service.dart';

/// Paystack provider with complete API integration.
/// 
/// Supports payments, transfers, customers, subscriptions, and products
/// with both data operations and UI components.
class PaystackProvider {
  late final PaystackClient _client;
  late final PaystackDataService _dataService;
  late final PaystackUIService _uiService;

  PaystackProvider(FintechConfig config) {
    _client = PaystackClient(config);
    _dataService = PaystackDataService(_client);
    _uiService = PaystackUIService(_dataService);
  }

  /// Access to data-only operations
  PaystackDataService get data => _dataService;

  /// Access to UI operations
  PaystackUIService get ui => _uiService;
}