import 'package:flutter/material.dart';

import '../../../core/theme/design_system.dart';

class AuthToggleLink extends StatelessWidget {
  static const Color _textSecondary = Color(0xFF5A5A5A);
  static const Color _accent = Colors.black;

  final String prompt;
  final String actionLabel;
  final VoidCallback onTap;

  const AuthToggleLink({
    super.key,
    required this.prompt,
    required this.actionLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          prompt,
          style: DesignSystem.bodyMedium.copyWith(
            color: _textSecondary,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            actionLabel,
            style: DesignSystem.bodyMedium.copyWith(
              color: _accent,
              fontWeight: DesignSystem.fontWeightSemiBold,
            ),
          ),
        ),
      ],
    );
  }
}
