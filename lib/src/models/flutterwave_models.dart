// Flutterwave Payment Request
class FlutterwavePaymentRequest {
  final String txRef;
  final int amount;
  final String currency;
  final String redirectUrl;
  final FlutterwaveCustomer customer;
  final Map<String, dynamic>? customizations;
  final Map<String, dynamic>? meta;

  FlutterwavePaymentRequest({
    required this.txRef,
    required this.amount,
    required this.currency,
    required this.redirectUrl,
    required this.customer,
    this.customizations,
    this.meta,
  });

  Map<String, dynamic> toJson() {
    return {
      'tx_ref': txRef,
      'amount': amount,
      'currency': currency,
      'redirect_url': redirectUrl,
      'customer': customer.toJson(),
      if (customizations != null) 'customizations': customizations,
      if (meta != null) 'meta': meta,
    };
  }
}

// Flutterwave Customer
class FlutterwaveCustomer {
  final String? id;
  final String email;
  final FlutterwaveName? name;
  final FlutterwavePhone? phone;
  final FlutterwaveAddress? address;
  final Map<String, dynamic>? meta;
  final DateTime? createdDatetime;

  FlutterwaveCustomer({
    this.id,
    required this.email,
    this.name,
    this.phone,
    this.address,
    this.meta,
    this.createdDatetime,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      if (name != null) 'name': name!.toJson(),
      if (phone != null) 'phone': phone!.toJson(),
      if (address != null) 'address': address!.toJson(),
      if (meta != null) 'meta': meta,
    };
  }

  factory FlutterwaveCustomer.fromJson(Map<String, dynamic> json) {
    return FlutterwaveCustomer(
      id: json['id'],
      email: json['email'],
      name: json['name'] != null ? FlutterwaveName.fromJson(json['name']) : null,
      phone: json['phone'] != null ? FlutterwavePhone.fromJson(json['phone']) : null,
      address: json['address'] != null ? FlutterwaveAddress.fromJson(json['address']) : null,
      meta: json['meta'],
      createdDatetime: json['created_datetime'] != null 
          ? DateTime.parse(json['created_datetime']) 
          : null,
    );
  }
}

// Flutterwave Name
class FlutterwaveName {
  final String? first;
  final String? middle;
  final String? last;

  FlutterwaveName({
    this.first,
    this.middle,
    this.last,
  });

  Map<String, dynamic> toJson() {
    return {
      if (first != null) 'first': first,
      if (middle != null) 'middle': middle,
      if (last != null) 'last': last,
    };
  }

  factory FlutterwaveName.fromJson(Map<String, dynamic> json) {
    return FlutterwaveName(
      first: json['first'],
      middle: json['middle'],
      last: json['last'],
    );
  }
}

// Flutterwave Phone
class FlutterwavePhone {
  final String? countryCode;
  final String? number;

  FlutterwavePhone({
    this.countryCode,
    this.number,
  });

  Map<String, dynamic> toJson() {
    return {
      if (countryCode != null) 'country_code': countryCode,
      if (number != null) 'number': number,
    };
  }

  factory FlutterwavePhone.fromJson(Map<String, dynamic> json) {
    return FlutterwavePhone(
      countryCode: json['country_code'],
      number: json['number'],
    );
  }
}

// Flutterwave Address
class FlutterwaveAddress {
  final String? city;
  final String? country;
  final String? line1;
  final String? line2;
  final String? postalCode;
  final String? state;

  FlutterwaveAddress({
    this.city,
    this.country,
    this.line1,
    this.line2,
    this.postalCode,
    this.state,
  });

  Map<String, dynamic> toJson() {
    return {
      if (city != null) 'city': city,
      if (country != null) 'country': country,
      if (line1 != null) 'line1': line1,
      if (line2 != null) 'line2': line2,
      if (postalCode != null) 'postal_code': postalCode,
      if (state != null) 'state': state,
    };
  }

  factory FlutterwaveAddress.fromJson(Map<String, dynamic> json) {
    return FlutterwaveAddress(
      city: json['city'],
      country: json['country'],
      line1: json['line1'],
      line2: json['line2'],
      postalCode: json['postal_code'],
      state: json['state'],
    );
  }
}

// Flutterwave Customer Request
class FlutterwaveCustomerRequest {
  final String email;
  final FlutterwaveName? name;
  final FlutterwavePhone? phone;
  final FlutterwaveAddress? address;
  final Map<String, dynamic>? meta;

  FlutterwaveCustomerRequest({
    required this.email,
    this.name,
    this.phone,
    this.address,
    this.meta,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      if (name != null) 'name': name!.toJson(),
      if (phone != null) 'phone': phone!.toJson(),
      if (address != null) 'address': address!.toJson(),
      if (meta != null) 'meta': meta,
    };
  }
}

// Flutterwave Transaction
class FlutterwaveTransaction {
  final int id;
  final String txRef;
  final String flwRef;
  final String deviceFingerprint;
  final int amount;
  final int chargedAmount;
  final int appFee;
  final int merchantFee;
  final String processorResponse;
  final String authModel;
  final String currency;
  final String ip;
  final String narration;
  final String status;
  final String paymentType;
  final DateTime createdAt;
  final int accountId;
  final FlutterwaveCustomer customer;
  final FlutterwaveCard? card;

  FlutterwaveTransaction({
    required this.id,
    required this.txRef,
    required this.flwRef,
    required this.deviceFingerprint,
    required this.amount,
    required this.chargedAmount,
    required this.appFee,
    required this.merchantFee,
    required this.processorResponse,
    required this.authModel,
    required this.currency,
    required this.ip,
    required this.narration,
    required this.status,
    required this.paymentType,
    required this.createdAt,
    required this.accountId,
    required this.customer,
    this.card,
  });

  factory FlutterwaveTransaction.fromJson(Map<String, dynamic> json) {
    return FlutterwaveTransaction(
      id: json['id'],
      txRef: json['tx_ref'],
      flwRef: json['flw_ref'],
      deviceFingerprint: json['device_fingerprint'],
      amount: json['amount'],
      chargedAmount: json['charged_amount'],
      appFee: json['app_fee'],
      merchantFee: json['merchant_fee'],
      processorResponse: json['processor_response'],
      authModel: json['auth_model'],
      currency: json['currency'],
      ip: json['ip'],
      narration: json['narration'],
      status: json['status'],
      paymentType: json['payment_type'],
      createdAt: DateTime.parse(json['created_at']),
      accountId: json['account_id'],
      customer: FlutterwaveCustomer.fromJson(json['customer']),
      card: json['card'] != null ? FlutterwaveCard.fromJson(json['card']) : null,
    );
  }
}

// Flutterwave Card
class FlutterwaveCard {
  final String first6digits;
  final String last4digits;
  final String issuer;
  final String country;
  final String type;
  final String token;
  final String expiry;

  FlutterwaveCard({
    required this.first6digits,
    required this.last4digits,
    required this.issuer,
    required this.country,
    required this.type,
    required this.token,
    required this.expiry,
  });

  factory FlutterwaveCard.fromJson(Map<String, dynamic> json) {
    return FlutterwaveCard(
      first6digits: json['first_6digits'],
      last4digits: json['last_4digits'],
      issuer: json['issuer'],
      country: json['country'],
      type: json['type'],
      token: json['token'],
      expiry: json['expiry'],
    );
  }
}

// Flutterwave Transfer Request
class FlutterwaveTransferRequest {
  final String accountBank;
  final String accountNumber;
  final int amount;
  final String currency;
  final String reference;
  final String narration;
  final String? beneficiaryName;

  FlutterwaveTransferRequest({
    required this.accountBank,
    required this.accountNumber,
    required this.amount,
    required this.currency,
    required this.reference,
    required this.narration,
    this.beneficiaryName,
  });

  Map<String, dynamic> toJson() {
    return {
      'account_bank': accountBank,
      'account_number': accountNumber,
      'amount': amount,
      'currency': currency,
      'reference': reference,
      'narration': narration,
      if (beneficiaryName != null) 'beneficiary_name': beneficiaryName,
    };
  }
}

// Flutterwave Transfer
class FlutterwaveTransfer {
  final int id;
  final String reference;
  final String accountNumber;
  final String bankCode;
  final String fullName;
  final DateTime createdAt;
  final String currency;
  final int amount;
  final int fee;
  final String status;
  final String narration;
  final bool completeMessage;
  final bool requiresApproval;
  final bool isApproved;
  final String bankName;

  FlutterwaveTransfer({
    required this.id,
    required this.reference,
    required this.accountNumber,
    required this.bankCode,
    required this.fullName,
    required this.createdAt,
    required this.currency,
    required this.amount,
    required this.fee,
    required this.status,
    required this.narration,
    required this.completeMessage,
    required this.requiresApproval,
    required this.isApproved,
    required this.bankName,
  });

  factory FlutterwaveTransfer.fromJson(Map<String, dynamic> json) {
    return FlutterwaveTransfer(
      id: json['id'],
      reference: json['reference'],
      accountNumber: json['account_number'],
      bankCode: json['bank_code'],
      fullName: json['full_name'],
      createdAt: DateTime.parse(json['created_at']),
      currency: json['currency'],
      amount: json['amount'],
      fee: json['fee'],
      status: json['status'],
      narration: json['narration'],
      completeMessage: json['complete_message'],
      requiresApproval: json['requires_approval'],
      isApproved: json['is_approved'],
      bankName: json['bank_name'],
    );
  }
}

// Flutterwave Bank
class FlutterwaveBank {
  final String id;
  final String code;
  final String name;

  FlutterwaveBank({
    required this.id,
    required this.code,
    required this.name,
  });

  factory FlutterwaveBank.fromJson(Map<String, dynamic> json) {
    return FlutterwaveBank(
      id: json['id'].toString(),
      code: json['code'],
      name: json['name'],
    );
  }
}

// Flutterwave Mobile Network
class FlutterwaveMobileNetwork {
  final String id;
  final String network;
  final String name;

  FlutterwaveMobileNetwork({
    required this.id,
    required this.network,
    required this.name,
  });

  factory FlutterwaveMobileNetwork.fromJson(Map<String, dynamic> json) {
    return FlutterwaveMobileNetwork(
      id: json['id'],
      network: json['network'],
      name: json['name'],
    );
  }
}

// Flutterwave Bank Branch
class FlutterwaveBankBranch {
  final String id;
  final String code;
  final String name;
  final String? swiftCode;
  final String? bic;

  FlutterwaveBankBranch({
    required this.id,
    required this.code,
    required this.name,
    this.swiftCode,
    this.bic,
  });

  factory FlutterwaveBankBranch.fromJson(Map<String, dynamic> json) {
    return FlutterwaveBankBranch(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      swiftCode: json['swift_code'],
      bic: json['bic'],
    );
  }
}

// Flutterwave Account Resolution
class FlutterwaveAccountResolution {
  final String bankCode;
  final String accountNumber;
  final String accountName;

  FlutterwaveAccountResolution({
    required this.bankCode,
    required this.accountNumber,
    required this.accountName,
  });

  factory FlutterwaveAccountResolution.fromJson(Map<String, dynamic> json) {
    return FlutterwaveAccountResolution(
      bankCode: json['bank_code'],
      accountNumber: json['account_number'],
      accountName: json['account_name'],
    );
  }
}

// Flutterwave Transfer Recipient
class FlutterwaveTransferRecipient {
  final String id;
  final String type;
  final FlutterwaveName name;
  final String currency;
  final Map<String, dynamic>? nationalIdentification;
  final FlutterwavePhone? phone;
  final String? dateOfBirth;
  final String email;
  final FlutterwaveAddress? address;
  final Map<String, dynamic>? bank;
  final Map<String, dynamic>? mobileMoney;
  final Map<String, dynamic>? cashPickup;

  FlutterwaveTransferRecipient({
    required this.id,
    required this.type,
    required this.name,
    required this.currency,
    this.nationalIdentification,
    this.phone,
    this.dateOfBirth,
    required this.email,
    this.address,
    this.bank,
    this.mobileMoney,
    this.cashPickup,
  });

  factory FlutterwaveTransferRecipient.fromJson(Map<String, dynamic> json) {
    return FlutterwaveTransferRecipient(
      id: json['id'],
      type: json['type'],
      name: FlutterwaveName.fromJson(json['name']),
      currency: json['currency'],
      nationalIdentification: json['national_identification'],
      phone: json['phone'] != null ? FlutterwavePhone.fromJson(json['phone']) : null,
      dateOfBirth: json['date_of_birth'],
      email: json['email'],
      address: json['address'] != null ? FlutterwaveAddress.fromJson(json['address']) : null,
      bank: json['bank'],
      mobileMoney: json['mobile_money'],
      cashPickup: json['cash_pickup'],
    );
  }
}

// Flutterwave Transfer Recipient Request
class FlutterwaveTransferRecipientRequest {
  final Map<String, dynamic> recipientData;

  FlutterwaveTransferRecipientRequest({
    required this.recipientData,
  });

  Map<String, dynamic> toJson() {
    return recipientData;
  }
}

// Flutterwave Transfer Sender
class FlutterwaveTransferSender {
  final String id;
  final FlutterwaveName name;
  final Map<String, dynamic>? nationalIdentification;
  final FlutterwavePhone? phone;
  final String? dateOfBirth;
  final String email;
  final FlutterwaveAddress? address;

  FlutterwaveTransferSender({
    required this.id,
    required this.name,
    this.nationalIdentification,
    this.phone,
    this.dateOfBirth,
    required this.email,
    this.address,
  });

  factory FlutterwaveTransferSender.fromJson(Map<String, dynamic> json) {
    return FlutterwaveTransferSender(
      id: json['id'],
      name: FlutterwaveName.fromJson(json['name']),
      nationalIdentification: json['national_identification'],
      phone: json['phone'] != null ? FlutterwavePhone.fromJson(json['phone']) : null,
      dateOfBirth: json['date_of_birth'],
      email: json['email'],
      address: json['address'] != null ? FlutterwaveAddress.fromJson(json['address']) : null,
    );
  }
}

// Flutterwave Transfer Sender Request
class FlutterwaveTransferSenderRequest {
  final Map<String, dynamic> senderData;

  FlutterwaveTransferSenderRequest({
    required this.senderData,
  });

  Map<String, dynamic> toJson() {
    return senderData;
  }
}

// Flutterwave Transfer Rate
class FlutterwaveTransferRate {
  final String id;
  final String rate;
  final Map<String, dynamic> source;
  final Map<String, dynamic> destination;
  final DateTime createdDatetime;

  FlutterwaveTransferRate({
    required this.id,
    required this.rate,
    required this.source,
    required this.destination,
    required this.createdDatetime,
  });

  factory FlutterwaveTransferRate.fromJson(Map<String, dynamic> json) {
    return FlutterwaveTransferRate(
      id: json['id'],
      rate: json['rate'],
      source: json['source'],
      destination: json['destination'],
      createdDatetime: DateTime.parse(json['created_datetime']),
    );
  }
}

// Flutterwave Transfer Rate Request
class FlutterwaveTransferRateRequest {
  final Map<String, dynamic> source;
  final Map<String, dynamic> destination;
  final int? precision;

  FlutterwaveTransferRateRequest({
    required this.source,
    required this.destination,
    this.precision,
  });

  Map<String, dynamic> toJson() {
    return {
      'source': source,
      'destination': destination,
      if (precision != null) 'precision': precision,
    };
  }
}

// Flutterwave Settlement
class FlutterwaveSettlement {
  final String id;
  final String status;
  final double amount;
  final String currency;
  final List<Map<String, dynamic>> fees;
  final String chargeback;
  final String refund;
  final String destination;
  final String chargeCount;
  final List<Map<String, dynamic>> charges;
  final DateTime createdDatetime;

  FlutterwaveSettlement({
    required this.id,
    required this.status,
    required this.amount,
    required this.currency,
    required this.fees,
    required this.chargeback,
    required this.refund,
    required this.destination,
    required this.chargeCount,
    required this.charges,
    required this.createdDatetime,
  });

  factory FlutterwaveSettlement.fromJson(Map<String, dynamic> json) {
    return FlutterwaveSettlement(
      id: json['id'],
      status: json['status'],
      amount: json['amount'].toDouble(),
      currency: json['currency'],
      fees: List<Map<String, dynamic>>.from(json['fees']),
      chargeback: json['chargeback'],
      refund: json['refund'],
      destination: json['destination'],
      chargeCount: json['charge_count'],
      charges: List<Map<String, dynamic>>.from(json['charges']),
      createdDatetime: DateTime.parse(json['created_datetime']),
    );
  }
}

// Flutterwave Chargeback
class FlutterwaveChargeback {
  final int id;
  final String chargeId;
  final double amount;
  final Map<String, dynamic>? meta;
  final String stage;
  final String status;
  final String type;
  final DateTime dueDatetime;
  final DateTime createdDatetime;
  final DateTime updatedDatetime;
  final String? settlementId;
  final String? uploadedProof;
  final String? comment;
  final String? provider;
  final String? arn;
  final String? initiator;

  FlutterwaveChargeback({
    required this.id,
    required this.chargeId,
    required this.amount,
    this.meta,
    required this.stage,
    required this.status,
    required this.type,
    required this.dueDatetime,
    required this.createdDatetime,
    required this.updatedDatetime,
    this.settlementId,
    this.uploadedProof,
    this.comment,
    this.provider,
    this.arn,
    this.initiator,
  });

  factory FlutterwaveChargeback.fromJson(Map<String, dynamic> json) {
    return FlutterwaveChargeback(
      id: json['id'],
      chargeId: json['charge_id'],
      amount: json['amount'].toDouble(),
      meta: json['meta'],
      stage: json['stage'],
      status: json['status'],
      type: json['type'],
      dueDatetime: DateTime.parse(json['due_datetime']),
      createdDatetime: DateTime.parse(json['created_datetime']),
      updatedDatetime: DateTime.parse(json['updated_datetime']),
      settlementId: json['settlement_id'],
      uploadedProof: json['uploaded_proof'],
      comment: json['comment'],
      provider: json['provider'],
      arn: json['arn'],
      initiator: json['initiator'],
    );
  }
}

// Flutterwave Chargeback Request
class FlutterwaveChargebackRequest {
  final String chargeId;
  final double amount;
  final String? stage;
  final String? status;
  final String type;
  final String? uploadedProof;
  final String? comment;
  final String? provider;
  final String? arn;
  final String? initiator;
  final int expiry;

  FlutterwaveChargebackRequest({
    required this.chargeId,
    required this.amount,
    this.stage,
    this.status,
    required this.type,
    this.uploadedProof,
    this.comment,
    this.provider,
    this.arn,
    this.initiator,
    required this.expiry,
  });

  Map<String, dynamic> toJson() {
    return {
      'charge_id': chargeId,
      'amount': amount,
      if (stage != null) 'stage': stage,
      if (status != null) 'status': status,
      'type': type,
      if (uploadedProof != null) 'uploaded_proof': uploadedProof,
      if (comment != null) 'comment': comment,
      if (provider != null) 'provider': provider,
      if (arn != null) 'arn': arn,
      if (initiator != null) 'initiator': initiator,
      'expiry': expiry,
    };
  }
}

// Flutterwave Refund
class FlutterwaveRefund {
  final String id;
  final double amountRefunded;
  final Map<String, dynamic>? meta;
  final String reason;
  final String status;
  final String chargeId;
  final String createdDatetime;

  FlutterwaveRefund({
    required this.id,
    required this.amountRefunded,
    this.meta,
    required this.reason,
    required this.status,
    required this.chargeId,
    required this.createdDatetime,
  });

  factory FlutterwaveRefund.fromJson(Map<String, dynamic> json) {
    return FlutterwaveRefund(
      id: json['id'],
      amountRefunded: json['amount_refunded'].toDouble(),
      meta: json['meta'],
      reason: json['reason'],
      status: json['status'],
      chargeId: json['charge_id'],
      createdDatetime: json['created_datetime'],
    );
  }
}

// Flutterwave Refund Request
class FlutterwaveRefundRequest {
  final double amount;
  final String chargeId;
  final Map<String, dynamic>? meta;
  final String reason;

  FlutterwaveRefundRequest({
    required this.amount,
    required this.chargeId,
    this.meta,
    required this.reason,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'charge_id': chargeId,
      if (meta != null) 'meta': meta,
      'reason': reason,
    };
  }
}

// Flutterwave Order
class FlutterwaveOrder {
  final String id;
  final double amount;
  final String currency;
  final String reference;
  final String customerId;
  final String paymentMethodId;
  final String? redirectUrl;
  final String status;
  final Map<String, dynamic>? processorResponse;
  final Map<String, dynamic>? meta;
  final Map<String, dynamic>? nextAction;
  final Map<String, dynamic>? paymentMethodDetails;
  final DateTime createdDatetime;

  FlutterwaveOrder({
    required this.id,
    required this.amount,
    required this.currency,
    required this.reference,
    required this.customerId,
    required this.paymentMethodId,
    this.redirectUrl,
    required this.status,
    this.processorResponse,
    this.meta,
    this.nextAction,
    this.paymentMethodDetails,
    required this.createdDatetime,
  });

  factory FlutterwaveOrder.fromJson(Map<String, dynamic> json) {
    return FlutterwaveOrder(
      id: json['id'],
      amount: json['amount'].toDouble(),
      currency: json['currency'],
      reference: json['reference'],
      customerId: json['customer_id'],
      paymentMethodId: json['payment_method_id'],
      redirectUrl: json['redirect_url'],
      status: json['status'],
      processorResponse: json['processor_response'],
      meta: json['meta'],
      nextAction: json['next_action'],
      paymentMethodDetails: json['payment_method_details'],
      createdDatetime: DateTime.parse(json['created_datetime']),
    );
  }
}

// Flutterwave Order Request
class FlutterwaveOrderRequest {
  final double amount;
  final String currency;
  final String reference;
  final String customerId;
  final String paymentMethodId;
  final String? redirectUrl;
  final Map<String, dynamic>? meta;

  FlutterwaveOrderRequest({
    required this.amount,
    required this.currency,
    required this.reference,
    required this.customerId,
    required this.paymentMethodId,
    this.redirectUrl,
    this.meta,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'currency': currency,
      'reference': reference,
      'customer_id': customerId,
      'payment_method_id': paymentMethodId,
      if (redirectUrl != null) 'redirect_url': redirectUrl,
      if (meta != null) 'meta': meta,
    };
  }
}

// Flutterwave Charge
class FlutterwaveCharge {
  final String id;
  final double amount;
  final String currency;
  final String reference;
  final String customerId;
  final String paymentMethodId;
  final String? redirectUrl;
  final bool refunded;
  final String status;
  final Map<String, dynamic>? processorResponse;
  final Map<String, dynamic>? meta;
  final DateTime createdDatetime;

  FlutterwaveCharge({
    required this.id,
    required this.amount,
    required this.currency,
    required this.reference,
    required this.customerId,
    required this.paymentMethodId,
    this.redirectUrl,
    required this.refunded,
    required this.status,
    this.processorResponse,
    this.meta,
    required this.createdDatetime,
  });

  factory FlutterwaveCharge.fromJson(Map<String, dynamic> json) {
    return FlutterwaveCharge(
      id: json['id'],
      amount: json['amount'].toDouble(),
      currency: json['currency'],
      reference: json['reference'],
      customerId: json['customer_id'],
      paymentMethodId: json['payment_method']['id'],
      redirectUrl: json['redirect_url'],
      refunded: json['refunded'],
      status: json['status'],
      processorResponse: json['processor_response'],
      meta: json['meta'],
      createdDatetime: DateTime.parse(json['created_datetime']),
    );
  }
}

// Flutterwave Charge Request
class FlutterwaveChargeRequest {
  final double amount;
  final String currency;
  final String reference;
  final String customerId;
  final String paymentMethodId;
  final String? redirectUrl;
  final bool recurring;
  final String? orderId;
  final Map<String, dynamic>? meta;

  FlutterwaveChargeRequest({
    required this.amount,
    required this.currency,
    required this.reference,
    required this.customerId,
    required this.paymentMethodId,
    this.redirectUrl,
    this.recurring = false,
    this.orderId,
    this.meta,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'currency': currency,
      'reference': reference,
      'customer_id': customerId,
      'payment_method_id': paymentMethodId,
      if (redirectUrl != null) 'redirect_url': redirectUrl,
      'recurring': recurring,
      if (orderId != null) 'order_id': orderId,
      if (meta != null) 'meta': meta,
    };
  }
}

// Flutterwave Payment Method
class FlutterwavePaymentMethod {
  final String id;
  final String type;
  final String customerId;
  final Map<String, dynamic>? card;
  final Map<String, dynamic>? bankAccount;
  final Map<String, dynamic>? mobileMoney;
  final Map<String, dynamic>? ussd;
  final Map<String, dynamic>? bankTransfer;
  final Map<String, dynamic>? meta;
  final String? deviceFingerprint;
  final String? clientIp;
  final DateTime createdDatetime;

  FlutterwavePaymentMethod({
    required this.id,
    required this.type,
    required this.customerId,
    this.card,
    this.bankAccount,
    this.mobileMoney,
    this.ussd,
    this.bankTransfer,
    this.meta,
    this.deviceFingerprint,
    this.clientIp,
    required this.createdDatetime,
  });

  factory FlutterwavePaymentMethod.fromJson(Map<String, dynamic> json) {
    return FlutterwavePaymentMethod(
      id: json['id'],
      type: json['type'],
      customerId: json['customer_id'],
      card: json['card'],
      bankAccount: json['bank_account'],
      mobileMoney: json['mobile_money'],
      ussd: json['ussd'],
      bankTransfer: json['bank_transfer'],
      meta: json['meta'],
      deviceFingerprint: json['device_fingerprint'],
      clientIp: json['client_ip'],
      createdDatetime: DateTime.parse(json['created_datetime']),
    );
  }
}

// Flutterwave Orchestration Request
class FlutterwaveOrchestrationRequest {
  final double amount;
  final String currency;
  final String reference;
  final FlutterwaveCustomer customer;
  final Map<String, dynamic> paymentMethod;
  final String? redirectUrl;
  final Map<String, dynamic>? meta;

  FlutterwaveOrchestrationRequest({
    required this.amount,
    required this.currency,
    required this.reference,
    required this.customer,
    required this.paymentMethod,
    this.redirectUrl,
    this.meta,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'currency': currency,
      'reference': reference,
      'customer': customer.toJson(),
      'payment_method': paymentMethod,
      if (redirectUrl != null) 'redirect_url': redirectUrl,
      if (meta != null) 'meta': meta,
    };
  }
}

// Flutterwave Direct Transfer Request
class FlutterwaveDirectTransferRequest {
  final String action;
  final String? reference;
  final String? narration;
  final Map<String, dynamic>? disburseOption;
  final String? callbackUrl;
  final Map<String, dynamic>? meta;
  final Map<String, dynamic> paymentInstruction;
  final Map<String, dynamic>? bank;
  final Map<String, dynamic>? mobileMoney;
  final Map<String, dynamic>? wallet;

  FlutterwaveDirectTransferRequest({
    this.action = 'instant',
    this.reference,
    this.narration,
    this.disburseOption,
    this.callbackUrl,
    this.meta,
    required this.paymentInstruction,
    this.bank,
    this.mobileMoney,
    this.wallet,
  });

  Map<String, dynamic> toJson() {
    return {
      'action': action,
      if (reference != null) 'reference': reference,
      if (narration != null) 'narration': narration,
      if (disburseOption != null) 'disburse_option': disburseOption,
      if (callbackUrl != null) 'callback_url': callbackUrl,
      if (meta != null) 'meta': meta,
      'payment_instruction': paymentInstruction,
      if (bank != null) 'bank': bank,
      if (mobileMoney != null) 'mobile_money': mobileMoney,
      if (wallet != null) 'wallet': wallet,
    };
  }
}

// Flutterwave Transfer Request (using recipient/sender IDs)
class FlutterwaveTransferCreateRequest {
  final String action;
  final String? reference;
  final String? narration;
  final Map<String, dynamic>? disburseOption;
  final String? callbackUrl;
  final Map<String, dynamic>? meta;
  final Map<String, dynamic> paymentInstruction;

  FlutterwaveTransferCreateRequest({
    this.action = 'instant',
    this.reference,
    this.narration,
    this.disburseOption,
    this.callbackUrl,
    this.meta,
    required this.paymentInstruction,
  });

  Map<String, dynamic> toJson() {
    return {
      'action': action,
      if (reference != null) 'reference': reference,
      if (narration != null) 'narration': narration,
      if (disburseOption != null) 'disburse_option': disburseOption,
      if (callbackUrl != null) 'callback_url': callbackUrl,
      if (meta != null) 'meta': meta,
      'payment_instruction': paymentInstruction,
    };
  }
}

// Flutterwave Transfer Update Request
class FlutterwaveTransferUpdateRequest {
  final bool? initiate;
  final bool? close;
  final Map<String, dynamic>? disburseOption;

  FlutterwaveTransferUpdateRequest({
    this.initiate,
    this.close,
    this.disburseOption,
  });

  Map<String, dynamic> toJson() {
    return {
      if (initiate != null) 'initiate': initiate,
      if (close != null) 'close': close,
      if (disburseOption != null) 'disburse_option': disburseOption,
    };
  }
}

// Flutterwave Transfer Retry Request
class FlutterwaveTransferRetryRequest {
  final String action;
  final String? reference;
  final Map<String, dynamic>? meta;
  final String? callbackUrl;

  FlutterwaveTransferRetryRequest({
    required this.action,
    this.reference,
    this.meta,
    this.callbackUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'action': action,
      if (reference != null) 'reference': reference,
      if (meta != null) 'meta': meta,
      if (callbackUrl != null) 'callback_url': callbackUrl,
    };
  }
}

// Flutterwave Virtual Account
class FlutterwaveVirtualAccount {
  final String id;
  final double amount;
  final String accountNumber;
  final String reference;
  final String accountBankName;
  final String accountType;
  final String status;
  final DateTime? accountExpirationDatetime;
  final String? note;
  final String customerId;
  final DateTime createdDatetime;
  final Map<String, dynamic>? meta;
  final String? customerReference;
  final String currency;

  FlutterwaveVirtualAccount({
    required this.id,
    required this.amount,
    required this.accountNumber,
    required this.reference,
    required this.accountBankName,
    required this.accountType,
    required this.status,
    this.accountExpirationDatetime,
    this.note,
    required this.customerId,
    required this.createdDatetime,
    this.meta,
    this.customerReference,
    required this.currency,
  });

  factory FlutterwaveVirtualAccount.fromJson(Map<String, dynamic> json) {
    return FlutterwaveVirtualAccount(
      id: json['id'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      accountNumber: json['account_number'] ?? '',
      reference: json['reference'] ?? '',
      accountBankName: json['account_bank_name'] ?? '',
      accountType: json['account_type'] ?? '',
      status: json['status'] ?? '',
      accountExpirationDatetime: json['account_expiration_datetime'] != null
          ? DateTime.parse(json['account_expiration_datetime'])
          : null,
      note: json['note'],
      customerId: json['customer_id'] ?? '',
      createdDatetime: DateTime.parse(json['created_datetime']),
      meta: json['meta'],
      customerReference: json['customer_reference'],
      currency: json['currency'] ?? '',
    );
  }
}

// Flutterwave Virtual Account Request
class FlutterwaveVirtualAccountRequest {
  final String reference;
  final String customerId;
  final double amount;
  final int? expiry;
  final String currency;
  final String accountType;
  final Map<String, dynamic>? meta;
  final String? narration;
  final String? bvn;
  final String? nin;
  final String? customerAccountNumber;

  FlutterwaveVirtualAccountRequest({
    required this.reference,
    required this.customerId,
    required this.amount,
    this.expiry,
    required this.currency,
    required this.accountType,
    this.meta,
    this.narration,
    this.bvn,
    this.nin,
    this.customerAccountNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'reference': reference,
      'customer_id': customerId,
      'amount': amount,
      if (expiry != null) 'expiry': expiry,
      'currency': currency,
      'account_type': accountType,
      if (meta != null) 'meta': meta,
      if (narration != null) 'narration': narration,
      if (bvn != null) 'bvn': bvn,
      if (nin != null) 'nin': nin,
      if (customerAccountNumber != null) 'customer_account_number': customerAccountNumber,
    };
  }
}

// Flutterwave Virtual Account Update Request
class FlutterwaveVirtualAccountUpdateRequest {
  final String actionType;
  final String? status;
  final String? bvn;
  final Map<String, dynamic>? meta;

  FlutterwaveVirtualAccountUpdateRequest({
    required this.actionType,
    this.status,
    this.bvn,
    this.meta,
  });

  Map<String, dynamic> toJson() {
    return {
      'action_type': actionType,
      if (status != null) 'status': status,
      if (bvn != null) 'bvn': bvn,
      if (meta != null) 'meta': meta,
    };
  }
}