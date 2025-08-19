class Transaction {
  final int id;
  final String reference;
  final int amount;
  final String currency;
  final String status;
  final String? gatewayResponse;
  final String? channel;
  final DateTime transactionDate;
  final Customer? customer;
  final Authorization? authorization;
  final int? fees;
  final Map<String, dynamic>? metadata;

  const Transaction({
    required this.id,
    required this.reference,
    required this.amount,
    required this.currency,
    required this.status,
    this.gatewayResponse,
    this.channel,
    required this.transactionDate,
    this.customer,
    this.authorization,
    this.fees,
    this.metadata,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      reference: json['reference'],
      amount: json['amount'],
      currency: json['currency'],
      status: json['status'],
      gatewayResponse: json['gateway_response'],
      channel: json['channel'],
      transactionDate: DateTime.parse(json['transaction_date']),
      customer: json['customer'] != null 
          ? Customer.fromJson(json['customer']) 
          : null,
      authorization: json['authorization'] != null 
          ? Authorization.fromJson(json['authorization']) 
          : null,
      fees: json['fees'],
      metadata: json['metadata'],
    );
  }

  bool get isSuccessful => status == 'success';
  bool get isPending => status == 'pending';
  bool get isFailed => status == 'failed';
}

class Customer {
  final int id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String customerCode;

  const Customer({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.phone,
    required this.customerCode,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phone: json['phone'],
      customerCode: json['customer_code'],
    );
  }
}

class Authorization {
  final String authorizationCode;
  final String bin;
  final String last4;
  final String expMonth;
  final String expYear;
  final String channel;
  final String cardType;
  final String bank;
  final String countryCode;
  final String brand;
  final bool reusable;

  const Authorization({
    required this.authorizationCode,
    required this.bin,
    required this.last4,
    required this.expMonth,
    required this.expYear,
    required this.channel,
    required this.cardType,
    required this.bank,
    required this.countryCode,
    required this.brand,
    required this.reusable,
  });

  factory Authorization.fromJson(Map<String, dynamic> json) {
    return Authorization(
      authorizationCode: json['authorization_code'],
      bin: json['bin'],
      last4: json['last4'],
      expMonth: json['exp_month'],
      expYear: json['exp_year'],
      channel: json['channel'],
      cardType: json['card_type'],
      bank: json['bank'],
      countryCode: json['country_code'],
      brand: json['brand'],
      reusable: json['reusable'] ?? false,
    );
  }
}