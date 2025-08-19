class OpayTransaction {
  final String? transactionId;
  final String orderNr;
  final String websiteId;
  final int amount;
  final String currency;
  final String status;
  final String? redirectUrl;
  final DateTime? createdAt;
  final List<OpayPayment>? payments;

  OpayTransaction({
    this.transactionId,
    required this.orderNr,
    required this.websiteId,
    required this.amount,
    this.currency = 'EUR',
    required this.status,
    this.redirectUrl,
    this.createdAt,
    this.payments,
  });

  factory OpayTransaction.fromJson(Map<String, dynamic> json) {
    return OpayTransaction(
      transactionId: json['transaction_id'],
      orderNr: json['order_nr'],
      websiteId: json['website_id'],
      amount: json['amount'],
      currency: json['currency'] ?? 'EUR',
      status: json['status']?.toString() ?? '0',
      redirectUrl: json['redirect_url'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      payments: json['payments'] != null 
        ? (json['payments'] as List).map((p) => OpayPayment.fromJson(p)).toList()
        : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transaction_id': transactionId,
      'order_nr': orderNr,
      'website_id': websiteId,
      'amount': amount,
      'currency': currency,
      'status': status,
      'redirect_url': redirectUrl,
      'created_at': createdAt?.toIso8601String(),
      'payments': payments?.map((p) => p.toJson()).toList(),
    };
  }
}

class OpayPayment {
  final String? pToken;
  final int? pAmount;
  final String? pCurrency;
  final String? pChannel;
  final String? pBank;
  final String? pLocalDateTime;
  final String? pGmtDateTime;
  final DateTime? paidAt;
  final String? cFullName;
  final String? cAccountNr;
  final String? cEmail;
  final String? cMobileNr;

  OpayPayment({
    this.pToken,
    this.pAmount,
    this.pCurrency,
    this.pChannel,
    this.pBank,
    this.pLocalDateTime,
    this.pGmtDateTime,
    this.paidAt,
    this.cFullName,
    this.cAccountNr,
    this.cEmail,
    this.cMobileNr,
  });

  factory OpayPayment.fromJson(Map<String, dynamic> json) {
    return OpayPayment(
      pToken: json['p_token'],
      pAmount: json['p_amount'],
      pCurrency: json['p_currency'],
      pChannel: json['p_channel'],
      pBank: json['p_bank'],
      pLocalDateTime: json['p_local_date_time'],
      pGmtDateTime: json['p_gmt_date_time'],
      paidAt: json['paid_at'] != null ? DateTime.parse(json['paid_at']) : null,
      cFullName: json['c_full_name'],
      cAccountNr: json['c_account_nr'],
      cEmail: json['c_email'],
      cMobileNr: json['c_mobile_nr'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'p_token': pToken,
      'p_amount': pAmount,
      'p_currency': pCurrency,
      'p_channel': pChannel,
      'p_bank': pBank,
      'p_local_date_time': pLocalDateTime,
      'p_gmt_date_time': pGmtDateTime,
      'paid_at': paidAt?.toIso8601String(),
      'c_full_name': cFullName,
      'c_account_nr': cAccountNr,
      'c_email': cEmail,
      'c_mobile_nr': cMobileNr,
    };
  }
}

class OpayChannel {
  final String channelName;
  final String title;
  final Map<String, String> logoUrls;

  OpayChannel({
    required this.channelName,
    required this.title,
    required this.logoUrls,
  });

  factory OpayChannel.fromJson(Map<String, dynamic> json) {
    return OpayChannel(
      channelName: json['channel_name'],
      title: json['title'],
      logoUrls: Map<String, String>.from(json['logo_urls'] ?? {}),
    );
  }
}

class OpayChannelGroup {
  final String groupTitle;
  final Map<String, OpayChannel> channels;

  OpayChannelGroup({
    required this.groupTitle,
    required this.channels,
  });

  factory OpayChannelGroup.fromJson(Map<String, dynamic> json) {
    final channelsData = json['channels'] as Map<String, dynamic>? ?? {};
    final channels = <String, OpayChannel>{};
    
    channelsData.forEach((key, value) {
      channels[key] = OpayChannel.fromJson(value);
    });

    return OpayChannelGroup(
      groupTitle: json['group_title'],
      channels: channels,
    );
  }
}

class OpayCreateTransactionRequest {
  final String orderNr;
  final String websiteId;
  final String redirectUrl;
  final String webServiceUrl;
  final String standard;
  final int amount;
  final String currency;
  final String? backUrl;
  final String? language;
  final String? showChannels;
  final String? hideChannels;
  final String? country;
  final String? paymentDescription;
  final int? timeLimit;
  final String? test;
  final String? cEmail;
  final String? cMobileNr;
  final String? passThroughChannelName;
  final int? passThroughOnly;
  final int? redirectOnSuccess;
  final String? metadata;
  final String? customParameters;

  OpayCreateTransactionRequest({
    required this.orderNr,
    required this.websiteId,
    required this.redirectUrl,
    required this.webServiceUrl,
    required this.standard,
    required this.amount,
    this.currency = 'EUR',
    this.backUrl,
    this.language = 'ENG',
    this.showChannels,
    this.hideChannels,
    this.country = 'LT',
    this.paymentDescription,
    this.timeLimit = 129600,
    this.test,
    this.cEmail,
    this.cMobileNr,
    this.passThroughChannelName,
    this.passThroughOnly = 0,
    this.redirectOnSuccess = 1,
    this.metadata,
    this.customParameters,
  });

  Map<String, dynamic> toJson() {
    return {
      'order_nr': orderNr,
      'website_id': websiteId,
      'redirect_url': redirectUrl,
      'web_service_url': webServiceUrl,
      'standard': standard,
      'amount': amount,
      'currency': currency,
      if (backUrl != null) 'back_url': backUrl,
      if (language != null) 'language': language,
      if (showChannels != null) 'show_channels': showChannels,
      if (hideChannels != null) 'hide_channels': hideChannels,
      if (country != null) 'country': country,
      if (paymentDescription != null) 'payment_description': paymentDescription,
      if (timeLimit != null) 'time_limit': timeLimit,
      if (test != null) 'test': test,
      if (cEmail != null) 'c_email': cEmail,
      if (cMobileNr != null) 'c_mobile_nr': cMobileNr,
      if (passThroughChannelName != null) 'pass_through_channel_name': passThroughChannelName,
      if (passThroughOnly != null) 'pass_through_only': passThroughOnly,
      if (redirectOnSuccess != null) 'redirect_on_success': redirectOnSuccess,
      if (metadata != null) 'metadata': metadata,
      if (customParameters != null) 'custom_parameters': customParameters,
    };
  }
}

class OpayRecurringPaymentRequest {
  final String websiteId;
  final String userId;
  final String currency;
  final int amount;
  final String recurringPaymentToken;
  final String paymentDescription;
  final String? customParameters;

  OpayRecurringPaymentRequest({
    required this.websiteId,
    required this.userId,
    this.currency = 'EUR',
    required this.amount,
    required this.recurringPaymentToken,
    required this.paymentDescription,
    this.customParameters,
  });

  Map<String, dynamic> toJson() {
    return {
      'website_id': websiteId,
      'user_id': userId,
      'currency': currency,
      'amount': amount,
      'recurring_payment_token': recurringPaymentToken,
      'payment_description': paymentDescription,
      if (customParameters != null) 'custom_parameters': customParameters,
    };
  }
}

class OpayRefundRequest {
  final String uniquePaymentToken;
  final int amount;
  final String currency;
  final String websiteId;

  OpayRefundRequest({
    required this.uniquePaymentToken,
    required this.amount,
    this.currency = 'EUR',
    required this.websiteId,
  });

  Map<String, dynamic> toJson() {
    return {
      'unique_payment_token': uniquePaymentToken,
      'amount': amount,
      'currency': currency,
      'website_id': websiteId,
    };
  }
}

class OpayRefund {
  final String uniqueRefundToken;
  final String? status;
  final String? message;

  OpayRefund({
    required this.uniqueRefundToken,
    this.status,
    this.message,
  });

  factory OpayRefund.fromJson(Map<String, dynamic> json) {
    return OpayRefund(
      uniqueRefundToken: json['unique_refund_token'],
      status: json['status'],
      message: json['message'],
    );
  }
}

enum OpayPaymentStatus {
  timeLimitExceeded(0),
  completed(1),
  created(2),
  cancelled(3),
  notFinished(5);

  const OpayPaymentStatus(this.value);
  final int value;

  static OpayPaymentStatus fromValue(int value) {
    return OpayPaymentStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => OpayPaymentStatus.notFinished,
    );
  }
}

enum OpayPaymentChannel {
  banklink,
  pis,
  card,
  banktransfer,
  cash,
  financing;

  String get value => name;
}

enum OpayLanguage {
  eng('ENG'),
  lit('LIT'),
  lav('LAV'),
  est('EST'),
  rus('RUS');

  const OpayLanguage(this.value);
  final String value;
}