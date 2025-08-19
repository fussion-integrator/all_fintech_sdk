class OpenBankingSavings {
  final String savingsId;
  final String customerId;
  final String productId;
  final DateTime startDate;
  final String currency;
  final double savingsAmount;
  final String frequency;
  final double totalSavingsAmount;
  final int totalSavingsTransactions;
  final double missedSavingsAmount;
  final int missedSavingsTransactions;
  final DateTime nextSavingsDueDate;
  final double nextSavingsDueAmount;
  final List<CustomProperty>? customProperties;

  OpenBankingSavings({
    required this.savingsId,
    required this.customerId,
    required this.productId,
    required this.startDate,
    required this.currency,
    required this.savingsAmount,
    required this.frequency,
    required this.totalSavingsAmount,
    required this.totalSavingsTransactions,
    required this.missedSavingsAmount,
    required this.missedSavingsTransactions,
    required this.nextSavingsDueDate,
    required this.nextSavingsDueAmount,
    this.customProperties,
  });

  factory OpenBankingSavings.fromJson(Map<String, dynamic> json) {
    return OpenBankingSavings(
      savingsId: json['savings_id'],
      customerId: json['customer_id'],
      productId: json['product_id'],
      startDate: DateTime.parse(json['start_date']),
      currency: json['currency'],
      savingsAmount: json['savings_amount'].toDouble(),
      frequency: json['frequency'],
      totalSavingsAmount: json['total_savings_amount'].toDouble(),
      totalSavingsTransactions: json['total_savings_transactions'],
      missedSavingsAmount: json['missed_savings_amount'].toDouble(),
      missedSavingsTransactions: json['missed_savings_transactions'],
      nextSavingsDueDate: DateTime.parse(json['next_savings_due_date']),
      nextSavingsDueAmount: json['next_savings_due_amount'].toDouble(),
      customProperties: json['custom_properties'] != null
          ? (json['custom_properties'] as List)
              .map((p) => CustomProperty.fromJson(p))
              .toList()
          : null,
    );
  }
}

class OpenBankingTransaction {
  final String transactionId;
  final String accountNumber;
  final DateTime transactionDate;
  final String description;
  final double amount;
  final String type;
  final double balance;
  final String? reference;
  final List<CustomProperty>? customProperties;

  OpenBankingTransaction({
    required this.transactionId,
    required this.accountNumber,
    required this.transactionDate,
    required this.description,
    required this.amount,
    required this.type,
    required this.balance,
    this.reference,
    this.customProperties,
  });

  factory OpenBankingTransaction.fromJson(Map<String, dynamic> json) {
    return OpenBankingTransaction(
      transactionId: json['transaction_id'],
      accountNumber: json['account_number'],
      transactionDate: DateTime.parse(json['transaction_date']),
      description: json['description'],
      amount: json['amount'].toDouble(),
      type: json['type'],
      balance: json['balance'].toDouble(),
      reference: json['reference'],
      customProperties: json['custom_properties'] != null
          ? (json['custom_properties'] as List)
              .map((p) => CustomProperty.fromJson(p))
              .toList()
          : null,
    );
  }
}

class OpenBankingAccount {
  final String accountNumber;
  final String accountName;
  final String accountType;
  final String currency;
  final double availableBalance;
  final double ledgerBalance;
  final String bankCode;
  final String bankName;
  final List<CustomProperty>? customProperties;

  OpenBankingAccount({
    required this.accountNumber,
    required this.accountName,
    required this.accountType,
    required this.currency,
    required this.availableBalance,
    required this.ledgerBalance,
    required this.bankCode,
    required this.bankName,
    this.customProperties,
  });

  factory OpenBankingAccount.fromJson(Map<String, dynamic> json) {
    return OpenBankingAccount(
      accountNumber: json['account_number'],
      accountName: json['account_name'],
      accountType: json['account_type'],
      currency: json['currency'],
      availableBalance: json['available_balance'].toDouble(),
      ledgerBalance: json['ledger_balance'].toDouble(),
      bankCode: json['bank_code'],
      bankName: json['bank_name'],
      customProperties: json['custom_properties'] != null
          ? (json['custom_properties'] as List)
              .map((p) => CustomProperty.fromJson(p))
              .toList()
          : null,
    );
  }
}

class CustomProperty {
  final String id;
  final String description;
  final String type;
  final String value;

  CustomProperty({
    required this.id,
    required this.description,
    required this.type,
    required this.value,
  });

  factory CustomProperty.fromJson(Map<String, dynamic> json) {
    return CustomProperty(
      id: json['id'],
      description: json['description'],
      type: json['type'],
      value: json['value'],
    );
  }
}

class OpenBankingResponse<T> {
  final String status;
  final String message;
  final T data;

  OpenBankingResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory OpenBankingResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return OpenBankingResponse(
      status: json['status'],
      message: json['message'],
      data: fromJsonT(json['data']),
    );
  }
}

class OpenBankingPaginatedResponse<T> {
  final List<T> data;
  final PaginationMeta meta;
  final List<PaginationLink> links;

  OpenBankingPaginatedResponse({
    required this.data,
    required this.meta,
    required this.links,
  });

  factory OpenBankingPaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return OpenBankingPaginatedResponse(
      data: (json['data'] as List).map((item) => fromJsonT(item)).toList(),
      meta: PaginationMeta.fromJson(json['_meta']),
      links: (json['_links'] as List)
          .map((link) => PaginationLink.fromJson(link))
          .toList(),
    );
  }
}

class PaginationMeta {
  final int totalNumberOfRecords;
  final int totalNumberOfPages;
  final int pageNumber;
  final int pageSize;

  PaginationMeta({
    required this.totalNumberOfRecords,
    required this.totalNumberOfPages,
    required this.pageNumber,
    required this.pageSize,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      totalNumberOfRecords: json['total_number_of_records'],
      totalNumberOfPages: json['total_number_of_pages'],
      pageNumber: json['page_number'],
      pageSize: json['page_size'],
    );
  }
}

class PaginationLink {
  final String rel;
  final String href;

  PaginationLink({
    required this.rel,
    required this.href,
  });

  factory PaginationLink.fromJson(Map<String, dynamic> json) {
    return PaginationLink(
      rel: json['rel'],
      href: json['href'],
    );
  }
}

class OpenBankingError {
  final String status;
  final String errorCode;
  final String message;
  final Map<String, dynamic>? data;

  OpenBankingError({
    required this.status,
    required this.errorCode,
    required this.message,
    this.data,
  });

  factory OpenBankingError.fromJson(Map<String, dynamic> json) {
    return OpenBankingError(
      status: json['status'],
      errorCode: json['error_code'],
      message: json['message'],
      data: json['data'],
    );
  }
}

enum OpenBankingFrequency {
  daily('DAILY'),
  weekly('WEEKLY'),
  monthly('MONTHLY'),
  quarterly('QUARTERLY'),
  yearly('YEARLY');

  const OpenBankingFrequency(this.value);
  final String value;
}