import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/theme/design_system.dart';

class AuthInputField extends StatelessWidget {
  const AuthInputField({
    super.key,
    required this.controller,
    this.labelText,
    required this.hintText,
    required this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.suffixIcon,
    this.hasError = false,
  });

  final TextEditingController controller;
  final String? labelText;
  final String hintText;
  final IconData prefixIcon;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final palette = DesignSystem.paletteOf(context);
    final borderColor = hasError ? palette.error : palette.glassBorder;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          Text(
            labelText!,
            style: DesignSystem.bodyMedium.copyWith(
              color: palette.textPrimary,
              fontWeight: DesignSystem.fontWeightSemiBold,
            ),
          ),
          const SizedBox(height: DesignSystem.spacing8),
        ],
        ClipRRect(
          borderRadius: DesignSystem.borderRadiusLarge,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              decoration: BoxDecoration(
                color: palette.surfaceGlass,
                borderRadius: DesignSystem.borderRadiusLarge,
                border: Border.all(color: borderColor),
                boxShadow: DesignSystem.shadowSmallFor(context),
              ),
              child: TextField(
                controller: controller,
                keyboardType: keyboardType,
                obscureText: obscureText,
                style: DesignSystem.bodyLarge.copyWith(color: palette.textPrimary),
                decoration: InputDecoration(
                  hintText: hintText,
                  prefixIcon: Icon(prefixIcon),
                  suffixIcon: suffixIcon,
                  filled: false,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
