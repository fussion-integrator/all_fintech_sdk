/// Payment page request model.
library;

/// Payment page request configuration.
class PaymentPageRequest {
  /// Page name.
  final String name;
  
  /// Page description.
  final String description;
  
  /// Amount.
  final int amount;

  const PaymentPageRequest({
    required this.name,
    required this.description,
    required this.amount,
  });
}