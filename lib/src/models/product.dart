/// Product model for Paystack.
class Product {
  final String id;
  final String name;
  final String description;
  final int price;
  final String currency;
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.currency,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? 0,
      currency: json['currency'] ?? 'NGN',
      active: json['active'] ?? true,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }
}

/// Product request model for creating products.
class ProductRequest {
  final String name;
  final String description;
  final int price;
  final String currency;
  final bool active;

  ProductRequest({
    required this.name,
    required this.description,
    required this.price,
    this.currency = 'NGN',
    this.active = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'currency': currency,
      'active': active,
    };
  }
}