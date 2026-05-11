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
    final palette = DesignSystem.paletteOf(context);
    return Column(
      crossAxisAlignment:
          centerAligned ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        if (showLogo)
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              gradient: palette.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: DesignSystem.glowShadowFor(context),
            ),
            child: Icon(
              Icons.sports_soccer_rounded,
              size: 34,
              color: DesignSystem.isDark(context)
                  ? palette.backgroundBase
                  : DesignSystem.textWhite,
            ),
          ),
        if (showLogo) const SizedBox(height: DesignSystem.spacing24),
        Text(
          title,
          textAlign: centerAligned ? TextAlign.center : TextAlign.start,
          style: DesignSystem.displayMedium.copyWith(color: palette.textPrimary),
        ),
        const SizedBox(height: DesignSystem.spacing8),
        Text(
          subtitle,
          textAlign: centerAligned ? TextAlign.center : TextAlign.start,
          style: DesignSystem.bodyMedium.copyWith(color: palette.textSecondary),
        ),
      ],
    );
  }
}
