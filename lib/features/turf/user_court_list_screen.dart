import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/api_client.dart';
import '../../core/theme/design_system.dart';
import '../../core/widgets/premium_widgets.dart';
import '../booking/slot_selection_screen.dart';

class UserCourtListScreen extends ConsumerStatefulWidget {
  const UserCourtListScreen({
    super.key,
    required this.sport,
    required this.turfName,
  });

  final Map<String, dynamic> sport;
  final String turfName;

  @override
  ConsumerState<UserCourtListScreen> createState() => _UserCourtListScreenState();
}

class _UserCourtListScreenState extends ConsumerState<UserCourtListScreen> {
  final ApiClient _api = ApiClient();
  late Future<List<dynamic>> _courtsFuture;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchCourts();
  }

  void _fetchCourts() {
    setState(() {
      _errorMessage = null;
      _courtsFuture = _api.get("/courts/${widget.sport['id']}").then((response) {
        return response is List ? response : <dynamic>[];
      }).catchError((error) {
        _errorMessage = error.toString();
        return <dynamic>[];
      });
    });
  }

  String _formatTime(String? time) {
    if (time == null || time.isEmpty) return 'Not set';
    return time.length >= 5 ? time.substring(0, 5) : time;
  }

  @override
  Widget build(BuildContext context) {
    final palette = DesignSystem.paletteOf(context);

    return PremiumScaffold(
      appBar: AppBar(
        title: Text('${widget.sport['name']} Courts'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _courtsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || _errorMessage != null) {
            return Padding(
              padding: DesignSystem.paddingAll24,
              child: PremiumEmptyState(
                title: 'Unable to load courts',
                message: _errorMessage ?? snapshot.error.toString(),
                action: SizedBox(
                  width: 170,
                  child: GlowButton(
                    label: 'Retry',
                    onPressed: _fetchCourts,
                  ),
                ),
              ),
            );
          }

          final courts = snapshot.data ?? [];
          if (courts.isEmpty) {
            return const Padding(
              padding: DesignSystem.paddingAll24,
              child: PremiumEmptyState(
                title: 'No courts available',
                message:
                    'This sport has not been configured with playable courts yet.',
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            itemCount: courts.length,
            itemBuilder: (context, index) {
              final court = courts[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: DesignSystem.spacing16),
                child: GlassCard(
                  padding: const EdgeInsets.all(16),
                  borderRadius: DesignSystem.borderRadiusLarge,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SlotSelectionScreen(
                            court: court,
                            turfName: widget.turfName,
                            sportName: widget.sport['name'] ?? 'Sport',
                          ),
                        ),
                      );
                    },
                    borderRadius: DesignSystem.borderRadiusLarge,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                court['name'] ?? 'Court',
                                style: DesignSystem.headline5.copyWith(
                                  color: palette.textPrimary,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: palette.overlaySoft,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                'Rs ${court['price'] ?? 0}',
                                style: DesignSystem.bodyMedium.copyWith(
                                  color: palette.primary,
                                  fontWeight: DesignSystem.fontWeightSemiBold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: DesignSystem.spacing12),
                        Wrap(
                          spacing: DesignSystem.spacing8,
                          runSpacing: DesignSystem.spacing8,
                          children: [
                            _CourtBadge(text: '${court['slot_type'] ?? 'hourly'} slots'),
                            _CourtBadge(
                              icon: Icons.wb_sunny_outlined,
                              text:
                                  '${_formatTime(court['morning_start'])} - ${_formatTime(court['morning_end'])}',
                            ),
                            _CourtBadge(
                              icon: Icons.nightlight_round,
                              text:
                                  '${_formatTime(court['evening_start'])} - ${_formatTime(court['evening_end'])}',
                            ),
                          ],
                        ),
                        const SizedBox(height: DesignSystem.spacing16),
                        Row(
                          children: [
                            Text(
                              'View slots',
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _CourtBadge extends StatelessWidget {
  const _CourtBadge({
    required this.text,
    this.icon,
  });

  final String text;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final palette = DesignSystem.paletteOf(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: palette.overlaySoft,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: palette.glassBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: palette.primary),
            const SizedBox(width: DesignSystem.spacing6),
          ],
          Text(
            text,
            style: DesignSystem.bodySmall.copyWith(
              color: palette.textPrimary,
              fontWeight: DesignSystem.fontWeightMedium,
            ),
          ),
        ],
      ),
    );
  }
}
