import 'transaction.dart';

class Plan {
  final int id;
  final String name;
  final String planCode;
  final String? description;
  final int amount;
  final String interval;
  final String currency;
  final bool sendInvoices;
  final bool sendSms;
  final int? invoiceLimit;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Plan({
    required this.id,
    required this.name,
    required this.planCode,
    this.description,
    required this.amount,
    required this.interval,
    required this.currency,
    required this.sendInvoices,
    required this.sendSms,
    this.invoiceLimit,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['id'],
      name: json['name'],
      planCode: json['plan_code'],
      description: json['description'],
      amount: json['amount'],
      interval: json['interval'],
      currency: json['currency'],
      sendInvoices: json['send_invoices'] ?? true,
      sendSms: json['send_sms'] ?? true,
      invoiceLimit: json['invoice_limit'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class Subscription {
  final int id;
  final String subscriptionCode;
  final String emailToken;
  final int amount;
  final String status;
  final int quantity;
  final DateTime? nextPaymentDate;
  final Customer? customer;
  final Plan? plan;
  final Authorization? authorization;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Subscription({
    required this.id,
    required this.subscriptionCode,
    required this.emailToken,
    required this.amount,
    required this.status,
    required this.quantity,
    this.nextPaymentDate,
    this.customer,
    this.plan,
    this.authorization,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'],
      subscriptionCode: json['subscription_code'],
      emailToken: json['email_token'],
      amount: json['amount'],
      status: json['status'],
      quantity: json['quantity'] ?? 1,
      nextPaymentDate: json['next_payment_date'] != null
          ? DateTime.parse(json['next_payment_date'])
          : null,
      customer: json['customer'] != null
          ? Customer.fromJson(json['customer'])
          : null,
      plan: json['plan'] != null
          ? Plan.fromJson(json['plan'])
          : null,
      authorization: json['authorization'] != null
          ? Authorization.fromJson(json['authorization'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  bool get isActive => status == 'active';
  bool get isComplete => status == 'complete';
  bool get isCancelled => status == 'cancelled';
}

class PlanRequest {
  final String name;
  final int amount;
  final String interval;
  final String? description;
  final bool? sendInvoices;
  final bool? sendSms;
  final String currency;
  final int? invoiceLimit;

  const PlanRequest({
    required this.name,
    required this.amount,
    required this.interval,
    this.description,
    this.sendInvoices,
    this.sendSms,
    this.currency = 'NGN',
    this.invoiceLimit,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'name': name,
      'amount': amount,
      'interval': interval,
      'currency': currency,
    };

    if (description != null) json['description'] = description;
    if (sendInvoices != null) json['send_invoices'] = sendInvoices;
    if (sendSms != null) json['send_sms'] = sendSms;
    if (invoiceLimit != null) json['invoice_limit'] = invoiceLimit;

    return json;
  }
}

class SubscriptionRequest {
  final String customer;
  final String plan;
  final String? authorization;
  final DateTime? startDate;

  const SubscriptionRequest({
    required this.customer,
    required this.plan,
    this.authorization,
    this.startDate,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'customer': customer,
      'plan': plan,
    };

    if (authorization != null) json['authorization'] = authorization;
    if (startDate != null) json['start_date'] = startDate!.toIso8601String();

    return json;
  }
}