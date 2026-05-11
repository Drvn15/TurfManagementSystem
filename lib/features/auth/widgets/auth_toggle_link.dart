import 'package:flutter/material.dart';

import '../../../core/theme/design_system.dart';

class AuthToggleLink extends StatelessWidget {
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
            color: DesignSystem.textSecondary,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            actionLabel,
            style: DesignSystem.bodyMedium.copyWith(
              color: DesignSystem.accentLime,
              fontWeight: DesignSystem.fontWeightSemiBold,
            ),
          ),
        ),
      ],
    );
  }
}
