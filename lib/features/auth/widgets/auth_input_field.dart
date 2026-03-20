import 'package:flutter/material.dart';

import '../../../core/theme/design_system.dart';

class AuthInputField extends StatelessWidget {
  static const Color _surface = Colors.white;
  static const Color _textPrimary = Colors.black;
  static const Color _textSecondary = Color(0xFF595959);
  static const Color _textLight = Color(0xFF9A9A9A);
  static const Color _border = Color(0xFFE7E7E7);

  final TextEditingController controller;
  final String? labelText;
  final String hintText;
  final IconData prefixIcon;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final bool hasError;

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

  @override
  Widget build(BuildContext context) {
    final borderColor = hasError ? const Color(0xFFFF5E87) : _border;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          Text(
            labelText!,
            style: DesignSystem.headline4.copyWith(
              color: _textPrimary,
              fontSize: 15,
              fontWeight: DesignSystem.fontWeightMedium,
            ),
          ),
          const SizedBox(height: DesignSystem.spacing8),
        ],
        Container(
          decoration: BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.circular(DesignSystem.radiusLarge + 8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            style: DesignSystem.bodyLarge.copyWith(
              color: _textPrimary,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: DesignSystem.bodyLarge.copyWith(
                color: _textLight,
              ),
              prefixIcon: Icon(
                prefixIcon,
                color: _textSecondary,
              ),
              suffixIcon: suffixIcon,
              filled: true,
              fillColor: Colors.transparent,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: DesignSystem.spacing16,
                vertical: DesignSystem.spacing20,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  DesignSystem.radiusLarge + 8,
                ),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  DesignSystem.radiusLarge + 8,
                ),
                borderSide: BorderSide(
                  color: hasError ? borderColor : _textPrimary,
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  DesignSystem.radiusLarge + 8,
                ),
                borderSide: BorderSide(color: borderColor),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  DesignSystem.radiusLarge + 8,
                ),
                borderSide: BorderSide(color: borderColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
