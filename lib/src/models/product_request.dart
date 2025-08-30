/// Product request model.
library;

/// Product request configuration.
class ProductRequest {
  /// Product name.
  final String name;
  
  /// Product description.
  final String description;
  
  /// Product price.
  final int price;
  
  /// Currency.
  final String currency;
  
  /// Unlimited flag.
  final bool unlimited;
  
  /// Quantity.
  final int? quantity;

  const ProductRequest({
    required this.name,
    required this.description,
    required this.price,
    required this.currency,
    this.unlimited = false,
    this.quantity,
  });
}