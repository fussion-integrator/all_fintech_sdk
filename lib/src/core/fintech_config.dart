import 'fintech_provider.dart';

/// Configuration for fintech providers.
class FintechConfig {
  final FintechProvider provider;
  final String apiKey;
  final String? publicKey;
  final bool isLive;
  final String? baseUrl;

  const FintechConfig({
    required this.provider,
    required this.apiKey,
    this.publicKey,
    this.isLive = false,
    this.baseUrl,
  });

  String get environment => isLive ? 'live' : 'test';
  
  String get authHeader => 'Bearer $apiKey';
}