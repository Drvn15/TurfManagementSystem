import 'package:flutter/material.dart';

import '../../../core/theme/design_system.dart';

class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton({
    super.key,
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: DesignSystem.spacing56,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20, color: iconColor),
        label: Text(
          label,
          style: DesignSystem.bodyMedium.copyWith(
            color: DesignSystem.textPrimary,
            fontWeight: DesignSystem.fontWeightSemiBold,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: DesignSystem.surfaceGlass,
          side: const BorderSide(color: DesignSystem.glassBorder),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignSystem.radiusLarge),
          ),
        ),
      ),
    );
  }
}
