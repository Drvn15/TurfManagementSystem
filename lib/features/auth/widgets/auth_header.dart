import 'package:flutter/material.dart';

import '../../../core/theme/design_system.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.showLogo = false,
    this.centerAligned = false,
  });

  final String title;
  final String subtitle;
  final bool showLogo;
  final bool centerAligned;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          centerAligned ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        if (showLogo)
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              gradient: DesignSystem.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: DesignSystem.glowShadow,
            ),
            child: const Icon(
              Icons.sports_soccer_rounded,
              size: 34,
              color: DesignSystem.backgroundBase,
            ),
          ),
        if (showLogo) const SizedBox(height: DesignSystem.spacing24),
        Text(
          title,
          textAlign: centerAligned ? TextAlign.center : TextAlign.start,
          style: DesignSystem.displayMedium,
        ),
        const SizedBox(height: DesignSystem.spacing8),
        Text(
          subtitle,
          textAlign: centerAligned ? TextAlign.center : TextAlign.start,
          style: DesignSystem.bodyMedium,
        ),
      ],
    );
  }
}
