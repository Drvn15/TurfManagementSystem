import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/design_system.dart';
import '../../core/widgets/premium_widgets.dart';
import 'turf_controller.dart';
import 'user_sport_list_screen.dart';

class TurfDetailScreen extends ConsumerStatefulWidget {
  const TurfDetailScreen({
    super.key,
    required this.turf,
  });

  final Map<String, dynamic> turf;

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
      final refreshedTurf = await ref
          .read(turfControllerProvider.notifier)
          .refreshTurf(widget.turf['id']);

      if (refreshedTurf != null && mounted) {
        setState(() {
          _currentTurf = refreshedTurf;
        });
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to refresh venue details.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = DesignSystem.paletteOf(context);
    final imageUrl = (_currentTurf['image_url'] ?? '').toString();

    return PremiumScaffold(
      appBar: AppBar(
        title: Text(_currentTurf['name'] ?? 'Venue Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _refreshTurfData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshTurfData,
              color: palette.primary,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: DesignSystem.borderRadiusXLarge,
                      child: SizedBox(
                        height: 240,
                        width: double.infinity,
                        child: imageUrl.isNotEmpty
                            ? Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => _FallbackHero(
                                  icon: Icons.sports_soccer_rounded,
                                ),
                              )
                            : const _FallbackHero(
                                icon: Icons.sports_soccer_rounded,
                              ),
                      ),
                    ),
                    const SizedBox(height: DesignSystem.spacing20),
                    GlassCard(
                      borderRadius: DesignSystem.borderRadiusXLarge,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _currentTurf['name'] ?? 'Unnamed venue',
                            style: DesignSystem.headline2.copyWith(
                              color: palette.textPrimary,
                            ),
                          ),
                          const SizedBox(height: DesignSystem.spacing12),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: palette.primary,
                                size: 18,
                              ),
                              const SizedBox(width: DesignSystem.spacing8),
                              Expanded(
                                child: Text(
                                  _currentTurf['location'] ?? 'Location pending',
                                  style: DesignSystem.bodyMedium.copyWith(
                                    color: palette.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if ((_currentTurf['description'] ?? '')
                              .toString()
                              .trim()
                              .isNotEmpty) ...[
                            const SizedBox(height: DesignSystem.spacing16),
                            Text(
                              _currentTurf['description'],
                              style: DesignSystem.bodyLarge.copyWith(
                                color: palette.textPrimary,
                              ),
                            ),
                          ],
                          const SizedBox(height: DesignSystem.spacing20),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: palette.overlaySoft,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              'Rs ${_currentTurf['price_per_hour'] ?? 0}/hour',
                              style: DesignSystem.bodyLarge.copyWith(
                                color: palette.primary,
                                fontWeight: DesignSystem.fontWeightSemiBold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: DesignSystem.spacing20),
                    GlowButton(
                      label: 'Select Sport',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => UserSportListScreen(turf: _currentTurf),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _FallbackHero extends StatelessWidget {
  const _FallbackHero({
    required this.icon,
  });

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final palette = DesignSystem.paletteOf(context);

    return DecoratedBox(
      decoration: BoxDecoration(gradient: palette.primaryGradient),
      child: Center(
        child: Icon(
          icon,
          size: 72,
          color: palette.textWhite,
        ),
      ),
    );
  }
}
