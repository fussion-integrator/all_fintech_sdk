/// Google Pay button widget with Material Design 3 styling.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants.dart';
import '../../models/google_pay_models.dart';

/// Google Pay button widget following Material Design 3 guidelines.
class GooglePayButton extends StatefulWidget {
  /// Payment request configuration.
  final GooglePayRequest paymentRequest;
  
  /// Button configuration.
  final GooglePayButtonConfig buttonConfig;
  
  /// Callback when payment succeeds.
  final void Function(GooglePayToken token) onPaymentSuccess;
  
  /// Callback when payment fails.
  final void Function(GooglePayException error) onPaymentError;
  
  /// Callback when payment is cancelled.
  final VoidCallback? onPaymentCancelled;
  
  /// Whether the button is enabled.
  final bool enabled;
  
  /// Loading state.
  final bool loading;

  const GooglePayButton({
    super.key,
    required this.paymentRequest,
    required this.onPaymentSuccess,
    required this.onPaymentError,
    this.buttonConfig = const GooglePayButtonConfig(),
    this.onPaymentCancelled,
    this.enabled = true,
    this.loading = false,
  });

  @override
  State<GooglePayButton> createState() => _GooglePayButtonState();
}

class _GooglePayButtonState extends State<GooglePayButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: UIConstants.animationDurationMs),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: _buildButton(context, colorScheme),
        );
      },
    );
  }

  Widget _buildButton(BuildContext context, ColorScheme colorScheme) {
    final isEnabled = widget.enabled && !widget.loading;
    
    return SizedBox(
      width: widget.buttonConfig.width,
      height: widget.buttonConfig.height ?? 48.0,
      child: Material(
        color: _getButtonColor(colorScheme),
        borderRadius: BorderRadius.circular(widget.buttonConfig.cornerRadius),
        elevation: isEnabled ? 2.0 : 0.0,
        shadowColor: colorScheme.shadow.withOpacity(0.2),
        child: InkWell(
          onTap: isEnabled ? _handlePayment : null,
          onTapDown: isEnabled ? _handleTapDown : null,
          onTapUp: isEnabled ? _handleTapUp : null,
          onTapCancel: isEnabled ? _handleTapCancel : null,
          borderRadius: BorderRadius.circular(widget.buttonConfig.cornerRadius),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.buttonConfig.cornerRadius),
              border: Border.all(
                color: _getBorderColor(colorScheme),
                width: 1.0,
              ),
            ),
            child: _buildButtonContent(context, colorScheme),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonContent(BuildContext context, ColorScheme colorScheme) {
    if (widget.loading) {
      return _buildLoadingContent(colorScheme);
    }
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildGooglePayLogo(),
        const SizedBox(width: 8.0),
        _buildButtonText(context, colorScheme),
      ],
    );
  }

  Widget _buildLoadingContent(ColorScheme colorScheme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 16.0,
          height: 16.0,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation<Color>(
              _getTextColor(colorScheme),
            ),
          ),
        ),
        const SizedBox(width: 8.0),
        Text(
          'Processing...',
          style: TextStyle(
            color: _getTextColor(colorScheme),
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildGooglePayLogo() {
    return Container(
      width: 24.0,
      height: 24.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: Colors.white,
      ),
      child: Center(
        child: Text(
          'G',
          style: TextStyle(
            color: _getGoogleLogoColor(),
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Product Sans',
          ),
        ),
      ),
    );
  }

  Widget _buildButtonText(BuildContext context, ColorScheme colorScheme) {
    final buttonText = _getButtonText();
    
    return Text(
      buttonText,
      style: TextStyle(
        color: _getTextColor(colorScheme),
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
    );
  }

  String _getButtonText() {
    switch (widget.buttonConfig.type) {
      case GooglePayButtonType.book:
        return 'Book with Google Pay';
      case GooglePayButtonType.buy:
        return 'Buy with Google Pay';
      case GooglePayButtonType.checkout:
        return 'Checkout with Google Pay';
      case GooglePayButtonType.donate:
        return 'Donate with Google Pay';
      case GooglePayButtonType.order:
        return 'Order with Google Pay';
      case GooglePayButtonType.pay:
        return 'Pay with Google Pay';
      case GooglePayButtonType.plain:
        return 'Google Pay';
      case GooglePayButtonType.subscribe:
        return 'Subscribe with Google Pay';
    }
  }

  Color _getButtonColor(ColorScheme colorScheme) {
    if (!widget.enabled) {
      return colorScheme.surfaceVariant;
    }
    
    switch (widget.buttonConfig.theme) {
      case GooglePayButtonTheme.dark:
        return const Color(0xFF000000);
      case GooglePayButtonTheme.light:
        return const Color(0xFFFFFFFF);
    }
  }

  Color _getBorderColor(ColorScheme colorScheme) {
    if (!widget.enabled) {
      return colorScheme.outline.withOpacity(0.5);
    }
    
    switch (widget.buttonConfig.theme) {
      case GooglePayButtonTheme.dark:
        return const Color(0xFF000000);
      case GooglePayButtonTheme.light:
        return const Color(0xFFDDDDDD);
    }
  }

  Color _getTextColor(ColorScheme colorScheme) {
    if (!widget.enabled) {
      return colorScheme.onSurfaceVariant;
    }
    
    switch (widget.buttonConfig.theme) {
      case GooglePayButtonTheme.dark:
        return const Color(0xFFFFFFFF);
      case GooglePayButtonTheme.light:
        return const Color(0xFF3C4043);
    }
  }

  Color _getGoogleLogoColor() {
    return const Color(0xFF4285F4); // Google Blue
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _animationController.forward();
    HapticFeedback.lightImpact();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  Future<void> _handlePayment() async {
    try {
      HapticFeedback.mediumImpact();
      
      // This would integrate with the actual Google Pay API
      // For now, we'll simulate the payment flow
      await _simulatePaymentFlow();
      
    } catch (e) {
      widget.onPaymentError(
        GooglePayException(
          'Payment failed: ${e.toString()}',
          code: 'PAYMENT_FAILED',
        ),
      );
    }
  }

  Future<void> _simulatePaymentFlow() async {
    // Simulate payment processing delay
    await Future.delayed(const Duration(seconds: 2));
    
    // Simulate successful payment
    final token = GooglePayToken(
      token: 'simulated_token_${DateTime.now().millisecondsSinceEpoch}',
      tokenType: 'PAYMENT_GATEWAY',
      cardNetwork: 'VISA',
      cardLast4: '1234',
    );
    
    widget.onPaymentSuccess(token);
  }
}