import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/design_system.dart';
import '../auth/auth_controller.dart';
import '../auth/auth_state.dart';
import 'admin_manage_turfs_screen.dart';

class AdminProfileScreen extends ConsumerWidget {
  const AdminProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final adminRole = authState.role?.toUpperCase() ?? 'ADMIN';
    final isActive = authState.status == AuthStatus.authenticated;
    final statusLabel = isActive ? 'Active' : 'Inactive';

    return Scaffold(
      backgroundColor: DesignSystem.backgroundLight,
      appBar: AppBar(
        title: const Text('Admin Profile'),
        backgroundColor: DesignSystem.primaryIndigo,
        foregroundColor: DesignSystem.textWhite,
        elevation: DesignSystem.elevation0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(
              top: 0,
              left: 24,
              right: 24,
              bottom: 120,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                _buildHeader(context, adminRole, statusLabel),
                DesignSystem.gap24,
                _buildSectionTitle('Quick Actions'),
                _buildActionGrid(context),
                DesignSystem.gap24,
                _buildSectionTitle('Dashboard Stats'),
                _buildStatsRow(),
                DesignSystem.gap24,
                _buildSectionTitle('Account Information'),
                _buildInfoCard(statusLabel, adminRole),
                DesignSystem.gap24,
                _buildSectionTitle('Settings'),
                _buildSettingsCard(context, ref),
                const SizedBox(height: 24),
              ],
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 24,
            child: _buildLogoutButton(context, ref),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String role, String status) {
    return Container(
      decoration: BoxDecoration(
        gradient: DesignSystem.primaryGradient,
        borderRadius: BorderRadius.circular(28),
        boxShadow: DesignSystem.shadowMedium,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 28,
      ),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [DesignSystem.textWhite.withOpacity(0.95), DesignSystem.textWhite.withOpacity(0.75)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: DesignSystem.shadowMedium,
            ),
            child: Center(
              child: Icon(
                Icons.admin_panel_settings,
                size: 44,
                color: DesignSystem.primaryIndigo,
              ),
            ),
          ),
          DesignSystem.gap16,
          Text(
            'Facility Owner',
            style: DesignSystem.headline2.copyWith(
              color: DesignSystem.textWhite,
              fontWeight: DesignSystem.fontWeightBold,
            ),
          ),
          DesignSystem.gap8,
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: DesignSystem.textWhite.withOpacity(0.16),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              role,
              style: DesignSystem.caption.copyWith(
                color: DesignSystem.textWhite,
                fontWeight: DesignSystem.fontWeightSemiBold,
              ),
            ),
          ),
          DesignSystem.gap12,
          Text(
            'Powerful turf management in one place',
            textAlign: TextAlign.center,
            style: DesignSystem.bodyMedium.copyWith(
              color: DesignSystem.textWhite.withOpacity(0.92),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: DesignSystem.headline4.copyWith(
        color: DesignSystem.textPrimary,
        fontWeight: DesignSystem.fontWeightSemiBold,
      ),
    );
  }

  Widget _buildActionGrid(BuildContext context) {
    final actions = [
      _AdminAction('Manage Turfs', Icons.location_city, () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AdminManageTurfsScreen()),
        );
      }),
      _AdminAction('Manage Courts', Icons.sports_basketball, () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Manage Courts coming soon')),
        );
      }),
      _AdminAction('View Bookings', Icons.calendar_month, () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('View Bookings coming soon')),
        );
      }),
      _AdminAction('Revenue', Icons.trending_up, () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Earnings summary coming soon')),
        );
      }),
      _AdminAction('Availability', Icons.schedule, () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Time slot control coming soon')),
        );
      }),
    ];

    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.28,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return _buildActionCard(context, action);
      },
    );
  }

  Widget _buildActionCard(BuildContext context, _AdminAction action) {
    return Material(
      color: DesignSystem.backgroundWhite,
      borderRadius: BorderRadius.circular(18),
      elevation: 2,
      shadowColor: DesignSystem.shadowColor.withOpacity(0.08),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: action.onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: DesignSystem.primaryIndigo.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.all(12),
                child: Icon(action.icon, color: DesignSystem.primaryIndigo, size: 24),
              ),
              DesignSystem.gap16,
              Text(
                action.label,
                style: DesignSystem.bodyLarge.copyWith(
                  color: DesignSystem.textPrimary,
                  fontWeight: DesignSystem.fontWeightSemiBold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(child: _buildStatCard('Today', '8 bookings', Icons.calendar_today)),
        const SizedBox(width: 16),
        Expanded(child: _buildStatCard('Active', '12 courts', Icons.sports_soccer)),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: DesignSystem.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: DesignSystem.shadowSmall,
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: DesignSystem.primaryIndigo.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.all(12),
            child: Icon(icon, color: DesignSystem.primaryIndigo, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: DesignSystem.caption.copyWith(color: DesignSystem.textSecondary)),
                DesignSystem.gap4,
                Text(value, style: DesignSystem.headline5.copyWith(fontWeight: DesignSystem.fontWeightSemiBold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String status, String role) {
    return Container(
      decoration: BoxDecoration(
        color: DesignSystem.backgroundWhite,
        borderRadius: BorderRadius.circular(22),
        boxShadow: DesignSystem.shadowSmall,
      ),
      child: Column(
        children: [
          _buildInfoRow('Account Status', status),
          _buildDivider(),
          _buildInfoRow('Role', 'Facility Owner - Admin'),
          _buildDivider(),
          _buildInfoRow('Account Type', 'Business'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: DesignSystem.bodyMedium.copyWith(color: DesignSystem.textSecondary)),
          Text(value, style: DesignSystem.bodyLarge.copyWith(color: DesignSystem.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(color: DesignSystem.borderLight, height: 0, thickness: 1);
  }

  Widget _buildSettingsCard(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: DesignSystem.backgroundWhite,
        borderRadius: BorderRadius.circular(22),
        boxShadow: DesignSystem.shadowSmall,
      ),
      child: Column(
        children: [
          _buildSettingTile(context, 'Edit Profile', Icons.edit, () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Edit Profile is not available yet')),
            );
          }),
          _buildDivider(),
          _buildSettingTile(context, 'Change Password', Icons.lock, () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Change Password is not available yet')),
            );
          }),
          _buildDivider(),
          _buildSettingTile(context, 'Notifications', Icons.notifications, () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Notification settings are not available yet')),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSettingTile(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      leading: Icon(icon, color: DesignSystem.primaryIndigo),
      title: Text(title, style: DesignSystem.bodyLarge.copyWith(color: DesignSystem.textPrimary)),
      trailing: Icon(Icons.chevron_right, color: DesignSystem.textSecondary),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: () => _showLogoutConfirmation(context, ref),
        style: ElevatedButton.styleFrom(
          backgroundColor: DesignSystem.error,
          shape: DesignSystem.buttonShape,
        ),
        child: Text(
          'Logout',
          style: DesignSystem.button.copyWith(color: DesignSystem.textWhite),
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                ref.read(authControllerProvider.notifier).logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: DesignSystem.error,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}

class _AdminAction {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  _AdminAction(this.label, this.icon, this.onTap);
}
