import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'booking_controller.dart';
import 'slot_model.dart';
import 'booking_state.dart';
import '../../core/theme/app_theme.dart';  // Make sure this import exists

class SlotSelectionScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> court;
  final String turfName;
  final String sportName;

  const SlotSelectionScreen({
    super.key,
    required this.court,
    required this.turfName,
    required this.sportName,
  });

  @override
  ConsumerState<SlotSelectionScreen> createState() => _SlotSelectionScreenState();
}

class _SlotSelectionScreenState extends ConsumerState<SlotSelectionScreen> {
  late Future<List<Slot>> _availabilityFuture;
  DateTime selectedDate = DateTime.now();
  String? _errorMessage;

  String get formattedDate => selectedDate.toIso8601String().split("T").first;
  String get courtId => widget.court['id'].toString();
  String get courtName => widget.court['name'] ?? 'Court';
  String get courtPrice => widget.court['price']?.toString() ?? '0';

  @override
  void initState() {
    super.initState();
    _loadAvailability();
  }

  void _loadAvailability() {
    setState(() {
      _errorMessage = null;
      _availabilityFuture = ref
          .read(bookingControllerProvider.notifier)
          .fetchAvailabilityByCourt(
        courtId: courtId,
        date: formattedDate,
      );
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.purplePrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
      _loadAvailability();
    }
  }

  void _confirmBooking(BuildContext context, Slot slot) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Booking"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Court: ${widget.court['name']}"),
            SizedBox(height: 4),
            Text("Date: $formattedDate"),
            Text("Time: ${slot.startTime} - ${slot.endTime}"),
            SizedBox(height: 8),
            Text(
              "Price: ₹$courtPrice",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.purplePrimary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              await ref
                  .read(bookingControllerProvider.notifier)
                  .createBooking(
                courtId: courtId,
                date: formattedDate,
                startTime: slot.startTime,
                endTime: slot.endTime,
              );

              final bookingState = ref.read(bookingControllerProvider);

              if (bookingState.status == BookingStatus.success) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Booking successful!"),
                    backgroundColor: Colors.green,
                  ),
                );

                _loadAvailability();
              } else if (bookingState.status == BookingStatus.error) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(bookingState.message ?? "Booking failed"),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.purplePrimary,
            ),
            child: Text("Confirm"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(courtName),
        backgroundColor: AppTheme.purplePrimary,
      ),
      body: Column(
        children: [
          // Court Info Card
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.purpleLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.purplePrimary.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.court['slot_type'] == 'hourly' ? 'Hourly Slots' : '30-min Slots',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "₹$courtPrice",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.purplePrimary,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatTime(widget.court['morning_start']),
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text("Morning"),
                    Text(
                      _formatTime(widget.court['evening_start']),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Turf & Sport Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.purpleLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    widget.turfName,
                    style: TextStyle(
                      color: AppTheme.purplePrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    widget.sportName,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16),

          // Date Selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 20, color: Colors.grey),
                    SizedBox(width: 8),
                    Text(
                      formattedDate,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: _pickDate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.purplePrimary,
                  ),
                  child: Text("Change Date"),
                ),
              ],
            ),
          ),

          SizedBox(height: 16),

          // Error Message (if any)
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red.shade700),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red.shade700),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          SizedBox(height: 8),

          // Slots Grid
          Expanded(
            child: FutureBuilder<List<Slot>>(
              future: _availabilityFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 48, color: Colors.red),
                        SizedBox(height: 16),
                        Text(
                          "Failed to load availability",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 8),
                        Text(
                          snapshot.error.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadAvailability,
                          child: Text("Retry"),
                        ),
                      ],
                    ),
                  );
                }

                final slots = snapshot.data ?? [];

                if (slots.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_busy, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          "No slots available",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Try selecting a different date",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: slots.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 3,
                  ),
                  itemBuilder: (context, index) {
                    final slot = slots[index];

                    return OutlinedButton(
                      onPressed: slot.available
                          ? () => _confirmBooking(context, slot)
                          : null,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: slot.available
                            ? AppTheme.purpleLight
                            : Colors.grey[300],
                        side: BorderSide(
                          color: slot.available
                              ? AppTheme.purplePrimary
                              : Colors.grey,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "${slot.startTime} - ${slot.endTime}",
                        style: TextStyle(
                          color: slot.available
                              ? AppTheme.purplePrimary
                              : Colors.grey,
                          fontWeight: slot.available ? FontWeight.w600 : FontWeight.normal,
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

  String _formatTime(String? time) {
    if (time == null || time.isEmpty) return '00:00';
    if (time.length >= 5) {
      return time.substring(0, 5);
    }
    return time;
  }
}
