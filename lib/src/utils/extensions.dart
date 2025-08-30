/// Extension utilities for the All Fintech SDK.
library;

/// String extensions.
extension StringExtensions on String {
  /// Capitalizes the first letter.
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}