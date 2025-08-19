class CustomerRequest {
  final String email;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final Map<String, dynamic>? metadata;

  const CustomerRequest({
    required this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'email': email,
    };

    if (firstName != null) json['first_name'] = firstName;
    if (lastName != null) json['last_name'] = lastName;
    if (phone != null) json['phone'] = phone;
    if (metadata != null) json['metadata'] = metadata;

    return json;
  }
}

class DedicatedAccountRequest {
  final String customer;
  final String? preferredBank;
  final String? subaccount;
  final String? splitCode;
  final String? firstName;
  final String? lastName;
  final String? phone;

  const DedicatedAccountRequest({
    required this.customer,
    this.preferredBank,
    this.subaccount,
    this.splitCode,
    this.firstName,
    this.lastName,
    this.phone,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'customer': customer,
    };

    if (preferredBank != null) json['preferred_bank'] = preferredBank;
    if (subaccount != null) json['subaccount'] = subaccount;
    if (splitCode != null) json['split_code'] = splitCode;
    if (firstName != null) json['first_name'] = firstName;
    if (lastName != null) json['last_name'] = lastName;
    if (phone != null) json['phone'] = phone;

    return json;
  }
}