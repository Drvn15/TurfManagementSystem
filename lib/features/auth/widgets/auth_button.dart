import 'package:flutter/material.dart';

import '../../../core/theme/design_system.dart';

class AuthButton extends StatelessWidget {
  static const Color _buttonColor = Colors.black;
  static const Color _textColor = Colors.white;

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const AuthButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null && !isLoading;

    return AnimatedOpacity(
      duration: DesignSystem.animationFast,
      opacity: isEnabled ? 1 : 0.5,
      child: SizedBox(
        width: double.infinity,
        height: DesignSystem.spacing56,
        child: ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: _buttonColor,
            foregroundColor: _textColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DesignSystem.radiusLarge),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _textColor,
                    ),
                  ),
                )
              : Text(
                  label,
                  style: DesignSystem.button.copyWith(
                    color: _textColor,
                  ),
                ),
        ),
      ),
    );
  }
}
