import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart'; // ADD THIS IMPORT for DioException
import '../../core/api/api_client.dart';
import '../../core/theme/design_system.dart';
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

class _AdminDashboardState extends ConsumerState<AdminDashboard> with TickerProviderStateMixin {
  final ApiClient _api = ApiClient();
  List<dynamic> _turfs = [];
  bool _isLoading = true;
  String? _errorMessage;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: DesignSystem.animationNormal,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
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
      if (response is List) {
        setState(() {
          _turfs = response;
          _isLoading = false;
        });
        _fadeController.forward(from: 0.0);
      } else {
        setState(() {
          _turfs = [];
          _isLoading = false;
        });
      }
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
        title: Text("Delete Turf"),
        content: Text("Are you sure you want to delete this turf? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);

    try {
      await _api.delete("/turfs/$turfId");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Turf deleted successfully"),
          backgroundColor: Colors.green,
        ),
      );

      _fetchTurfs();
    } catch (e) {
      String errorMessage = "Failed to delete turf";

      // Check if it's a DioException
      if (e is DioException) {
        if (e.response?.statusCode == 401) {
          errorMessage = "Your session has expired. Please login again.";
          // Optionally logout the user
          ref.read(authControllerProvider.notifier).logout();
        } else if (e.response?.statusCode == 403) {
          errorMessage = "You don't have permission to delete this turf.";
        } else if (e.response?.statusCode == 404) {
          errorMessage = "Turf not found. It may have been already deleted.";
        } else if (e.response?.statusCode == 500) {
          errorMessage = "Server error. Please try again later.";
        } else {
          // Try to get error message from response
          try {
            if (e.response?.data != null && e.response?.data is Map) {
              final errorData = e.response?.data as Map;
              errorMessage = errorData['error'] ?? errorData['message'] ?? errorMessage;
            }
          } catch (_) {}
        }
      } else {
        errorMessage = e.toString();
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignSystem.backgroundLavender,
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        backgroundColor: DesignSystem.primaryIndigo,
        foregroundColor: DesignSystem.textWhite,
        elevation: DesignSystem.elevation0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: DesignSystem.textWhite),
            onPressed: _fetchTurfs,
          ),
          IconButton(
            icon: Icon(Icons.logout, color: DesignSystem.textWhite),
            onPressed: () {
              ref.read(authControllerProvider.notifier).logout();
            },
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(DesignSystem.primaryIndigo),
        ),
      )
          : _errorMessage != null
          ? _buildErrorState()
          : _turfs.isEmpty
          ? _buildEmptyState()
          : _buildTurfList(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: DesignSystem.backgroundWhite,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: DesignSystem.primaryIndigo,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: DesignSystem.textWhite,
                  child: Icon(
                    Icons.admin_panel_settings,
                    color: DesignSystem.primaryIndigo,
                    size: DesignSystem.iconLarge,
                  ),
                ),
                DesignSystem.gap12,
                Text(
                  'Admin Panel',
                  style: DesignSystem.headline4.copyWith(color: DesignSystem.textWhite),
                ),
                DesignSystem.gap4,
                Text(
                  'Manage your turf business',
                  style: DesignSystem.bodySmall.copyWith(color: DesignSystem.textWhite.withValues(alpha: 0.8)),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.dashboard, color: DesignSystem.primaryIndigo),
            title: Text('Dashboard', style: DesignSystem.bodyLarge),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.location_city, color: DesignSystem.primaryIndigo),
            title: Text('Manage Turfs', style: DesignSystem.bodyLarge),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminManageTurfsScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.person, color: DesignSystem.primaryIndigo),
            title: Text('Profile', style: DesignSystem.bodyLarge),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminProfileScreen()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: DesignSystem.error),
            title: Text('Logout', style: DesignSystem.bodyLarge.copyWith(color: DesignSystem.error)),
            onTap: () {
              Navigator.pop(context);
              ref.read(authControllerProvider.notifier).logout();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: DesignSystem.paddingAll24,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: DesignSystem.paddingAll16,
              decoration: DesignSystem.whiteCardDecoration,
              child: Icon(
                Icons.error_outline,
                size: DesignSystem.iconXLarge,
                color: DesignSystem.error,
              ),
            ),
            DesignSystem.gap16,
            Text(
              _errorMessage!,
              style: DesignSystem.bodyMedium.copyWith(color: DesignSystem.textSecondary),
              textAlign: TextAlign.center,
            ),
            DesignSystem.gap24,
            ElevatedButton(
              onPressed: _fetchTurfs,
              child: Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SafeArea(
      child: Padding(
        padding: DesignSystem.paddingAll24,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome, Admin!",
                  style: DesignSystem.headline2.copyWith(color: DesignSystem.textPrimary),
                ),
                DesignSystem.gap8,
                Text(
                  "Let's set up your turf business",
                  style: DesignSystem.bodyLarge.copyWith(color: DesignSystem.textSecondary),
                ),
              ],
            ),

            DesignSystem.gap64,

            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: DesignSystem.overlayLight,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.sports_soccer,
                        size: 100,
                        color: DesignSystem.primaryIndigo,
                      ),
                    ),
                    DesignSystem.gap40,
                    Text(
                      "Get Started in 3 Simple Steps",
                      style: DesignSystem.headline4.copyWith(
                        color: DesignSystem.textPrimary,
                        fontWeight: DesignSystem.fontWeightSemiBold,
                      ),
                    ),
                    DesignSystem.gap16,
                    _buildStepItem(1, "Add Turf Details"),
                    _buildStepItem(2, "Upload Photos"),
                    _buildStepItem(3, "Configure Sports & Courts"),
                  ],
                ),
              ),
            ),

            DesignSystem.gap24,

            SizedBox(
              width: double.infinity,
              height: DesignSystem.spacing56,
              child: ElevatedButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddTurfDetailsScreen(),
                    ),
                  );
                  _fetchTurfs();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: DesignSystem.primaryIndigo,
                  foregroundColor: DesignSystem.textWhite,
                  shape: DesignSystem.buttonShape,
                ),
                child: Text(
                  "Add Your First Turf",
                  style: DesignSystem.button,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTurfList() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ListView.builder(
        padding: DesignSystem.paddingAll16,
        itemCount: _turfs.length,
        itemBuilder: (context, index) {
          final turf = _turfs[index];
          return Container(
            margin: DesignSystem.marginBottom16,
            decoration: DesignSystem.cardDecoration,
            child: Padding(
              padding: DesignSystem.paddingAll16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          turf['name'] ?? 'Unnamed Turf',
                          style: DesignSystem.headline4,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: DesignSystem.primaryIndigo),
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
                            icon: Icon(Icons.delete, color: DesignSystem.error),
                            onPressed: () => _deleteTurf(turf['id']),
                          ),
                        ],
                      ),
                    ],
                  ),
                  DesignSystem.gap8,
                  Text(
                    turf['location'] ?? 'No location set',
                    style: DesignSystem.bodySmall.copyWith(color: DesignSystem.textSecondary),
                  ),
                  DesignSystem.gap4,
                  Text(
                    'Price: ₹${turf['price_per_hour'] ?? 0}/hour',
                    style: DesignSystem.bodyMedium.copyWith(
                      fontWeight: DesignSystem.fontWeightSemiBold,
                      color: DesignSystem.primaryIndigo,
                    ),
                  ),
                  DesignSystem.gap12,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatCard(
                        icon: Icons.sports_tennis,
                        label: 'Sports',
                        value: '3',
                      ),
                      _buildStatCard(
                        icon: Icons.sports_soccer,
                        label: 'Courts',
                        value: '5',
                      ),
                      _buildStatCard(
                        icon: Icons.calendar_today,
                        label: 'Bookings',
                        value: '12',
                      ),
                    ],
                  ),
                  DesignSystem.gap12,
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SportListScreen(turf: turf),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: DesignSystem.primaryIndigo, width: 2),
                            shape: DesignSystem.buttonShape,
                          ),
                          child: Text("Manage Sports"),
                        ),
                      ),
                      DesignSystem.gap8,
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to view bookings (to be implemented)
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Bookings feature coming soon!"),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: DesignSystem.primaryIndigo,
                            shape: DesignSystem.buttonShape,
                          ),
                          child: Text("View Bookings"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStepItem(int number, String text) {
    return Padding(
      padding: DesignSystem.paddingVertical8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: DesignSystem.primaryIndigo,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: DesignSystem.button.copyWith(color: DesignSystem.textWhite),
              ),
            ),
          ),
          DesignSystem.gap16,
          Text(
            text,
            style: DesignSystem.bodyLarge.copyWith(color: DesignSystem.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: DesignSystem.paddingAll12,
      decoration: BoxDecoration(
        color: DesignSystem.backgroundLight,
        borderRadius: DesignSystem.borderRadiusMedium,
      ),
      child: Column(
        children: [
          Icon(icon, size: DesignSystem.iconMedium, color: DesignSystem.primaryIndigo),
          DesignSystem.gap4,
          Text(
            value,
            style: DesignSystem.bodyMedium.copyWith(
              fontWeight: DesignSystem.fontWeightBold,
              color: DesignSystem.primaryIndigo,
            ),
          ),
          Text(
            label,
            style: DesignSystem.caption,
          ),
        ],
      ),
    );
  }
}
