import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/api_client.dart';
import '../../core/theme/design_system.dart';
import '../../core/widgets/premium_widgets.dart';
import 'user_court_list_screen.dart';

class UserSportListScreen extends ConsumerStatefulWidget {
  const UserSportListScreen({
    super.key,
    required this.turf,
  });

  final Map<String, dynamic> turf;

  @override
  ConsumerState<UserSportListScreen> createState() => _UserSportListScreenState();
}

class _UserSportListScreenState extends ConsumerState<UserSportListScreen> {
  final ApiClient _api = ApiClient();
  late Future<List<dynamic>> _sportsFuture;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchSports();
  }

  void _fetchSports() {
    setState(() {
      _errorMessage = null;
      _sportsFuture = _api.get("/sports/${widget.turf['id']}").then((response) {
        return response is List ? response : <dynamic>[];
      }).catchError((error) {
        _errorMessage = error.toString();
        return <dynamic>[];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = DesignSystem.paletteOf(context);

    return PremiumScaffold(
      appBar: AppBar(
        title: Text(widget.turf['name'] ?? 'Select Sport'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _sportsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || _errorMessage != null) {
            return Padding(
              padding: DesignSystem.paddingAll24,
              child: PremiumEmptyState(
                title: 'Unable to load sports',
                message: _errorMessage ?? snapshot.error.toString(),
                action: SizedBox(
                  width: 170,
                  child: GlowButton(
                    label: 'Retry',
                    onPressed: _fetchSports,
                  ),
                ),
              ),
            );
          }

          final sports = snapshot.data ?? [];
          if (sports.isEmpty) {
            return const Padding(
              padding: DesignSystem.paddingAll24,
              child: PremiumEmptyState(
                title: 'No sports available',
                message: 'This venue has not published sport categories yet.',
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.92,
            ),
            itemCount: sports.length,
            itemBuilder: (context, index) {
              final sport = sports[index];
              return GlassCard(
                borderRadius: DesignSystem.borderRadiusLarge,
                padding: const EdgeInsets.all(14),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UserCourtListScreen(
                          sport: sport,
                          turfName: widget.turf['name'] ?? 'Venue',
                        ),
                      ),
                    );
                  },
                  borderRadius: DesignSystem.borderRadiusLarge,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: palette.overlayStrong,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _iconForSport(sport['name']?.toString() ?? ''),
                          color: palette.primary,
                          size: 28,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        sport['name'] ?? 'Sport',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: DesignSystem.headline5.copyWith(
                          color: palette.textPrimary,
                        ),
                      ),
                      const SizedBox(height: DesignSystem.spacing8),
                      Text(
                        'View available courts and live slots',
                        style: DesignSystem.bodySmall.copyWith(
                          color: palette.textSecondary,
                        ),
                      ),
                      const SizedBox(height: DesignSystem.spacing12),
                      Row(
                        children: [
                          Text(
                            'Open',
                            style: DesignSystem.bodyMedium.copyWith(
                              color: palette.primary,
                              fontWeight: DesignSystem.fontWeightSemiBold,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: palette.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  IconData _iconForSport(String name) {
    final normalized = name.toLowerCase();
    if (normalized.contains('cricket')) return Icons.sports_cricket;
    if (normalized.contains('football')) return Icons.sports_soccer;
    if (normalized.contains('basketball')) return Icons.sports_basketball;
    return Icons.sports_tennis;
  }
}
