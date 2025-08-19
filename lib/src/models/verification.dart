class AccountResolution {
  final String accountNumber;
  final String accountName;

  AccountResolution({
    required this.accountNumber,
    required this.accountName,
  });

  factory AccountResolution.fromJson(Map<String, dynamic> json) {
    return AccountResolution(
      accountNumber: json['account_number'],
      accountName: json['account_name'],
    );
  }
}

class AccountValidationRequest {
  final String accountName;
  final String accountNumber;
  final String accountType;
  final String bankCode;
  final String countryCode;
  final String documentType;
  final String? documentNumber;

  AccountValidationRequest({
    required this.accountName,
    required this.accountNumber,
    required this.accountType,
    required this.bankCode,
    required this.countryCode,
    required this.documentType,
    this.documentNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'account_name': accountName,
      'account_number': accountNumber,
      'account_type': accountType,
      'bank_code': bankCode,
      'country_code': countryCode,
      'document_type': documentType,
      if (documentNumber != null) 'document_number': documentNumber,
    };
  }
}

class AccountValidation {
  final bool verified;
  final String verificationMessage;

  AccountValidation({
    required this.verified,
    required this.verificationMessage,
  });

  factory AccountValidation.fromJson(Map<String, dynamic> json) {
    return AccountValidation(
      verified: json['verified'],
      verificationMessage: json['verificationMessage'],
    );
  }
}

class CardBin {
  final String bin;
  final String brand;
  final String subBrand;
  final String countryCode;
  final String countryName;
  final String cardType;
  final String bank;
  final int linkedBankId;

  CardBin({
    required this.bin,
    required this.brand,
    required this.subBrand,
    required this.countryCode,
    required this.countryName,
    required this.cardType,
    required this.bank,
    required this.linkedBankId,
  });

  factory CardBin.fromJson(Map<String, dynamic> json) {
    return CardBin(
      bin: json['bin'],
      brand: json['brand'],
      subBrand: json['sub_brand'] ?? '',
      countryCode: json['country_code'],
      countryName: json['country_name'],
      cardType: json['card_type'],
      bank: json['bank'],
      linkedBankId: json['linked_bank_id'],
    );
  }
}

class Bank {
  final int id;
  final String name;
  final String slug;
  final String code;
  final String longcode;
  final String? gateway;
  final bool payWithBank;
  final bool active;
  final bool isDeleted;
  final String country;
  final String currency;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;

  Bank({
    required this.id,
    required this.name,
    required this.slug,
    required this.code,
    required this.longcode,
    this.gateway,
    required this.payWithBank,
    required this.active,
    required this.isDeleted,
    required this.country,
    required this.currency,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      code: json['code'],
      longcode: json['longcode'] ?? '',
      gateway: json['gateway'],
      payWithBank: json['pay_with_bank'],
      active: json['active'],
      isDeleted: json['is_deleted'],
      country: json['country'],
      currency: json['currency'],
      type: json['type'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class Country {
  final int id;
  final String name;
  final String isoCode;
  final String defaultCurrencyCode;
  final Map<String, dynamic> integrationDefaults;
  final Map<String, dynamic> relationships;

  Country({
    required this.id,
    required this.name,
    required this.isoCode,
    required this.defaultCurrencyCode,
    required this.integrationDefaults,
    required this.relationships,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'],
      name: json['name'],
      isoCode: json['iso_code'],
      defaultCurrencyCode: json['default_currency_code'],
      integrationDefaults: json['integration_defaults'],
      relationships: json['relationships'],
    );
  }
}

class State {
  final String name;
  final String slug;
  final String abbreviation;

  State({
    required this.name,
    required this.slug,
    required this.abbreviation,
  });

  factory State.fromJson(Map<String, dynamic> json) {
    return State(
      name: json['name'],
      slug: json['slug'],
      abbreviation: json['abbreviation'],
    );
  }
}