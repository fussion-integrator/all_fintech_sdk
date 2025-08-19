import 'data/open_banking_client.dart';
import 'data/open_banking_data_service.dart';
import 'ui/open_banking_ui_service.dart';

class OpenBankingProvider {
  final OpenBankingDataService data;
  final OpenBankingUIService ui;

  OpenBankingProvider._({
    required this.data,
    required this.ui,
  });

  factory OpenBankingProvider({
    required String clientId,
    required String clientSecret,
    required String baseUrl,
  }) {
    final client = OpenBankingClient(
      clientId: clientId,
      clientSecret: clientSecret,
      baseUrl: baseUrl,
    );
    
    final dataService = OpenBankingDataService(client);
    final uiService = OpenBankingUIService(dataService);

    return OpenBankingProvider._(
      data: dataService,
      ui: uiService,
    );
  }
}