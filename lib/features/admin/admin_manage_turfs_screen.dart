import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../core/api/api_client.dart';
import '../../core/theme/design_system.dart';
import 'add_turf_details_screen.dart';
import 'edit_turf_screen.dart';
import 'sport_list_screen.dart';

class AdminManageTurfsScreen extends ConsumerStatefulWidget {
  const AdminManageTurfsScreen({super.key});

  @override
  ConsumerState<AdminManageTurfsScreen> createState() => _AdminManageTurfsScreenState();
}

class _AdminManageTurfsScreenState extends ConsumerState<AdminManageTurfsScreen> with TickerProviderStateMixin {
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
    _fetchMyTurfs();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _fetchMyTurfs() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _api.get("/turfs/my");
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
        _errorMessage = "Failed to load your turfs: $e";
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
              backgroundColor: DesignSystem.error,
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
          backgroundColor: DesignSystem.success,
        ),
      );

      _fetchMyTurfs();
    } catch (e) {
      String errorMessage = "Failed to delete turf";

      if (e is DioException) {
        if (e.response?.statusCode == 401) {
          errorMessage = "Your session has expired. Please login again.";
        } else if (e.response?.statusCode == 403) {
          errorMessage = "You don't have permission to delete this turf.";
        } else if (e.response?.statusCode == 404) {
          errorMessage = "Turf not found. It may have been already deleted.";
        } else if (e.response?.statusCode == 500) {
          errorMessage = "Server error. Please try again later.";
        } else {
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
          backgroundColor: DesignSystem.error,
        ),
      );

      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignSystem.backgroundLavender,
      appBar: AppBar(
        title: const Text("Manage Your Turfs"),
        backgroundColor: DesignSystem.primaryIndigo,
        foregroundColor: DesignSystem.textWhite,
        elevation: DesignSystem.elevation0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: DesignSystem.textWhite),
            onPressed: _fetchMyTurfs,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTurfDetailsScreen()),
          );
          _fetchMyTurfs();
        },
        backgroundColor: DesignSystem.primaryIndigo,
        child: Icon(Icons.add, color: DesignSystem.textWhite),
      ),
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
          : _buildTurfsList(),
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
              onPressed: _fetchMyTurfs,
              child: Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
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
                Icons.location_city_outlined,
                size: DesignSystem.iconXLarge,
                color: DesignSystem.primaryIndigo,
              ),
            ),
            DesignSystem.gap16,
            Text(
              "No turfs yet",
              style: DesignSystem.headline4,
              textAlign: TextAlign.center,
            ),
            DesignSystem.gap8,
            Text(
              "Create your first turf to get started",
              style: DesignSystem.bodyMedium.copyWith(color: DesignSystem.textSecondary),
              textAlign: TextAlign.center,
            ),
            DesignSystem.gap24,
            ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddTurfDetailsScreen()),
                );
                _fetchMyTurfs();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: DesignSystem.primaryIndigo,
                shape: DesignSystem.buttonShape,
              ),
              child: Text("Create First Turf", style: DesignSystem.button),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTurfsList() {
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
                              _fetchMyTurfs();
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
}
