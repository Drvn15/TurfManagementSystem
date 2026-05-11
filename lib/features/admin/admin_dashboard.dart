import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/api_client.dart';
import '../../core/theme/design_system.dart';
import '../../core/widgets/premium_widgets.dart';
import '../../core/widgets/theme_dropdown.dart';
import '../../core/widgets/theme_mode_menu_button.dart';
import '../auth/auth_controller.dart';
import 'add_turf_details_screen.dart';
import 'admin_manage_turfs_screen.dart';
import 'admin_profile_screen.dart';
import 'edit_turf_screen.dart';
import 'sport_list_screen.dart';

class AdminDashboard extends ConsumerStatefulWidget {
  const AdminDashboard({super.key});

  @override
  ConsumerState<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends ConsumerState<AdminDashboard>
    with TickerProviderStateMixin {
  final ApiClient _api = ApiClient();
  List<dynamic> _turfs = [];
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
    _fetchTurfs();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _fetchTurfs() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _api.get("/turfs");
      setState(() {
        _turfs = response is List ? response : [];
        _isLoading = false;
      });
      _fadeController.forward(from: 0);
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to load turfs: $e";
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteTurf(int turfId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Turf"),
        content: const Text(
          "Are you sure you want to delete this turf? This action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await _api.delete("/turfs/$turfId");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Turf deleted successfully")),
      );
      _fetchTurfs();
    } catch (e) {
      var errorMessage = "Failed to delete turf";
      if (e is DioException) {
        if (e.response?.statusCode == 401) {
          errorMessage = "Your session has expired. Please login again.";
          ref.read(authControllerProvider.notifier).logout();
        } else if (e.response?.data is Map) {
          final errorData = e.response?.data as Map;
          errorMessage =
              errorData['error'] ?? errorData['message'] ?? errorMessage;
        }
      } else {
        errorMessage = e.toString();
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = DesignSystem.paletteOf(context);
    return PremiumScaffold(
      appBar: AppBar(
        title: const Text("Admin"),
        actions: [
          const ThemeDropdown(),
          const ThemeModeMenuButton(),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _fetchTurfs,
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () {
              ref.read(authControllerProvider.notifier).logout();
            },
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Padding(
                    padding: DesignSystem.paddingAll24,
                    child: PremiumEmptyState(
                      title: 'Could not load admin data',
                      message: _errorMessage!,
                      action: SizedBox(
                        width: 180,
                        child: GlowButton(
                          label: 'Retry',
                          onPressed: _fetchTurfs,
                        ),
                      ),
                    ),
                  )
                : _turfs.isEmpty
                    ? _buildEmptyState()
                    : _buildDashboardContent(),
      ),
    );
  }

  Widget _buildDrawer() {
    final palette = DesignSystem.paletteOf(context);
    return Drawer(
      backgroundColor: palette.backgroundBase,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: palette.backgroundGradient,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: palette.surfaceElevated,
                  child: Icon(
                    Icons.admin_panel_settings_rounded,
                    color: palette.primary,
                    size: 28,
                  ),
                ),
                SizedBox(height: DesignSystem.spacing16),
                Text('Admin Panel', style: TextStyle(color: palette.textPrimary)),
                SizedBox(height: DesignSystem.spacing4),
                Text(
                  'Manage your premium turf network',
                  style: TextStyle(color: palette.textSecondary),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.dashboard_rounded, color: palette.primary),
            title: Text('Dashboard', style: DesignSystem.bodyLarge.copyWith(color: palette.textPrimary)),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.location_city_rounded, color: palette.primary),
            title: Text('Manage Turfs', style: DesignSystem.bodyLarge.copyWith(color: palette.textPrimary)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminManageTurfsScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.person_rounded, color: palette.primary),
            title: Text('Profile', style: DesignSystem.bodyLarge.copyWith(color: palette.textPrimary)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminProfileScreen()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.logout_rounded, color: palette.error),
            title: Text(
              'Logout',
              style: DesignSystem.bodyLarge.copyWith(color: palette.error),
            ),
            onTap: () {
              Navigator.pop(context);
              ref.read(authControllerProvider.notifier).logout();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: DesignSystem.paddingAll24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            eyebrow: 'Admin',
            title: 'Launch your first premium venue',
            subtitle:
                'Create a polished sports-tech presence with booking, slots, and venue management.',
          ),
          const SizedBox(height: DesignSystem.spacing32),
          Expanded(
            child: PremiumEmptyState(
              title: 'No turfs added yet',
              message:
                  'Start by creating your first turf, then add sports, courts, pricing, and photos.',
              action: SizedBox(
                width: 220,
                child: GlowButton(
                  label: 'Add Your First Turf',
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddTurfDetailsScreen(),
                      ),
                    );
                    _fetchTurfs();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        children: [
          const SectionTitle(
            eyebrow: 'Control Center',
            title: 'Operate your venues with clarity',
            subtitle:
                'Monitor inventory, update listing details, and keep your turf business running smoothly.',
          ),
          const SizedBox(height: DesignSystem.spacing24),
          Row(
            children: [
              Expanded(
                child: PremiumStatCard(
                  label: 'Active Turfs',
                  value: '${_turfs.length}',
                  icon: Icons.stadium_rounded,
                ),
              ),
              const SizedBox(width: DesignSystem.spacing12),
              const Expanded(
                child: PremiumStatCard(
                  label: 'Live Bookings',
                  value: '12',
                  icon: Icons.event_available_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignSystem.spacing12),
          const Row(
            children: [
              Expanded(
                child: PremiumStatCard(
                  label: 'Avg. Rating',
                  value: '4.8',
                  icon: Icons.star_rounded,
                ),
              ),
              SizedBox(width: DesignSystem.spacing12),
              Expanded(
                child: PremiumStatCard(
                  label: 'Revenue',
                  value: 'Rs 24K',
                  icon: Icons.payments_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignSystem.spacing24),
          ..._turfs.map((turf) => _buildTurfCard(turf)).toList(),
        ],
      ),
    );
  }

  Widget _buildTurfCard(dynamic turf) {
    final palette = DesignSystem.paletteOf(context);
    return Padding(
      padding: DesignSystem.marginBottom16,
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        turf['name'] ?? 'Unnamed Turf',
                        style: DesignSystem.headline4,
                      ),
                      const SizedBox(height: DesignSystem.spacing8),
                      Text(
                        turf['location'] ?? 'No location set',
                        style: DesignSystem.bodyMedium,
                      ),
                      const SizedBox(height: DesignSystem.spacing12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: palette.overlaySoft,
                          borderRadius: DesignSystem.borderRadiusRound,
                          border: Border.all(color: palette.glassBorder),
                        ),
                        child: Text(
                          'Rs ${turf['price_per_hour'] ?? 0}/hour',
                          style: DesignSystem.bodyMedium.copyWith(
                            color: palette.primary,
                            fontWeight: DesignSystem.fontWeightSemiBold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit_rounded, color: palette.primary),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditTurfScreen(turf: turf),
                          ),
                        );
                        _fetchTurfs();
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline_rounded, color: palette.error),
                      onPressed: () => _deleteTurf(turf['id']),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: DesignSystem.spacing20),
            Row(
              children: const [
                Expanded(
                  child: PremiumStatCard(
                    label: 'Sports',
                    value: '3',
                    icon: Icons.sports_soccer_rounded,
                  ),
                ),
                SizedBox(width: DesignSystem.spacing12),
                Expanded(
                  child: PremiumStatCard(
                    label: 'Courts',
                    value: '5',
                    icon: Icons.grid_view_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: DesignSystem.spacing16),
            LayoutBuilder(
              builder: (context, constraints) {
                final stackButtons = constraints.maxWidth < 430;
                final buttonWidth = stackButtons
                    ? constraints.maxWidth
                    : (constraints.maxWidth - DesignSystem.spacing12) / 2;

                return Wrap(
                  spacing: DesignSystem.spacing12,
                  runSpacing: DesignSystem.spacing12,
                  children: [
                    SizedBox(
                      width: buttonWidth,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SportListScreen(turf: turf),
                            ),
                          );
                        },
                        child: const Text("Manage Sports"),
                      ),
                    ),
                    SizedBox(
                      width: buttonWidth,
                      child: GlowButton(
                        label: 'View Bookings',
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Bookings feature coming soon!"),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
