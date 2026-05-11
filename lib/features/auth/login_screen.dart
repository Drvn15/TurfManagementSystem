import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/design_system.dart';
import 'auth_controller.dart';
import 'auth_state.dart';
import 'signup_screen.dart';
import 'widgets/auth_button.dart';
import 'widgets/auth_divider.dart';
import 'widgets/auth_header.dart';
import 'widgets/auth_input_field.dart';
import 'widgets/auth_toggle_link.dart';
import 'widgets/social_login_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  static const Color _background = DesignSystem.backgroundLavender;
  static const Color _textPrimary = Colors.black;
  static const Color _textSecondary = Color(0xFF5A5A5A);
  static const Color _accent = Colors.black;

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _rememberMe = false;
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> handleLogin() async {
    if (_isLoading) {
      return;
    }

    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    try {
      await ref.read(authControllerProvider.notifier).login(
            phoneController.text.trim(),
            passwordController.text.trim(),
          );

      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = 'Login failed. Please check your credentials.';
        _isLoading = false;
      });
    }
  }

  void _showComingSoon(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label is not connected yet.'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: _accent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignSystem.radiusMedium),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            DesignSystem.spacing24,
            DesignSystem.spacing24,
            DesignSystem.spacing24,
            DesignSystem.spacing32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: DesignSystem.spacing24),
              const AuthHeader(
                title: 'Welcome Back!',
                subtitle: 'Sign in to continue',
                showLogo: true,
              ),
              const SizedBox(height: DesignSystem.spacing32),
              AuthInputField(
                controller: phoneController,
                hintText: 'Phone Number',
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: DesignSystem.spacing16),
              AuthInputField(
                controller: passwordController,
                hintText: 'Password',
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
              const SizedBox(height: DesignSystem.spacing12),
              Row(
                children: [
                  Transform.scale(
                    scale: 0.95,
                    child: Checkbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                    ),
                  ),
                  Text(
                    'Remember me',
                    style: DesignSystem.bodyMedium.copyWith(
                      color: _textSecondary,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => _showComingSoon('Forgot password'),
                    child: Text(
                      'Forgot password?',
                      style: DesignSystem.bodyMedium.copyWith(
                        color: _accent,
                        fontWeight: DesignSystem.fontWeightSemiBold,
                      ),
                    ),
                  ),
                ],
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: DesignSystem.spacing8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(DesignSystem.spacing12),
                  decoration: BoxDecoration(
                    color: DesignSystem.error.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(DesignSystem.radiusMedium),
                    border: Border.all(
                      color: DesignSystem.error.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: DesignSystem.error,
                        size: 20,
                      ),
                      const SizedBox(width: DesignSystem.spacing8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: DesignSystem.bodyMedium.copyWith(
                            color: DesignSystem.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: DesignSystem.spacing24),
              AuthButton(
                label: 'Sign In',
                isLoading: _isLoading || authState.status == AuthStatus.loading,
                onPressed: handleLogin,
              ),
              const SizedBox(height: DesignSystem.spacing24),
              const AuthDivider(),
              const SizedBox(height: DesignSystem.spacing24),
              SocialLoginButton(
                label: 'Continue with Google',
                icon: Icons.g_mobiledata_rounded,
                iconColor: _textPrimary,
                onPressed: () => _showComingSoon('Google sign in'),
              ),
              const SizedBox(height: DesignSystem.spacing12),
              SocialLoginButton(
                label: 'Continue with Apple',
                icon: Icons.apple,
                iconColor: _textPrimary,
                onPressed: () => _showComingSoon('Apple sign in'),
              ),
              const SizedBox(height: DesignSystem.spacing32),
              AuthToggleLink(
                prompt: 'Don\'t have an account? ',
                actionLabel: 'Sign Up',
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder<void>(
                      transitionDuration: DesignSystem.animationPage,
                      reverseTransitionDuration: DesignSystem.animationPage,
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const SignUpScreen(),
                      transitionsBuilder: (
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ) {
                        final offsetAnimation = Tween<Offset>(
                          begin: const Offset(0.12, 0),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                          ),
                        );

                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
