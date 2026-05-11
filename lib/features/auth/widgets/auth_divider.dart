import 'package:flutter/material.dart';

import '../../../core/theme/design_system.dart';

class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: DesignSystem.glassBorder,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacing16),
          child: Text(
            'OR',
            style: DesignSystem.bodyMedium.copyWith(
              color: DesignSystem.textMuted,
              fontWeight: DesignSystem.fontWeightMedium,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: DesignSystem.glassBorder,
          ),
        ),
      ],
    );
  }
}
