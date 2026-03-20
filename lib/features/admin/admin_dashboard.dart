import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart'; // ADD THIS IMPORT for DioException
import '../../core/api/api_client.dart';
import '../../core/theme/app_theme.dart';
import '../auth/auth_controller.dart';
import 'add_turf_details_screen.dart';
import 'edit_turf_screen.dart';
import 'sport_list_screen.dart';

class AdminDashboard extends ConsumerStatefulWidget {
  const AdminDashboard({super.key});

  @override
  ConsumerState<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends ConsumerState<AdminDashboard> {
  final ApiClient _api = ApiClient();
  List<dynamic> _turfs = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchTurfs();
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
      print("🗑️ Attempting to delete turf: $turfId");
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
      print("❌ Delete error: $e");

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
      backgroundColor: AppTheme.purpleBackground,
      appBar: AppBar(
        title: Text("Admin Dashboard"),
        backgroundColor: AppTheme.purplePrimary,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchTurfs,
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              ref.read(authControllerProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      )
          : _errorMessage != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
            SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchTurfs,
              child: Text("Retry"),
            ),
          ],
        ),
      )
          : _turfs.isEmpty
          ? _buildEmptyState()
          : _buildTurfList(),
    );
  }

  Widget _buildEmptyState() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome, Admin!",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Let's set up your turf business",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),

            SizedBox(height: 60),

            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.sports_soccer,
                        size: 100,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 40),
                    Text(
                      "Get Started in 3 Simple Steps",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildStepItem(1, "Add Turf Details"),
                    _buildStepItem(2, "Upload Photos"),
                    _buildStepItem(3, "Configure Sports & Courts"),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 56,
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
                  backgroundColor: Colors.white,
                  foregroundColor: AppTheme.purplePrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  "Add Your First Turf",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTurfList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _turfs.length,
      itemBuilder: (context, index) {
        final turf = _turfs[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        turf['name'] ?? 'Unnamed Turf',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: AppTheme.purplePrimary),
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
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteTurf(turf['id']),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  turf['location'] ?? 'No location set',
                  style: const TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 4),
                Text(
                  'Price: ₹${turf['price_per_hour'] ?? 0}/hour',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.purplePrimary,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatCard(
                      icon: Icons.sports_tennis,
                      label: 'Sports',
                      value: '3',
                    ),
                    _buildStatCard(
                      icon: Icons.sports_tennis,
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
                SizedBox(height: 12),
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
                        child: Text("Manage Sports"),
                      ),
                    ),
                    SizedBox(width: 8),
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
                          backgroundColor: AppTheme.purplePrimary,
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
    );
  }

  Widget _buildStepItem(int number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: TextStyle(
                  color: AppTheme.purplePrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.purpleLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: AppTheme.purplePrimary),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.purplePrimary,
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }
}
