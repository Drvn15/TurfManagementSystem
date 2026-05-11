import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/api_client.dart';
import '../../core/theme/design_system.dart';
import '../../core/widgets/premium_widgets.dart';

class AdminUsersScreen extends ConsumerStatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  ConsumerState<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends ConsumerState<AdminUsersScreen>
    with TickerProviderStateMixin {
  final ApiClient _api = ApiClient();
  List<dynamic> _users = [];
  bool _isLoading = true;
  String? _errorMessage;
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: DesignSystem.animationNormal,
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: DesignSystem.curveStandard,
    );
    _fetchUsers();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _fetchUsers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _api.get('/users');
      setState(() {
        _users = response is List ? response : [];
        _isLoading = false;
      });
      _fadeController.forward(from: 0);
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load users: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = DesignSystem.paletteOf(context);

    return PremiumScaffold(
      appBar: AppBar(
        title: const Text('Manage Users'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _fetchUsers,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Padding(
                  padding: DesignSystem.paddingAll24,
                  child: PremiumEmptyState(
                    title: 'Could not load users',
                    message: _errorMessage!,
                    action: SizedBox(
                      width: 170,
                      child: GlowButton(
                        label: 'Retry',
                        onPressed: _fetchUsers,
                      ),
                    ),
                  ),
                )
              : _users.isEmpty
                  ? const Padding(
                      padding: DesignSystem.paddingAll24,
                      child: PremiumEmptyState(
                        title: 'No users found',
                        message: 'Registered users will appear here automatically.',
                      ),
                    )
                  : FadeTransition(
                      opacity: _fadeAnimation,
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                        itemCount: _users.length,
                        itemBuilder: (context, index) {
                          final user = _users[index];
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: DesignSystem.spacing12,
                            ),
                            child: GlassCard(
                              padding: const EdgeInsets.all(14),
                              borderRadius: DesignSystem.borderRadiusLarge,
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: CircleAvatar(
                                  backgroundColor: palette.primary,
                                  foregroundColor:
                                      DesignSystem.isDark(context)
                                          ? palette.backgroundBase
                                          : palette.textWhite,
                                  child: Text(
                                    (user['name'] ?? 'U')[0].toUpperCase(),
                                    style: DesignSystem.bodyMedium.copyWith(
                                      fontWeight: DesignSystem.fontWeightSemiBold,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  user['name'] ?? 'Unnamed User',
                                  style: DesignSystem.bodyLarge.copyWith(
                                    color: palette.textPrimary,
                                  ),
                                ),
                                subtitle: Text(
                                  user['phone'] ?? 'No phone',
                                  style: DesignSystem.bodySmall.copyWith(
                                    color: palette.textSecondary,
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.person_outline_rounded,
                                  color: palette.primary,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}
