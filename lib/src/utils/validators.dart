/// Validation utilities for the All Fintech SDK.
library;

/// Validation utilities.
class Validators {
  /// Validates an email address.
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}