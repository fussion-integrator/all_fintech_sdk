/// Base exception for fintech operations.
class FintechException implements Exception {
  final String message;
  final int? statusCode;
  final String? errorCode;
  final dynamic data;

  const FintechException({
    required this.message,
    this.statusCode,
    this.errorCode,
    this.data,
  });

  @override
  String toString() => 'FintechException: $message';
}

/// Paystack-specific exception.
class PaystackException extends FintechException {
  const PaystackException({
    required super.message,
    super.statusCode,
    super.errorCode,
    super.data,
  });
}

class NetworkException extends FintechException {
  const NetworkException({
    required super.message,
    super.statusCode,
    super.errorCode,
    super.data,
  });
}

class ValidationException extends FintechException {
  const ValidationException({
    required super.message,
    super.statusCode,
    super.errorCode,
    super.data,
  });
}