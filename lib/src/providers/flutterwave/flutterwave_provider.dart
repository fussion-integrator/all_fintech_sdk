import '../../core/fintech_config.dart';
import 'flutterwave_client.dart';
import 'data/flutterwave_data_service.dart';
import 'ui/flutterwave_ui_service.dart';

class FlutterwaveProvider {
  late final FlutterwaveClient _client;
  late final FlutterwaveDataService _dataService;
  late final FlutterwaveUIService _uiService;

  FlutterwaveProvider(FintechConfig config) {
    _client = FlutterwaveClient(config);
    _dataService = FlutterwaveDataService(_client);
    _uiService = FlutterwaveUIService(_dataService);
  }

  /// Access to data-only operations
  FlutterwaveDataService get data => _dataService;

  /// Access to UI operations
  FlutterwaveUIService get ui => _uiService;

  void dispose() {
    _client.dispose();
  }
}