enum ErrorCategory {
  network,
  authentication,
  validation,
  rateLimit,
  server,
  unknown,
}

enum ErrorSeverity {
  low,
  medium,
  high,
  critical,
}

class EnhancedException implements Exception {
  final String message;
  final ErrorCategory category;
  final ErrorSeverity severity;
  final int? statusCode;
  final String? errorCode;
  final Map<String, dynamic>? details;
  final DateTime timestamp;
  final bool isRetryable;

  EnhancedException({
    required this.message,
    required this.category,
    this.severity = ErrorSeverity.medium,
    this.statusCode,
    this.errorCode,
    this.details,
    DateTime? timestamp,
    bool? isRetryable,
  }) : timestamp = timestamp ?? DateTime.now(),
       isRetryable = isRetryable ?? _determineRetryable(category, statusCode);

  static bool _determineRetryable(ErrorCategory category, int? statusCode) {
    if (category == ErrorCategory.network) return true;
    if (statusCode != null) {
      return statusCode >= 500 || statusCode == 429 || statusCode == 408;
    }
    return false;
  }

  factory EnhancedException.network(String message, {int? statusCode}) {
    return EnhancedException(
      message: message,
      category: ErrorCategory.network,
      severity: ErrorSeverity.high,
      statusCode: statusCode,
      isRetryable: true,
    );
  }

  factory EnhancedException.authentication(String message, {String? errorCode}) {
    return EnhancedException(
      message: message,
      category: ErrorCategory.authentication,
      severity: ErrorSeverity.critical,
      errorCode: errorCode,
      isRetryable: false,
    );
  }

  factory EnhancedException.validation(String message, {Map<String, dynamic>? details}) {
    return EnhancedException(
      message: message,
      category: ErrorCategory.validation,
      severity: ErrorSeverity.medium,
      details: details,
      isRetryable: false,
    );
  }

  factory EnhancedException.rateLimit(String message, {int? retryAfter}) {
    return EnhancedException(
      message: message,
      category: ErrorCategory.rateLimit,
      severity: ErrorSeverity.medium,
      statusCode: 429,
      details: retryAfter != null ? {'retry_after': retryAfter} : null,
      isRetryable: true,
    );
  }

  factory EnhancedException.server(String message, {int? statusCode, String? errorCode}) {
    return EnhancedException(
      message: message,
      category: ErrorCategory.server,
      severity: ErrorSeverity.high,
      statusCode: statusCode,
      errorCode: errorCode,
      isRetryable: true,
    );
  }

  @override
  String toString() {
    return 'EnhancedException: $message (Category: $category, Severity: $severity)';
  }
}

class RetryPolicy {
  final int maxRetries;
  final Duration initialDelay;
  final double backoffMultiplier;
  final Duration maxDelay;

  const RetryPolicy({
    this.maxRetries = 3,
    this.initialDelay = const Duration(seconds: 1),
    this.backoffMultiplier = 2.0,
    this.maxDelay = const Duration(seconds: 30),
  });

  Duration getDelay(int attempt) {
    final delay = Duration(
      milliseconds: (initialDelay.inMilliseconds * 
        (backoffMultiplier * attempt)).round(),
    );
    return delay > maxDelay ? maxDelay : delay;
  }
}

class CircuitBreaker {
  final int failureThreshold;
  final Duration timeout;
  final Duration resetTimeout;

  int _failureCount = 0;
  DateTime? _lastFailureTime;
  bool _isOpen = false;

  CircuitBreaker({
    this.failureThreshold = 5,
    this.timeout = const Duration(seconds: 60),
    this.resetTimeout = const Duration(seconds: 30),
  });

  bool get isOpen => _isOpen;
  bool get isClosed => !_isOpen;

  Future<T> execute<T>(Future<T> Function() operation) async {
    if (_isOpen) {
      if (_shouldAttemptReset()) {
        _isOpen = false;
        _failureCount = 0;
      } else {
        throw EnhancedException(
          message: 'Circuit breaker is open',
          category: ErrorCategory.server,
          severity: ErrorSeverity.high,
          isRetryable: false,
        );
      }
    }

    try {
      final result = await operation();
      _onSuccess();
      return result;
    } catch (e) {
      _onFailure();
      rethrow;
    }
  }

  void _onSuccess() {
    _failureCount = 0;
    _lastFailureTime = null;
  }

  void _onFailure() {
    _failureCount++;
    _lastFailureTime = DateTime.now();
    
    if (_failureCount >= failureThreshold) {
      _isOpen = true;
    }
  }

  bool _shouldAttemptReset() {
    if (_lastFailureTime == null) return false;
    return DateTime.now().difference(_lastFailureTime!) > resetTimeout;
  }

  void reset() {
    _failureCount = 0;
    _lastFailureTime = null;
    _isOpen = false;
  }
}