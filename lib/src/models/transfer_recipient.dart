class TransferRecipient {
  final int id;
  final String recipientCode;
  final String type;
  final String name;
  final String? description;
  final String currency;
  final bool active;
  final Map<String, dynamic> details;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TransferRecipient({
    required this.id,
    required this.recipientCode,
    required this.type,
    required this.name,
    this.description,
    required this.currency,
    required this.active,
    required this.details,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TransferRecipient.fromJson(Map<String, dynamic> json) {
    return TransferRecipient(
      id: json['id'],
      recipientCode: json['recipient_code'],
      type: json['type'],
      name: json['name'],
      description: json['description'],
      currency: json['currency'],
      active: json['active'] ?? true,
      details: json['details'] ?? {},
      metadata: json['metadata'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  String? get accountNumber => details['account_number'];
  String? get accountName => details['account_name'];
  String? get bankCode => details['bank_code'];
  String? get bankName => details['bank_name'];
}

class TransferRecipientRequest {
  final String type;
  final String name;
  final String? accountNumber;
  final String? bankCode;
  final String? description;
  final String currency;
  final String? authorizationCode;
  final Map<String, dynamic>? metadata;

  const TransferRecipientRequest({
    required this.type,
    required this.name,
    this.accountNumber,
    this.bankCode,
    this.description,
    this.currency = 'NGN',
    this.authorizationCode,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'type': type,
      'name': name,
      'currency': currency,
    };

    if (accountNumber != null) json['account_number'] = accountNumber;
    if (bankCode != null) json['bank_code'] = bankCode;
    if (description != null) json['description'] = description;
    if (authorizationCode != null) json['authorization_code'] = authorizationCode;
    if (metadata != null) json['metadata'] = metadata;

    return json;
  }
}

class BulkTransferRecipientRequest {
  final List<TransferRecipientRequest> batch;

  const BulkTransferRecipientRequest({required this.batch});

  Map<String, dynamic> toJson() {
    return {
      'batch': batch.map((recipient) => recipient.toJson()).toList(),
    };
  }
}