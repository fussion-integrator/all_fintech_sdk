/// Subaccount model.
library;

/// Subaccount configuration.
class Subaccount {
  /// Subaccount code.
  final String code;
  
  /// Share percentage.
  final double share;

  const Subaccount({
    required this.code,
    required this.share,
  });
}