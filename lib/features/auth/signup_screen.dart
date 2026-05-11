import 'package:flutter/material.dart';

import '../../core/theme/design_system.dart';
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
  static const Color _background = DesignSystem.backgroundLavender;
  static const Color _textSecondary = Color(0xFF5A5A5A);
  static const Color _accent = Colors.black;
  static const Color _softBorder = Color(0xFFE3DED8);
  static const Color _errorAccent = Color(0xFFFF5E87);

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
    if (confirm.isEmpty) {
      return false;
    }

    return confirm != _passwordController.text.trim();
  }

  void _showComingSoon(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label will be available soon.'),
        backgroundColor: _accent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignSystem.radiusMedium),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            DesignSystem.spacing24,
            DesignSystem.spacing16,
            DesignSystem.spacing24,
            DesignSystem.spacing32,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: _accent,
                    side: const BorderSide(color: _softBorder),
                  ),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                ),
              ),
              const SizedBox(height: DesignSystem.spacing16),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.sports_soccer,
                  color: Colors.black,
                  size: 30,
                ),
              ),
              const SizedBox(height: DesignSystem.spacing24),
              const AuthHeader(
                title: 'Welcome back',
                subtitle: 'Please enter your details to sign up',
                centerAligned: true,
              ),
              const SizedBox(height: DesignSystem.spacing32),
              Row(
                children: [
                  Expanded(
                    child: SocialLoginButton(
                      label: 'Google',
                      icon: Icons.g_mobiledata_rounded,
                      iconColor: _accent,
                      onPressed: () => _showComingSoon('Google sign in'),
                    ),
                  ),
                  const SizedBox(width: DesignSystem.spacing12),
                  Expanded(
                    child: SocialLoginButton(
                      label: 'Apple',
                      icon: Icons.apple,
                      iconColor: _accent,
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
                labelText: 'Name',
                hintText: 'Enter your full name',
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: DesignSystem.spacing16),
              AuthInputField(
                controller: _phoneController,
                labelText: 'Phone',
                hintText: 'Enter your phone number',
                prefixIcon: Icons.phone_outlined,
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
                hintText: 'Enter your password',
                prefixIcon: Icons.lock_outline,
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
                    color: DesignSystem.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: DesignSystem.spacing16),
              AuthInputField(
                controller: _confirmPasswordController,
                labelText: 'Password confirmation',
                hintText: 'Confirm your password',
                prefixIcon: Icons.lock_outline,
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
                    color: DesignSystem.textSecondary,
                  ),
                ),
              ),
              if (_showPasswordMismatch) ...[
                const SizedBox(height: DesignSystem.spacing12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignSystem.spacing12,
                    vertical: DesignSystem.spacing12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(DesignSystem.radiusLarge + 8),
                    border: Border.all(color: _errorAccent),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 18,
                        color: _errorAccent,
                      ),
                      const SizedBox(width: DesignSystem.spacing8),
                      Expanded(
                        child: Text(
                          'ERROR: password do not match',
                          style: DesignSystem.bodySmall.copyWith(
                            color: const Color(0xFF6D5960),
                            fontWeight: DesignSystem.fontWeightMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: DesignSystem.spacing12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Transform.translate(
                    offset: const Offset(-6, -2),
                    child: Checkbox(
                      value: _termsAccepted,
                      onChanged: (value) {
                        setState(() {
                          _termsAccepted = value ?? false;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _showComingSoon('Terms and privacy details'),
                      child: Padding(
                        padding: const EdgeInsets.only(top: DesignSystem.spacing4),
                        child: RichText(
                          text: TextSpan(
                            text: 'I agree to the ',
                            style: DesignSystem.bodyMedium.copyWith(
                              color: _textSecondary,
                            ),
                            children: [
                              TextSpan(
                                text: 'Terms of Service',
                                style: DesignSystem.bodyMedium.copyWith(
                                  color: _accent,
                                  fontWeight: DesignSystem.fontWeightSemiBold,
                                ),
                              ),
                              TextSpan(
                                text: ' and ',
                                style: DesignSystem.bodyMedium.copyWith(
                                  color: _textSecondary,
                                ),
                              ),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: DesignSystem.bodyMedium.copyWith(
                                  color: _accent,
                                  fontWeight: DesignSystem.fontWeightSemiBold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: DesignSystem.spacing24),
              AuthButton(
                label: 'Sign Up',
                onPressed: _termsAccepted && !_showPasswordMismatch
                    ? () => _showComingSoon('Sign up')
                    : null,
              ),
              const SizedBox(height: DesignSystem.spacing24),
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
    );
  }
}
