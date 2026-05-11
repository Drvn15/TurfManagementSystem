import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/design_system.dart';
import '../../../core/widgets/premium_widgets.dart';
import '../booking_controller.dart';
import '../booking_state.dart';

class MyBookingsScreen extends ConsumerStatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  ConsumerState<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends ConsumerState<MyBookingsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(bookingControllerProvider.notifier).fetchMyBookings(),
    );
  }

  Future<void> _refresh() async {
    await ref.read(bookingControllerProvider.notifier).fetchMyBookings();
  }

  Future<void> _confirmCancel(String bookingId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: const Text('Are you sure you want to cancel this booking?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (confirmed != true) {
      return;
    }

    await ref.read(bookingControllerProvider.notifier).cancelBooking(bookingId);
    await _refresh();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Booking cancelled successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookingControllerProvider);
    final palette = DesignSystem.paletteOf(context);

    return PremiumScaffold(
      appBar: AppBar(title: const Text('My Bookings')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: palette.primary,
        child: Builder(
          builder: (context) {
            if (state.status == BookingStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.bookings.isEmpty) {
              return const Padding(
                padding: DesignSystem.paddingAll24,
                child: PremiumEmptyState(
                  title: 'No bookings yet',
                  message:
                      'Your confirmed and upcoming bookings will appear here.',
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              itemCount: state.bookings.length,
              itemBuilder: (context, index) {
                final booking = state.bookings[index];
                final isConfirmed = booking.status == 'CONFIRMED';

                return Padding(
                  padding: const EdgeInsets.only(bottom: DesignSystem.spacing16),
                  child: GlassCard(
                    padding: const EdgeInsets.all(16),
                    borderRadius: DesignSystem.borderRadiusLarge,
                    child: InkWell(
                      onTap:
                          isConfirmed ? () => _confirmCancel(booking.id) : null,
                      borderRadius: DesignSystem.borderRadiusLarge,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  booking.turfName,
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
                                  color: (isConfirmed
                                          ? palette.success
                                          : palette.error)
                                      .withValues(alpha: 0.14),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  booking.status,
                                  style: DesignSystem.bodySmall.copyWith(
                                    color: isConfirmed
                                        ? palette.success
                                        : palette.error,
                                    fontWeight: DesignSystem.fontWeightSemiBold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: DesignSystem.spacing12),
                          Text(
                            '${booking.date} | ${booking.startTime} - ${booking.endTime}',
                            style: DesignSystem.bodyMedium.copyWith(
                              color: palette.textSecondary,
                            ),
                          ),
                          if (isConfirmed) ...[
                            const SizedBox(height: DesignSystem.spacing12),
                            Text(
                              'Tap this booking card to cancel it.',
                              style: DesignSystem.bodySmall.copyWith(
                                color: palette.textMuted,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
