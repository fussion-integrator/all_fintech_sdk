/// Core exception classes for the All Fintech SDK.
library;

/// Base exception class for all fintech-related errors.
class FintechException implements Exception {
  /// The error message.
  final String message;
  
  /// Optional error code.
  final String? code;
  
  /// Additional error details.
  final Map<String, dynamic>? details;

  /// Creates a new fintech exception.
  const FintechException(
    this.message, {
    this.code,
    this.details,
  });

  @override
  String toString() => 'FintechException: $message${code != null ? ' ($code)' : ''}';
}

/// Exception thrown when a circuit breaker is open.
class CircuitBreakerOpenException extends FintechException {
  /// Creates a circuit breaker open exception.
  const CircuitBreakerOpenException(String message) : super(message, code: 'CIRCUIT_BREAKER_OPEN');
}

/// Exception thrown when authentication fails.
class AuthenticationException extends FintechException {
  /// Creates an authentication exception.
  const AuthenticationException(String message) : super(message, code: 'AUTHENTICATION_FAILED');
}

/// Exception thrown when a network request fails.
class NetworkException extends FintechException {
  /// Creates a network exception.
  const NetworkException(String message) : super(message, code: 'NETWORK_ERROR');
}

/// Exception thrown when validation fails.
class ValidationException extends FintechException {
  /// Creates a validation exception.
  const ValidationException(String message) : super(message, code: 'VALIDATION_ERROR');
}