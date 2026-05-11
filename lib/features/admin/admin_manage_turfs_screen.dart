import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/api_client.dart';
import '../../core/theme/design_system.dart';
import '../../core/widgets/premium_widgets.dart';
import 'add_turf_details_screen.dart';
import 'edit_turf_screen.dart';
import 'sport_list_screen.dart';

class AdminManageTurfsScreen extends ConsumerStatefulWidget {
  const AdminManageTurfsScreen({super.key});

  @override
  ConsumerState<AdminManageTurfsScreen> createState() =>
      _AdminManageTurfsScreenState();
}

class _AdminManageTurfsScreenState
    extends ConsumerState<AdminManageTurfsScreen>
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
      final response = await _api.get('/turfs/my');
      setState(() {
        _turfs = response is List ? response : [];
        _isLoading = false;
      });
      _fadeController.forward(from: 0);
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load your turfs: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteTurf(int turfId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Turf'),
        content: const Text(
          'Are you sure you want to delete this turf? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);

    try {
      await _api.delete('/turfs/$turfId');

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Turf deleted successfully')),
      );
      _fetchMyTurfs();
    } catch (e) {
      var errorMessage = 'Failed to delete turf';

      if (e is DioException) {
        if (e.response?.statusCode == 403) {
          errorMessage = 'You do not have permission to delete this turf.';
        } else if (e.response?.statusCode == 404) {
          errorMessage = 'Turf not found. It may already be deleted.';
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
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = DesignSystem.paletteOf(context);

    return PremiumScaffold(
      appBar: AppBar(
        title: const Text('Manage Your Turfs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
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
        backgroundColor: palette.primary,
        foregroundColor:
            DesignSystem.isDark(context) ? palette.backgroundBase : palette.textWhite,
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Padding(
                  padding: DesignSystem.paddingAll24,
                  child: PremiumEmptyState(
                    title: 'Could not load your venues',
                    message: _errorMessage!,
                    action: SizedBox(
                      width: 180,
                      child: GlowButton(
                        label: 'Retry',
                        onPressed: _fetchMyTurfs,
                      ),
                    ),
                  ),
                )
              : _turfs.isEmpty
                  ? Padding(
                      padding: DesignSystem.paddingAll24,
                      child: PremiumEmptyState(
                        title: 'No turfs yet',
                        message: 'Create your first turf to start publishing venues.',
                        action: SizedBox(
                          width: 220,
                          child: GlowButton(
                            label: 'Create First Turf',
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AddTurfDetailsScreen(),
                                ),
                              );
                              _fetchMyTurfs();
                            },
                          ),
                        ),
                      ),
                    )
                  : FadeTransition(
                      opacity: _fadeAnimation,
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                        itemCount: _turfs.length,
                        itemBuilder: (context, index) {
                          final turf = _turfs[index];
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: DesignSystem.spacing16,
                            ),
                            child: GlassCard(
                              padding: const EdgeInsets.all(16),
                              borderRadius: DesignSystem.borderRadiusLarge,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              turf['name'] ?? 'Unnamed Turf',
                                              style: DesignSystem.headline4.copyWith(
                                                color: palette.textPrimary,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: DesignSystem.spacing8,
                                            ),
                                            Text(
                                              turf['location'] ??
                                                  'No location set',
                                              style: DesignSystem.bodyMedium.copyWith(
                                                color: palette.textSecondary,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: DesignSystem.spacing12,
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 6,
                                              ),
                                              decoration: BoxDecoration(
                                                color: palette.overlaySoft,
                                                borderRadius:
                                                    BorderRadius.circular(999),
                                              ),
                                              child: Text(
                                                'Rs ${turf['price_per_hour'] ?? 0}/hour',
                                                style:
                                                    DesignSystem.bodyMedium.copyWith(
                                                  color: palette.primary,
                                                  fontWeight: DesignSystem
                                                      .fontWeightSemiBold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              Icons.edit_rounded,
                                              color: palette.primary,
                                            ),
                                            onPressed: () async {
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      EditTurfScreen(turf: turf),
                                                ),
                                              );
                                              _fetchMyTurfs();
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.delete_outline_rounded,
                                              color: palette.error,
                                            ),
                                            onPressed: () => _deleteTurf(turf['id']),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: DesignSystem.spacing16),
                                  OutlinedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => SportListScreen(turf: turf),
                                        ),
                                      );
                                    },
                                    child: const Text('Manage Sports'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}
