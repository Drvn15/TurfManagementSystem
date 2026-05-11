import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart'; // Fixed path
import 'turf_controller.dart';
import 'user_sport_list_screen.dart';

class TurfDetailScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> turf;

  const TurfDetailScreen({super.key, required this.turf});

  @override
  ConsumerState<TurfDetailScreen> createState() => _TurfDetailScreenState();
}

class _TurfDetailScreenState extends ConsumerState<TurfDetailScreen> {
  late Map<String, dynamic> _currentTurf;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentTurf = widget.turf;
    _refreshTurfData();
  }

  Future<void> _refreshTurfData() async {
    setState(() => _isLoading = true);

    try {
      final refreshedTurf = await ref.read(turfControllerProvider.notifier).refreshTurf(widget.turf['id']);
      if (refreshedTurf != null && mounted) {
        setState(() {
          _currentTurf = refreshedTurf;
        });
      }
    } catch (e) {
      print("Error refreshing turf data: $e");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentTurf['name'] ?? 'Turf Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshTurfData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshTurfData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 220,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: DesignSystem.backgroundWhite,
                          boxShadow: DesignSystem.shadowMedium,
                        ),
                        child: _currentTurf['image_url'] != null &&
                                _currentTurf['image_url'].toString().isNotEmpty
                            ? Image.network(
                                _currentTurf['image_url'],
                                fit: BoxFit.cover,
                              )
                            : Center(
                                child: Icon(
                                  Icons.sports_soccer,
                                  size: 80,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _currentTurf['name'] ?? '',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.grey, size: 20),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            _currentTurf['location'] ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.grey.shade700),
                          ),
                        ),
                      ],
                    ),
                    if (_currentTurf['description'] != null &&
                        _currentTurf['description'].toString().isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: DesignSystem.backgroundWhite,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: DesignSystem.shadowSmall,
                        ),
                        child: Text(
                          _currentTurf['description'],
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: DesignSystem.backgroundWhite,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: DesignSystem.shadowSmall,
                      ),
                      child: Text(
                        '₹${_currentTurf['price_per_hour'] ?? 0}/hour',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: DesignSystem.primaryIndigo,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => UserSportListScreen(turf: _currentTurf),
                            ),
                          );
                        },
                        child: const Text('Select Sport'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
