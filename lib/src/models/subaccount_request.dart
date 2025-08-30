/// Subaccount request model.
library;

/// Subaccount request configuration.
class SubaccountRequest {
  /// Business name.
  final String businessName;
  
  /// Settlement bank.
  final String settlementBank;
  
  /// Account number.
  final String accountNumber;
  
  /// Percentage charge.
  final double percentageCharge;

  const SubaccountRequest({
    required this.businessName,
    required this.settlementBank,
    required this.accountNumber,
    required this.percentageCharge,
  });
}