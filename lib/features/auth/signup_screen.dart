import 'package:flutter/material.dart';

import '../../core/theme/design_system.dart';
import '../../core/widgets/premium_widgets.dart';
import '../../core/widgets/theme_toggle.dart';
import 'widgets/auth_button.dart';
import 'widgets/auth_divider.dart';
import 'widgets/auth_header.dart';
import 'widgets/auth_input_field.dart';
import 'widgets/auth_toggle_link.dart';
import 'widgets/social_login_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _termsAccepted = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool get _showPasswordMismatch {
    final confirm = _confirmPasswordController.text.trim();
    if (confirm.isEmpty) return false;
    return confirm != _passwordController.text.trim();
  }

  void _showComingSoon(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label will be available soon.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = DesignSystem.paletteOf(context);
    return PremiumScaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: IconButton.styleFrom(
                            backgroundColor: palette.surfaceGlass,
                            foregroundColor: palette.textPrimary,
                            side: BorderSide(color: palette.glassBorder),
                          ),
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                        ),
                        const Spacer(),
                        const ThemeSceneToggle(),
                      ],
                    ),
                    const SizedBox(height: DesignSystem.spacing20),
                    const AuthHeader(
                      title: 'Create your player profile',
                      subtitle:
                          'Join a premium booking network for football, cricket, badminton, and more.',
                    ),
                    const SizedBox(height: DesignSystem.spacing24),
                    Row(
                      children: [
                        Expanded(
                          child: SocialLoginButton(
                            label: 'Google',
                            icon: Icons.g_mobiledata_rounded,
                            iconColor: DesignSystem.textPrimary,
                            onPressed: () => _showComingSoon('Google sign in'),
                          ),
                        ),
                        const SizedBox(width: DesignSystem.spacing12),
                        Expanded(
                          child: SocialLoginButton(
                            label: 'Apple',
                            icon: Icons.apple_rounded,
                            iconColor: DesignSystem.textPrimary,
                            onPressed: () => _showComingSoon('Apple sign in'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: DesignSystem.spacing24),
                    const AuthDivider(),
                    const SizedBox(height: DesignSystem.spacing24),
                    AuthInputField(
                      controller: _nameController,
                      labelText: 'Full Name',
                      hintText: 'Enter your name',
                      prefixIcon: Icons.person_outline_rounded,
                    ),
                    const SizedBox(height: DesignSystem.spacing16),
                    AuthInputField(
                      controller: _phoneController,
                      labelText: 'Phone',
                      hintText: 'Enter your phone number',
                      prefixIcon: Icons.phone_android_rounded,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: DesignSystem.spacing16),
                    AuthInputField(
                      controller: _emailController,
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: DesignSystem.spacing16),
                    AuthInputField(
                      controller: _passwordController,
                      labelText: 'Password',
                      hintText: 'Create a secure password',
                      prefixIcon: Icons.lock_outline_rounded,
                      obscureText: !_isPasswordVisible,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                      ),
                    ),
                    const SizedBox(height: DesignSystem.spacing16),
                    AuthInputField(
                      controller: _confirmPasswordController,
                      labelText: 'Confirm Password',
                      hintText: 'Retype your password',
                      prefixIcon: Icons.verified_user_outlined,
                      obscureText: !_isConfirmPasswordVisible,
                      hasError: _showPasswordMismatch,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                          });
                        },
                        icon: Icon(
                          _isConfirmPasswordVisible
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                      ),
                    ),
                    if (_showPasswordMismatch) ...[
                      const SizedBox(height: DesignSystem.spacing12),
                      Container(
                        width: double.infinity,
                        padding: DesignSystem.paddingAll16,
                        decoration: BoxDecoration(
                          color: palette.error.withValues(alpha: 0.12),
                          borderRadius: DesignSystem.borderRadiusLarge,
                          border: Border.all(color: palette.error),
                        ),
                        child: Text(
                          'Passwords do not match yet.',
                          style: DesignSystem.bodyMedium.copyWith(
                            color: palette.textPrimary,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: DesignSystem.spacing16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _termsAccepted,
                          onChanged: (value) {
                            setState(() => _termsAccepted = value ?? false);
                          },
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: RichText(
                              text: TextSpan(
                                text: 'I agree to the ',
                                style: DesignSystem.bodyMedium,
                                children: [
                                  TextSpan(
                                    text: 'Terms of Service',
                                    style: DesignSystem.bodyMedium.copyWith(
                                      color: DesignSystem.accentLime,
                                      fontWeight: DesignSystem.fontWeightSemiBold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' and ',
                                    style: DesignSystem.bodyMedium,
                                  ),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: DesignSystem.bodyMedium.copyWith(
                                      color: DesignSystem.accentLime,
                                      fontWeight: DesignSystem.fontWeightSemiBold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: DesignSystem.spacing24),
                    AuthButton(
                      label: 'Create Account',
                      onPressed: _termsAccepted && !_showPasswordMismatch
                          ? () => _showComingSoon('Sign up')
                          : null,
                    ),
                    const SizedBox(height: DesignSystem.spacing20),
                    AuthToggleLink(
                      prompt: 'Already have an account? ',
                      actionLabel: 'Sign In',
                      onTap: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
