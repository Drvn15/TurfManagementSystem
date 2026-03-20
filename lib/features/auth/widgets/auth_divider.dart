import 'package:flutter/material.dart';

import '../../../core/theme/design_system.dart';

class AuthDivider extends StatelessWidget {
  static const Color _border = Color(0xFFE3E3E3);
  static const Color _textLight = Color(0xFF8E8E8E);

  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: _border,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacing16),
          child: Text(
            'OR',
            style: DesignSystem.bodyMedium.copyWith(
              color: _textLight,
              fontWeight: DesignSystem.fontWeightMedium,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: _border,
          ),
        ),
      ],
    );
  }
}
