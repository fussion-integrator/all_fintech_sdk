import 'transfer_recipient.dart';

class Transfer {
  final int id;
  final String transferCode;
  final int amount;
  final String currency;
  final String source;
  final String? reason;
  final String status;
  final String? reference;
  final TransferRecipient? recipient;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Transfer({
    required this.id,
    required this.transferCode,
    required this.amount,
    required this.currency,
    required this.source,
    this.reason,
    required this.status,
    this.reference,
    this.recipient,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Transfer.fromJson(Map<String, dynamic> json) {
    return Transfer(
      id: json['id'],
      transferCode: json['transfer_code'],
      amount: json['amount'],
      currency: json['currency'],
      source: json['source'],
      reason: json['reason'],
      status: json['status'],
      reference: json['reference'],
      recipient: json['recipient'] != null
          ? TransferRecipient.fromJson(json['recipient'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  bool get isSuccessful => status == 'success';
  bool get isPending => status == 'pending';
  bool get requiresOtp => status == 'otp';
}

class TransferRequest {
  final String source;
  final int amount;
  final String recipient;
  final String? reason;
  final String currency;
  final String? accountReference;
  final String? reference;

  const TransferRequest({
    this.source = 'balance',
    required this.amount,
    required this.recipient,
    this.reason,
    this.currency = 'NGN',
    this.accountReference,
    this.reference,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'source': source,
      'amount': amount,
      'recipient': recipient,
      'currency': currency,
    };

    if (reason != null) json['reason'] = reason;
    if (accountReference != null) json['account_reference'] = accountReference;
    if (reference != null) json['reference'] = reference;

    return json;
  }
}

class BulkTransferRequest {
  final String source;
  final String currency;
  final List<TransferItem> transfers;

  const BulkTransferRequest({
    this.source = 'balance',
    this.currency = 'NGN',
    required this.transfers,
  });

  Map<String, dynamic> toJson() {
    return {
      'source': source,
      'currency': currency,
      'transfers': transfers.map((t) => t.toJson()).toList(),
    };
  }
}

class TransferItem {
  final int amount;
  final String recipient;
  final String? reference;
  final String? reason;

  const TransferItem({
    required this.amount,
    required this.recipient,
    this.reference,
    this.reason,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'amount': amount,
      'recipient': recipient,
    };

    if (reference != null) json['reference'] = reference;
    if (reason != null) json['reason'] = reason;

    return json;
  }
}

class BulkChargeRequest {
  final List<ChargeItem> charges;

  const BulkChargeRequest({required this.charges});

  Map<String, dynamic> toJson() {
    return {
      'charges': charges.map((c) => c.toJson()).toList(),
    };
  }
}

class ChargeItem {
  final String authorization;
  final int amount;
  final String reference;

  const ChargeItem({
    required this.authorization,
    required this.amount,
    required this.reference,
  });

  Map<String, dynamic> toJson() {
    return {
      'authorization': authorization,
      'amount': amount,
      'reference': reference,
    };
  }
}