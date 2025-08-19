class Product {
  final int id;
  final String name;
  final String description;
  final String productCode;
  final int price;
  final String currency;
  final int? quantity;
  final bool unlimited;
  final bool active;
  final bool inStock;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.productCode,
    required this.price,
    required this.currency,
    this.quantity,
    required this.unlimited,
    required this.active,
    required this.inStock,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      productCode: json['product_code'],
      price: json['price'],
      currency: json['currency'],
      quantity: json['quantity'],
      unlimited: json['unlimited'] ?? false,
      active: json['active'] ?? true,
      inStock: json['in_stock'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class ProductRequest {
  final String name;
  final String description;
  final int price;
  final String currency;
  final bool? unlimited;
  final int? quantity;

  const ProductRequest({
    required this.name,
    required this.description,
    required this.price,
    this.currency = 'NGN',
    this.unlimited,
    this.quantity,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'name': name,
      'description': description,
      'price': price,
      'currency': currency,
    };

    if (unlimited != null) json['unlimited'] = unlimited;
    if (quantity != null) json['quantity'] = quantity;

    return json;
  }
}

class PaymentPage {
  final int id;
  final String name;
  final String? description;
  final int? amount;
  final String currency;
  final String slug;
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PaymentPage({
    required this.id,
    required this.name,
    this.description,
    this.amount,
    required this.currency,
    required this.slug,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PaymentPage.fromJson(Map<String, dynamic> json) {
    return PaymentPage(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      amount: json['amount'],
      currency: json['currency'],
      slug: json['slug'],
      active: json['active'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class PaymentPageRequest {
  final String name;
  final String? description;
  final int? amount;
  final String currency;
  final String? slug;
  final bool? fixedAmount;
  final String? redirectUrl;
  final String? successMessage;

  const PaymentPageRequest({
    required this.name,
    this.description,
    this.amount,
    this.currency = 'NGN',
    this.slug,
    this.fixedAmount,
    this.redirectUrl,
    this.successMessage,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'name': name,
      'currency': currency,
    };

    if (description != null) json['description'] = description;
    if (amount != null) json['amount'] = amount;
    if (slug != null) json['slug'] = slug;
    if (fixedAmount != null) json['fixed_amount'] = fixedAmount;
    if (redirectUrl != null) json['redirect_url'] = redirectUrl;
    if (successMessage != null) json['success_message'] = successMessage;

    return json;
  }
}

class Subaccount {
  final int id;
  final String subaccountCode;
  final String businessName;
  final String? description;
  final double percentageCharge;
  final String settlementBank;
  final String accountNumber;
  final String currency;
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Subaccount({
    required this.id,
    required this.subaccountCode,
    required this.businessName,
    this.description,
    required this.percentageCharge,
    required this.settlementBank,
    required this.accountNumber,
    required this.currency,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Subaccount.fromJson(Map<String, dynamic> json) {
    return Subaccount(
      id: json['id'],
      subaccountCode: json['subaccount_code'],
      businessName: json['business_name'],
      description: json['description'],
      percentageCharge: (json['percentage_charge'] ?? 0).toDouble(),
      settlementBank: json['settlement_bank'],
      accountNumber: json['account_number'],
      currency: json['currency'],
      active: json['active'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class SubaccountRequest {
  final String businessName;
  final String bankCode;
  final String accountNumber;
  final double percentageCharge;
  final String? description;
  final String? primaryContactEmail;
  final String? primaryContactName;
  final String? primaryContactPhone;

  const SubaccountRequest({
    required this.businessName,
    required this.bankCode,
    required this.accountNumber,
    required this.percentageCharge,
    this.description,
    this.primaryContactEmail,
    this.primaryContactName,
    this.primaryContactPhone,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'business_name': businessName,
      'bank_code': bankCode,
      'account_number': accountNumber,
      'percentage_charge': percentageCharge,
    };

    if (description != null) json['description'] = description;
    if (primaryContactEmail != null) json['primary_contact_email'] = primaryContactEmail;
    if (primaryContactName != null) json['primary_contact_name'] = primaryContactName;
    if (primaryContactPhone != null) json['primary_contact_phone'] = primaryContactPhone;

    return json;
  }
}