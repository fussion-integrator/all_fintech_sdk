import 'data/opay_client.dart';
import 'data/opay_data_service.dart';
import 'ui/opay_ui_service.dart';

class OpayProvider {
  final OpayDataService data;
  final OpayUIService ui;

  OpayProvider._({
    required this.data,
    required this.ui,
  });

  factory OpayProvider({
    required String websiteId,
    required String password,
    String? baseUrl,
    bool isTestMode = false,
  }) {
    final client = OpayClient(
      websiteId: websiteId,
      password: password,
      baseUrl: baseUrl ?? 'https://gateway.opay.lt',
      isTestMode: isTestMode,
    );
    
    final dataService = OpayDataService(client);
    final uiService = OpayUIService();

    return OpayProvider._(
      data: dataService,
      ui: uiService,
    );
  }
}