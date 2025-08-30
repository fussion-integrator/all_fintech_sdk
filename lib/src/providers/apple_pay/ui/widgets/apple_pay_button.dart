/// Apple Pay button widget following Apple's design guidelines.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants.dart';
import '../../models/apple_pay_models.dart';

/// Apple Pay button widget following Apple's Human Interface Guidelines.
class ApplePayButton extends StatefulWidget {
  /// Payment request configuration.
  final ApplePayRequest paymentRequest;
  
  /// Button configuration.
  final ApplePayButtonConfig buttonConfig;
  
  /// Callback when payment succeeds.
  final void Function(ApplePayToken token) onPaymentSuccess;
  
  /// Callback when payment fails.
  final void Function(ApplePayException error) onPaymentError;
  
  /// Callback when payment is cancelled.
  final VoidCallback? onPaymentCancelled;
  
  /// Whether the button is enabled.
  final bool enabled;
  
  /// Loading state.
  final bool loading;

  const ApplePayButton({
    super.key,
    required this.paymentRequest,
    required this.onPaymentSuccess,
    required this.onPaymentError,
    this.buttonConfig = const ApplePayButtonConfig(),
    this.onPaymentCancelled,
    this.enabled = true,
    this.loading = false,
  });

  @override
  State<ApplePayButton> createState() => _ApplePayButtonState();
}

class _ApplePayButtonState extends State<ApplePayButton>
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
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: _buildButton(context),
        );
      },
    );
  }

  Widget _buildButton(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = widget.enabled && !widget.loading;
    
    return SizedBox(
      width: widget.buttonConfig.width,
      height: widget.buttonConfig.height ?? 48.0,
      child: Material(
        color: _getButtonColor(),
        borderRadius: BorderRadius.circular(widget.buttonConfig.cornerRadius),
        elevation: isEnabled ? 1.0 : 0.0,
        shadowColor: Colors.black.withOpacity(0.1),
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
              border: _getBorder(),
            ),
            child: _buildButtonContent(context, theme),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonContent(BuildContext context, ThemeData theme) {
    if (widget.loading) {
      return _buildLoadingContent();
    }
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildApplePayLogo(),
        const SizedBox(width: 8.0),
        _buildButtonText(context),
      ],
    );
  }

  Widget _buildLoadingContent() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 16.0,
          height: 16.0,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation<Color>(_getTextColor()),
          ),
        ),
        const SizedBox(width: 8.0),
        Text(
          'Processing...',
          style: TextStyle(
            color: _getTextColor(),
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildApplePayLogo() {
    return Container(
      width: 24.0,
      height: 24.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Icon(
        Icons.apple,
        color: _getTextColor(),
        size: 20.0,
      ),
    );
  }

  Widget _buildButtonText(BuildContext context) {
    final buttonText = _getButtonText();
    
    return Text(
      buttonText,
      style: TextStyle(
        color: _getTextColor(),
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
    );
  }

  String _getButtonText() {
    switch (widget.buttonConfig.type) {
      case ApplePayButtonType.plain:
        return 'Apple Pay';
      case ApplePayButtonType.buy:
        return 'Buy with Apple Pay';
      case ApplePayButtonType.setUp:
        return 'Set up Apple Pay';
      case ApplePayButtonType.inStore:
        return 'Apple Pay';
      case ApplePayButtonType.donate:
        return 'Donate with Apple Pay';
      case ApplePayButtonType.checkout:
        return 'Check out with Apple Pay';
      case ApplePayButtonType.book:
        return 'Book with Apple Pay';
      case ApplePayButtonType.subscribe:
        return 'Subscribe with Apple Pay';
      case ApplePayButtonType.reload:
        return 'Reload with Apple Pay';
      case ApplePayButtonType.addMoney:
        return 'Add Money';
      case ApplePayButtonType.topUp:
        return 'Top Up with Apple Pay';
      case ApplePayButtonType.order:
        return 'Order with Apple Pay';
      case ApplePayButtonType.rent:
        return 'Rent with Apple Pay';
      case ApplePayButtonType.support:
        return 'Support with Apple Pay';
      case ApplePayButtonType.contribute:
        return 'Contribute with Apple Pay';
      case ApplePayButtonType.tip:
        return 'Tip with Apple Pay';
    }
  }

  Color _getButtonColor() {
    if (!widget.enabled) {
      return Colors.grey.shade300;
    }
    
    switch (widget.buttonConfig.style) {
      case ApplePayButtonStyle.white:
        return Colors.white;
      case ApplePayButtonStyle.whiteOutline:
        return Colors.white;
      case ApplePayButtonStyle.black:
        return Colors.black;
      case ApplePayButtonStyle.automatic:
        return Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black;
    }
  }

  Border? _getBorder() {
    if (!widget.enabled) {
      return Border.all(color: Colors.grey.shade400, width: 1.0);
    }
    
    switch (widget.buttonConfig.style) {
      case ApplePayButtonStyle.whiteOutline:
        return Border.all(color: Colors.black, width: 1.0);
      default:
        return null;
    }
  }

  Color _getTextColor() {
    if (!widget.enabled) {
      return Colors.grey.shade600;
    }
    
    switch (widget.buttonConfig.style) {
      case ApplePayButtonStyle.white:
      case ApplePayButtonStyle.whiteOutline:
        return Colors.black;
      case ApplePayButtonStyle.black:
        return Colors.white;
      case ApplePayButtonStyle.automatic:
        return Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Colors.white;
    }
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
      
      // This would integrate with the actual Apple Pay API
      // For now, we'll simulate the payment flow
      await _simulatePaymentFlow();
      
    } catch (e) {
      widget.onPaymentError(
        ApplePayException(
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
    final token = ApplePayToken(
      paymentData: 'simulated_payment_data_${DateTime.now().millisecondsSinceEpoch}',
      transactionIdentifier: 'txn_${DateTime.now().millisecondsSinceEpoch}',
      paymentMethod: const ApplePayPaymentMethod(
        displayName: 'Visa •••• 1234',
        network: ApplePayNetwork.visa,
        type: ApplePayPaymentType.credit,
      ),
    );
    
    widget.onPaymentSuccess(token);
  }
}