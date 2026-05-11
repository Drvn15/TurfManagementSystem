import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/theme.dart';
import 'features/admin/admin_dashboard.dart';
import 'features/auth/auth_controller.dart';
import 'features/auth/auth_state.dart';
import 'features/auth/login_screen.dart';
import 'features/splash/splash_screen.dart';
import 'features/user/user_home_screen.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeControllerProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Turf Booking',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const SplashScreen(nextScreen: AuthGate()),
    );
  }
}

class AuthGate extends ConsumerStatefulWidget {
  const AuthGate({super.key});

  @override
  ConsumerState<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends ConsumerState<AuthGate> {
  bool _restoreAttempted = false;

  @override
  void initState() {
    super.initState();
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    if (_restoreAttempted) {
      return;
    }

    _restoreAttempted = true;

    try {
      await ref.read(authControllerProvider.notifier).restoreSession();
    } catch (error) {
      debugPrint('Session restore error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);

    if (state.status == AuthStatus.loading) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: Theme.of(context).extension<AppPalette>()?.backgroundGradient ??
                DesignSystem.lavenderGradient,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).extension<AppPalette>()?.primary ??
                        DesignSystem.primaryIndigo,
                  ),
                ),
                SizedBox(height: DesignSystem.spacing24),
                Text(
                  'Loading your session...',
                  style: DesignSystem.bodyLarge.copyWith(
                    color: Theme.of(context).extension<AppPalette>()?.textPrimary ??
                        DesignSystem.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (state.status == AuthStatus.unauthenticated) {
      return const LoginScreen();
    }

    if (state.role == 'ADMIN') {
      return const AdminDashboard();
    }

    return const UserHomeScreen();
  }
}
