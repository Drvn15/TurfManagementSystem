import 'package:flutter/material.dart';

import '../../../core/theme/design_system.dart';

class SocialLoginButton extends StatelessWidget {
  static const Color _surface = Colors.white;
  static const Color _border = Color(0xFFE5E5E5);
  static const Color _textPrimary = Colors.black;

  final String label;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onPressed;

  const SocialLoginButton({
    super.key,
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: DesignSystem.spacing56,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 22,
          color: iconColor,
        ),
        label: Text(
          label,
          style: DesignSystem.button.copyWith(
            color: _textPrimary,
            fontWeight: DesignSystem.fontWeightMedium,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: _surface,
          side: const BorderSide(color: _border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignSystem.radiusLarge),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
