/// Apple Pay payment sheet with comprehensive UI.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants.dart';
import '../../models/apple_pay_models.dart';
import 'apple_pay_button.dart';

/// Apple Pay payment sheet modal.
class ApplePaySheet extends StatefulWidget {
  /// Payment request configuration.
  final ApplePayRequest paymentRequest;
  
  /// Button configuration.
  final ApplePayButtonConfig buttonConfig;
  
  /// Callback when payment succeeds.
  final void Function(ApplePayToken token) onPaymentSuccess;
  
  /// Callback when payment fails.
  final void Function(ApplePayException error) onPaymentError;
  
  /// Callback when sheet is dismissed.
  final VoidCallback? onDismissed;
  
  /// Show payment details.
  final bool showPaymentDetails;
  
  /// Custom title.
  final String? title;
  
  /// Custom description.
  final String? description;

  const ApplePaySheet({
    super.key,
    required this.paymentRequest,
    required this.onPaymentSuccess,
    required this.onPaymentError,
    this.buttonConfig = const ApplePayButtonConfig(),
    this.onDismissed,
    this.showPaymentDetails = true,
    this.title,
    this.description,
  });

  @override
  State<ApplePaySheet> createState() => _ApplePaySheetState();
}

class _ApplePaySheetState extends State<ApplePaySheet>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  
  bool _isLoading = false;
  ApplePayAvailability? _availability;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkApplePayAvailability();
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));
    
    _slideController.forward();
    _fadeController.forward();
  }

  Future<void> _checkApplePayAvailability() async {
    // This would integrate with the data service
    // For now, simulate availability check
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (mounted) {
      setState(() {
        _availability = const ApplePayAvailability(
          isAvailable: true,
          canMakePayments: true,
          canMakePaymentsUsingNetworks: true,
        );
      });
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Container(
          color: Colors.black.withOpacity(0.5 * _fadeAnimation.value),
          child: SlideTransition(
            position: _slideAnimation,
            child: _buildSheet(context),
          ),
        );
      },
    );
  }

  Widget _buildSheet(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: mediaQuery.size.height * 0.8,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(16.0),
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.1),
              blurRadius: 10.0,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHandle(theme),
            _buildHeader(context, theme),
            if (widget.showPaymentDetails) _buildPaymentDetails(context, theme),
            _buildContent(context, theme),
            _buildFooter(context, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHandle(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(top: 8.0),
      width: 32.0,
      height: 4.0,
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurfaceVariant.withOpacity(0.4),
        borderRadius: BorderRadius.circular(2.0),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title ?? 'Pay with Apple Pay',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (widget.description != null) ...[
                  const SizedBox(height: 4.0),
                  Text(
                    widget.description!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            onPressed: _handleDismiss,
            icon: Icon(
              Icons.close,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentDetails(BuildContext context, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          // Show individual items if provided
          if (widget.paymentRequest.items != null) ...[
            ...widget.paymentRequest.items!.map((item) => 
              _buildDetailRow(item.label, _formatCurrency(item.amount, widget.paymentRequest.currencyCode), theme)
            ),
            const Divider(),
          ],
          _buildDetailRow(
            'Total',
            _formatCurrency(widget.paymentRequest.amount, widget.paymentRequest.currencyCode),
            theme,
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, ThemeData theme, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, ThemeData theme) {
    if (_availability == null) {
      return _buildLoadingState(theme);
    }
    
    if (!_availability!.isAvailable) {
      return _buildUnavailableState(theme);
    }
    
    return _buildAvailableState(context, theme);
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          CircularProgressIndicator(
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 16.0),
          Text(
            'Checking Apple Pay availability...',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnavailableState(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 48.0,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 16.0),
          Text(
            'Apple Pay Unavailable',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            _availability?.reason ?? 'Apple Pay is not available on this device.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableState(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          _buildSecurityInfo(theme),
          const SizedBox(height: 24.0),
          ApplePayButton(
            paymentRequest: widget.paymentRequest,
            buttonConfig: widget.buttonConfig.copyWith(
              width: double.infinity,
            ),
            onPaymentSuccess: _handlePaymentSuccess,
            onPaymentError: _handlePaymentError,
            loading: _isLoading,
            enabled: !_isLoading,
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityInfo(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Icon(
            Icons.security,
            size: 20.0,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              'Your payment is secured with Touch ID, Face ID, or passcode.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.apple,
            size: 16.0,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4.0),
          Text(
            'Powered by Apple Pay',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double amount, String currencyCode) {
    // Simple currency formatting - in production, use intl package
    switch (currencyCode.toUpperCase()) {
      case 'USD':
        return '\$${amount.toStringAsFixed(2)}';
      case 'EUR':
        return '€${amount.toStringAsFixed(2)}';
      case 'GBP':
        return '£${amount.toStringAsFixed(2)}';
      case 'CAD':
        return 'C\$${amount.toStringAsFixed(2)}';
      case 'AUD':
        return 'A\$${amount.toStringAsFixed(2)}';
      case 'JPY':
        return '¥${amount.toStringAsFixed(0)}';
      default:
        return '$currencyCode ${amount.toStringAsFixed(2)}';
    }
  }

  void _handlePaymentSuccess(ApplePayToken token) {
    setState(() => _isLoading = false);
    widget.onPaymentSuccess(token);
    _handleDismiss();
  }

  void _handlePaymentError(ApplePayException error) {
    setState(() => _isLoading = false);
    widget.onPaymentError(error);
  }

  Future<void> _handleDismiss() async {
    await _fadeController.reverse();
    await _slideController.reverse();
    
    if (mounted) {
      Navigator.of(context).pop();
      widget.onDismissed?.call();
    }
  }
}

/// Extension to add copyWith method to ApplePayButtonConfig.
extension ApplePayButtonConfigExtension on ApplePayButtonConfig {
  ApplePayButtonConfig copyWith({
    ApplePayButtonStyle? style,
    ApplePayButtonType? type,
    double? width,
    double? height,
    double? cornerRadius,
  }) {
    return ApplePayButtonConfig(
      style: style ?? this.style,
      type: type ?? this.type,
      width: width ?? this.width,
      height: height ?? this.height,
      cornerRadius: cornerRadius ?? this.cornerRadius,
    );
  }
}