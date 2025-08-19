// Monnify Authentication
class MonnifyAuthResponse {
  final String accessToken;
  final int expiresIn;

  MonnifyAuthResponse({
    required this.accessToken,
    required this.expiresIn,
  });

  factory MonnifyAuthResponse.fromJson(Map<String, dynamic> json) {
    return MonnifyAuthResponse(
      accessToken: json['accessToken'],
      expiresIn: json['expiresIn'],
    );
  }
}

// Monnify Transaction
class MonnifyTransaction {
  final String transactionReference;
  final String paymentReference;
  final String merchantName;
  final String apiKey;
  final List<String> enabledPaymentMethod;
  final String checkoutUrl;

  MonnifyTransaction({
    required this.transactionReference,
    required this.paymentReference,
    required this.merchantName,
    required this.apiKey,
    required this.enabledPaymentMethod,
    required this.checkoutUrl,
  });

  factory MonnifyTransaction.fromJson(Map<String, dynamic> json) {
    return MonnifyTransaction(
      transactionReference: json['transactionReference'],
      paymentReference: json['paymentReference'],
      merchantName: json['merchantName'],
      apiKey: json['apiKey'],
      enabledPaymentMethod: List<String>.from(json['enabledPaymentMethod']),
      checkoutUrl: json['checkoutUrl'],
    );
  }
}

// Monnify Transaction Request
class MonnifyTransactionRequest {
  final double amount;
  final String customerName;
  final String customerEmail;
  final String paymentReference;
  final String paymentDescription;
  final String currencyCode;
  final String contractCode;
  final String? redirectUrl;
  final List<String>? paymentMethods;
  final List<MonnifyIncomeSplitConfig>? incomeSplitConfig;
  final Map<String, dynamic>? metaData;

  MonnifyTransactionRequest({
    required this.amount,
    required this.customerName,
    required this.customerEmail,
    required this.paymentReference,
    required this.paymentDescription,
    required this.currencyCode,
    required this.contractCode,
    this.redirectUrl,
    this.paymentMethods,
    this.incomeSplitConfig,
    this.metaData,
  });

  Map<String, dynamic> toJson() => {
    'amount': amount,
    'customerName': customerName,
    'customerEmail': customerEmail,
    'paymentReference': paymentReference,
    'paymentDescription': paymentDescription,
    'currencyCode': currencyCode,
    'contractCode': contractCode,
    if (redirectUrl != null) 'redirectUrl': redirectUrl,
    if (paymentMethods != null) 'paymentMethods': paymentMethods,
    if (incomeSplitConfig != null) 'incomeSplitConfig': incomeSplitConfig?.map((e) => e.toJson()).toList(),
    if (metaData != null) 'metaData': metaData,
  };
}

// Monnify Income Split Config
class MonnifyIncomeSplitConfig {
  final String subAccountCode;
  final double? feePercentage;
  final double? splitPercentage;
  final double? splitAmount;
  final bool? feeBearer;

  MonnifyIncomeSplitConfig({
    required this.subAccountCode,
    this.feePercentage,
    this.splitPercentage,
    this.splitAmount,
    this.feeBearer,
  });

  Map<String, dynamic> toJson() => {
    'subAccountCode': subAccountCode,
    if (feePercentage != null) 'feePercentage': feePercentage,
    if (splitPercentage != null) 'splitPercentage': splitPercentage,
    if (splitAmount != null) 'splitAmount': splitAmount,
    if (feeBearer != null) 'feeBearer': feeBearer,
  };
}

// Monnify Reserved Account
class MonnifyReservedAccount {
  final String contractCode;
  final String accountReference;
  final String accountName;
  final String currencyCode;
  final String customerEmail;
  final String customerName;
  final List<MonnifyAccountDetail> accounts;
  final String collectionChannel;
  final String reservationReference;
  final String reservedAccountType;
  final String status;
  final String createdOn;

  MonnifyReservedAccount({
    required this.contractCode,
    required this.accountReference,
    required this.accountName,
    required this.currencyCode,
    required this.customerEmail,
    required this.customerName,
    required this.accounts,
    required this.collectionChannel,
    required this.reservationReference,
    required this.reservedAccountType,
    required this.status,
    required this.createdOn,
  });

  factory MonnifyReservedAccount.fromJson(Map<String, dynamic> json) {
    return MonnifyReservedAccount(
      contractCode: json['contractCode'],
      accountReference: json['accountReference'],
      accountName: json['accountName'],
      currencyCode: json['currencyCode'],
      customerEmail: json['customerEmail'],
      customerName: json['customerName'],
      accounts: (json['accounts'] as List).map((e) => MonnifyAccountDetail.fromJson(e)).toList(),
      collectionChannel: json['collectionChannel'],
      reservationReference: json['reservationReference'],
      reservedAccountType: json['reservedAccountType'],
      status: json['status'],
      createdOn: json['createdOn'],
    );
  }
}

// Monnify Account Detail
class MonnifyAccountDetail {
  final String bankCode;
  final String bankName;
  final String accountNumber;
  final String accountName;

  MonnifyAccountDetail({
    required this.bankCode,
    required this.bankName,
    required this.accountNumber,
    required this.accountName,
  });

  factory MonnifyAccountDetail.fromJson(Map<String, dynamic> json) {
    return MonnifyAccountDetail(
      bankCode: json['bankCode'],
      bankName: json['bankName'],
      accountNumber: json['accountNumber'],
      accountName: json['accountName'],
    );
  }
}

// Monnify Reserved Account Request
class MonnifyReservedAccountRequest {
  final String accountReference;
  final String accountName;
  final String currencyCode;
  final String contractCode;
  final String customerEmail;
  final String? customerName;
  final String? bvn;
  final String? nin;
  final bool getAllAvailableBanks;
  final List<MonnifyIncomeSplitConfig>? incomeSplitConfig;
  final bool? restrictPaymentSource;
  final Map<String, dynamic>? allowedPaymentSource;
  final Map<String, dynamic>? metaData;

  MonnifyReservedAccountRequest({
    required this.accountReference,
    required this.accountName,
    required this.currencyCode,
    required this.contractCode,
    required this.customerEmail,
    this.customerName,
    this.bvn,
    this.nin,
    this.getAllAvailableBanks = true,
    this.incomeSplitConfig,
    this.restrictPaymentSource,
    this.allowedPaymentSource,
    this.metaData,
  });

  Map<String, dynamic> toJson() => {
    'accountReference': accountReference,
    'accountName': accountName,
    'currencyCode': currencyCode,
    'contractCode': contractCode,
    'customerEmail': customerEmail,
    if (customerName != null) 'customerName': customerName,
    if (bvn != null) 'bvn': bvn,
    if (nin != null) 'nin': nin,
    'getAllAvailableBanks': getAllAvailableBanks,
    if (incomeSplitConfig != null) 'incomeSplitConfig': incomeSplitConfig?.map((e) => e.toJson()).toList(),
    if (restrictPaymentSource != null) 'restrictPaymentSource': restrictPaymentSource,
    if (allowedPaymentSource != null) 'allowedPaymentSource': allowedPaymentSource,
    if (metaData != null) 'metaData': metaData,
  };
}

// Monnify Transfer
class MonnifyTransfer {
  final double amount;
  final String reference;
  final String status;
  final String dateCreated;
  final double totalFee;
  final String? destinationAccountName;
  final String destinationBankName;
  final String destinationAccountNumber;
  final String destinationBankCode;

  MonnifyTransfer({
    required this.amount,
    required this.reference,
    required this.status,
    required this.dateCreated,
    required this.totalFee,
    this.destinationAccountName,
    required this.destinationBankName,
    required this.destinationAccountNumber,
    required this.destinationBankCode,
  });

  factory MonnifyTransfer.fromJson(Map<String, dynamic> json) {
    return MonnifyTransfer(
      amount: json['amount'].toDouble(),
      reference: json['reference'],
      status: json['status'],
      dateCreated: json['dateCreated'],
      totalFee: json['totalFee'].toDouble(),
      destinationAccountName: json['destinationAccountName'],
      destinationBankName: json['destinationBankName'],
      destinationAccountNumber: json['destinationAccountNumber'],
      destinationBankCode: json['destinationBankCode'],
    );
  }
}

// Monnify Transfer Request
class MonnifyTransferRequest {
  final double amount;
  final String reference;
  final String narration;
  final String destinationBankCode;
  final String destinationAccountNumber;
  final String currency;
  final String sourceAccountNumber;
  final bool? async;

  MonnifyTransferRequest({
    required this.amount,
    required this.reference,
    required this.narration,
    required this.destinationBankCode,
    required this.destinationAccountNumber,
    required this.currency,
    required this.sourceAccountNumber,
    this.async,
  });

  Map<String, dynamic> toJson() => {
    'amount': amount,
    'reference': reference,
    'narration': narration,
    'destinationBankCode': destinationBankCode,
    'destinationAccountNumber': destinationAccountNumber,
    'currency': currency,
    'sourceAccountNumber': sourceAccountNumber,
    if (async != null) 'async': async,
  };
}

// Monnify Bank
class MonnifyBank {
  final String name;
  final String code;
  final String? ussdTemplate;
  final String? baseUssdCode;
  final String? transferUssdTemplate;

  MonnifyBank({
    required this.name,
    required this.code,
    this.ussdTemplate,
    this.baseUssdCode,
    this.transferUssdTemplate,
  });

  factory MonnifyBank.fromJson(Map<String, dynamic> json) {
    return MonnifyBank(
      name: json['name'],
      code: json['code'],
      ussdTemplate: json['ussdTemplate'],
      baseUssdCode: json['baseUssdCode'],
      transferUssdTemplate: json['transferUssdTemplate'],
    );
  }
}

// Monnify Wallet Balance
class MonnifyWalletBalance {
  final double availableBalance;
  final double ledgerBalance;

  MonnifyWalletBalance({
    required this.availableBalance,
    required this.ledgerBalance,
  });

  factory MonnifyWalletBalance.fromJson(Map<String, dynamic> json) {
    return MonnifyWalletBalance(
      availableBalance: json['availableBalance'].toDouble(),
      ledgerBalance: json['ledgerBalance'].toDouble(),
    );
  }
}