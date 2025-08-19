import '../../core/fintech_config.dart';
import 'monnify_client.dart';
import 'data/monnify_data_service.dart';
import 'ui/monnify_ui_service.dart';

class MonnifyProvider {
  final FintechConfig _config;
  late final MonnifyClient _client;
  late final MonnifyDataService _dataService;
  late final MonnifyUIService _uiService;

  MonnifyProvider(this._config) {
    _client = MonnifyClient(_config);
    _dataService = MonnifyDataService(_client);
    _uiService = MonnifyUIService(_dataService);
  }

  /// Access to data-only operations
  MonnifyDataService get data => _dataService;

  /// Access to UI operations
  MonnifyUIService get ui => _uiService;

  /// Get current configuration
  FintechConfig get config => _config;
}