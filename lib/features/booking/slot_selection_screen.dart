import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/design_system.dart';
import '../../core/widgets/premium_widgets.dart';
import 'booking_controller.dart';
import 'booking_state.dart';
import 'slot_model.dart';

class SlotSelectionScreen extends ConsumerStatefulWidget {
  const SlotSelectionScreen({
    super.key,
    required this.court,
    required this.turfName,
    required this.sportName,
  });

  final Map<String, dynamic> court;
  final String turfName;
  final String sportName;

  @override
  ConsumerState<SlotSelectionScreen> createState() => _SlotSelectionScreenState();
}

class _SlotSelectionScreenState extends ConsumerState<SlotSelectionScreen> {
  late Future<List<Slot>> _availabilityFuture;
  DateTime selectedDate = DateTime.now();

  String get formattedDate => selectedDate.toIso8601String().split('T').first;
  String get courtId => widget.court['id'].toString();
  String get courtName => widget.court['name']?.toString() ?? 'Court';
  String get courtPrice => widget.court['price']?.toString() ?? '0';

  @override
  void initState() {
    super.initState();
    _loadAvailability();
  }

  void _loadAvailability() {
    setState(() {
      _availabilityFuture = ref.read(bookingControllerProvider.notifier).fetchAvailabilityByCourt(
            courtId: courtId,
            date: formattedDate,
          );
    });
  }

  Future<void> _pickDate() async {
    final palette = DesignSystem.paletteOf(context);
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: palette.primary,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
      _loadAvailability();
    }
  }

  Future<void> _confirmBooking(BuildContext context, Slot slot) async {
    final palette = DesignSystem.paletteOf(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Booking'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Court: $courtName'),
            const SizedBox(height: DesignSystem.spacing4),
            Text('Date: $formattedDate'),
            Text('Time: ${slot.startTime} - ${slot.endTime}'),
            const SizedBox(height: DesignSystem.spacing8),
            Text(
              'Price: Rs $courtPrice',
              style: DesignSystem.bodyLarge.copyWith(
                color: palette.primary,
                fontWeight: DesignSystem.fontWeightSemiBold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed != true) {
      return;
    }

    await ref.read(bookingControllerProvider.notifier).createBooking(
          courtId: courtId,
          date: formattedDate,
          startTime: slot.startTime,
          endTime: slot.endTime,
        );

    final bookingState = ref.read(bookingControllerProvider);
    if (!mounted) return;

    if (bookingState.status == BookingStatus.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking successful!'),
          backgroundColor: Colors.green,
        ),
      );
      _loadAvailability();
    } else if (bookingState.status == BookingStatus.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(bookingState.message ?? 'Booking failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = DesignSystem.paletteOf(context);

    return PremiumScaffold(
      appBar: AppBar(title: Text(courtName)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: GlassCard(
              borderRadius: DesignSystem.borderRadiusLarge,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          courtName,
                          style: DesignSystem.headline4.copyWith(
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
                          'Rs $courtPrice',
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
                      _InfoChip(text: widget.turfName),
                      _InfoChip(text: widget.sportName),
                      _InfoChip(
                        icon: Icons.schedule_rounded,
                        text: widget.court['slot_type'] == 'hourly'
                            ? 'Hourly slots'
                            : '30 min slots',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              children: [
                Expanded(
                  child: GlassCard(
                    borderRadius: DesignSystem.borderRadiusLarge,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 18,
                          color: palette.primary,
                        ),
                        const SizedBox(width: DesignSystem.spacing8),
                        Text(
                          formattedDate,
                          style: DesignSystem.bodyLarge.copyWith(
                            color: palette.textPrimary,
                            fontWeight: DesignSystem.fontWeightSemiBold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: DesignSystem.spacing12),
                SizedBox(
                  width: 140,
                  child: OutlinedButton(
                    onPressed: _pickDate,
                    child: const Text('Change Date'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: DesignSystem.spacing16),
          Expanded(
            child: FutureBuilder<List<Slot>>(
              future: _availabilityFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Padding(
                    padding: DesignSystem.paddingAll24,
                    child: PremiumEmptyState(
                      title: 'Failed to load availability',
                      message: snapshot.error.toString(),
                      action: SizedBox(
                        width: 170,
                        child: GlowButton(
                          label: 'Retry',
                          onPressed: _loadAvailability,
                        ),
                      ),
                    ),
                  );
                }

                final slots = snapshot.data ?? [];
                if (slots.isEmpty) {
                  return const Padding(
                    padding: DesignSystem.paddingAll24,
                    child: PremiumEmptyState(
                      title: 'No slots available',
                      message: 'Try selecting another date for this court.',
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  itemCount: slots.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 2.8,
                  ),
                  itemBuilder: (context, index) {
                    final slot = slots[index];
                    return OutlinedButton(
                      onPressed: slot.available
                          ? () => _confirmBooking(context, slot)
                          : null,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: slot.available
                            ? palette.overlaySoft
                            : palette.surfaceGlass.withValues(alpha: 0.42),
                        side: BorderSide(
                          color: slot.available ? palette.primary : palette.border,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        '${slot.startTime} - ${slot.endTime}',
                        textAlign: TextAlign.center,
                        style: DesignSystem.bodyMedium.copyWith(
                          color:
                              slot.available ? palette.primary : palette.textMuted,
                          fontWeight: slot.available
                              ? DesignSystem.fontWeightSemiBold
                              : DesignSystem.fontWeightRegular,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
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
