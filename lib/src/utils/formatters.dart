/// Formatting utilities for the All Fintech SDK.
library;

/// Formatting utilities.
class Formatters {
  /// Formats currency amount.
  static String formatCurrency(double amount, String currency) {
    return '$currency ${amount.toStringAsFixed(2)}';
  }
}