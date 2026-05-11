import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/design_system.dart';
import '../../core/widgets/premium_widgets.dart';
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
    if (_isLoading) return;

    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    try {
      await ref.read(authControllerProvider.notifier).login(
            phoneController.text.trim(),
            passwordController.text.trim(),
          );
      if (!mounted) return;
      setState(() => _isLoading = false);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Sign in failed. Check your phone number and password.';
        _isLoading = false;
      });
    }
  }

  void _showComingSoon(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label is not connected yet.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return PremiumScaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AuthHeader(
                      title: 'Book elite sports venues',
                      subtitle:
                          'Sign in to access live availability, instant booking, and premium turf experiences.',
                      showLogo: true,
                    ),
                    const SizedBox(height: DesignSystem.spacing32),
                    AuthInputField(
                      controller: phoneController,
                      labelText: 'Phone Number',
                      hintText: 'Enter your mobile number',
                      prefixIcon: Icons.phone_android_rounded,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: DesignSystem.spacing16),
                    AuthInputField(
                      controller: passwordController,
                      labelText: 'Password',
                      hintText: 'Enter your password',
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
                    const SizedBox(height: DesignSystem.spacing12),
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() => _rememberMe = value ?? false);
                          },
                        ),
                        Text('Remember me', style: DesignSystem.bodyMedium),
                        const Spacer(),
                        TextButton(
                          onPressed: () => _showComingSoon('Forgot password'),
                          child: const Text('Forgot password?'),
                        ),
                      ],
                    ),
                    if (_errorMessage != null) ...[
                      const SizedBox(height: DesignSystem.spacing12),
                      Container(
                        width: double.infinity,
                        padding: DesignSystem.paddingAll16,
                        decoration: BoxDecoration(
                          color: DesignSystem.error.withValues(alpha: 0.12),
                          borderRadius: DesignSystem.borderRadiusLarge,
                          border: Border.all(color: DesignSystem.error),
                        ),
                        child: Text(
                          _errorMessage!,
                          style: DesignSystem.bodyMedium.copyWith(
                            color: DesignSystem.textPrimary,
                          ),
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
                      iconColor: DesignSystem.textPrimary,
                      onPressed: () => _showComingSoon('Google sign in'),
                    ),
                    const SizedBox(height: DesignSystem.spacing12),
                    SocialLoginButton(
                      label: 'Continue with Apple',
                      icon: Icons.apple_rounded,
                      iconColor: DesignSystem.textPrimary,
                      onPressed: () => _showComingSoon('Apple sign in'),
                    ),
                    const SizedBox(height: DesignSystem.spacing24),
                    AuthToggleLink(
                      prompt: 'New to Turf Booking? ',
                      actionLabel: 'Create account',
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
                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0.06, 0),
                                    end: Offset.zero,
                                  ).animate(animation),
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
          ),
        ),
      ),
    );
  }
}
