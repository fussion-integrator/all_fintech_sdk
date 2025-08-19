class PaymentRequest {
  final int amount;
  final String email;
  final String currency;
  final String? reference;
  final String? callbackUrl;
  final String? plan;
  final int? invoiceLimit;
  final Map<String, dynamic>? metadata;
  final List<String>? channels;
  final String? splitCode;
  final String? subaccount;
  final int? transactionCharge;
  final String? bearer;

  const PaymentRequest({
    required this.amount,
    required this.email,
    this.currency = 'NGN',
    this.reference,
    this.callbackUrl,
    this.plan,
    this.invoiceLimit,
    this.metadata,
    this.channels,
    this.splitCode,
    this.subaccount,
    this.transactionCharge,
    this.bearer,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'amount': amount,
      'email': email,
      'currency': currency,
    };

    if (reference != null) json['reference'] = reference;
    if (callbackUrl != null) json['callback_url'] = callbackUrl;
    if (plan != null) json['plan'] = plan;
    if (invoiceLimit != null) json['invoice_limit'] = invoiceLimit;
    if (metadata != null) json['metadata'] = metadata;
    if (channels != null) json['channels'] = channels;
    if (splitCode != null) json['split_code'] = splitCode;
    if (subaccount != null) json['subaccount'] = subaccount;
    if (transactionCharge != null) json['transaction_charge'] = transactionCharge;
    if (bearer != null) json['bearer'] = bearer;

    return json;
  }
}

class ChargeRequest {
  final String email;
  final int amount;
  final String? authorizationCode;
  final String? reference;
  final String currency;
  final Map<String, dynamic>? metadata;

  const ChargeRequest({
    required this.email,
    required this.amount,
    this.authorizationCode,
    this.reference,
    this.currency = 'NGN',
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'email': email,
      'amount': amount,
      'currency': currency,
    };

    if (authorizationCode != null) json['authorization_code'] = authorizationCode;
    if (reference != null) json['reference'] = reference;
    if (metadata != null) json['metadata'] = metadata;

    return json;
  }
}