import 'package:flutter/material.dart';

import '../../../core/theme/design_system.dart';

class AuthHeader extends StatelessWidget {
  static const Color _textPrimary = Colors.black;
  static const Color _textSecondary = Color(0xFF5F5F5F);
  static const Color _surface = Colors.white;

  final String title;
  final String subtitle;
  final bool showLogo;
  final bool centerAligned;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.showLogo = false,
    this.centerAligned = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          centerAligned ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        if (showLogo)
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: _surface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.sports_soccer,
                color: _textPrimary,
                size: 40,
              ),
            ),
          ),
        if (showLogo) const SizedBox(height: DesignSystem.spacing32),
        Text(
          title,
          textAlign: centerAligned ? TextAlign.center : TextAlign.start,
          style: DesignSystem.headline1.copyWith(
            color: _textPrimary,
          ),
        ),
        const SizedBox(height: DesignSystem.spacing8),
        Text(
          subtitle,
          textAlign: centerAligned ? TextAlign.center : TextAlign.start,
          style: DesignSystem.bodyLarge.copyWith(
            color: _textSecondary,
          ),
        ),
      ],
    );
  }
}
