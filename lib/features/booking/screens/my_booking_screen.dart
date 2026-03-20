import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../booking_controller.dart';
import '../booking_state.dart';

class MyBookingsScreen extends ConsumerStatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  ConsumerState<MyBookingsScreen> createState() =>
      _MyBookingsScreenState();
}

class _MyBookingsScreenState
    extends ConsumerState<MyBookingsScreen> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        ref.read(bookingControllerProvider.notifier)
            .fetchMyBookings());
  }

  Future<void> _refresh() async {
    await ref
        .read(bookingControllerProvider.notifier)
        .fetchMyBookings();
  }

  Future<void> _confirmCancel(String bookingId) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Cancel Booking"),
        content: Text(
          "Are you sure you want to cancel this booking?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("No"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              await ref
                  .read(bookingControllerProvider.notifier)
                  .cancelBooking(bookingId);

              await _refresh();

              ScaffoldMessenger.of(context)
                  .showSnackBar(
                const SnackBar(
                  content: Text(
                      "Booking cancelled successfully"),
                ),
              );
            },
            child: Text("Yes"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookingControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("My Bookings"),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Builder(
          builder: (context) {

            if (state.status == BookingStatus.loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state.bookings.isEmpty) {
              return Center(
                child: Text("No bookings found"),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.bookings.length,
              itemBuilder: (context, index) {
                final booking =
                state.bookings[index];

                final isConfirmed =
                    booking.status == "CONFIRMED";

                return GestureDetector(
                  onTap: isConfirmed
                      ? () => _confirmCancel(
                      booking.id)
                      : null,
                  child: Card(
                    margin: const EdgeInsets.only(
                        bottom: 12),
                    child: Padding(
                      padding:
                      const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                        children: [
                          Text(
                            booking.turfName,
                            style:
                            const TextStyle(
                              fontSize: 16,
                              fontWeight:
                              FontWeight
                                  .w600,
                            ),
                          ),
                          SizedBox(
                              height: 6),
                          Text(
                            "${booking.date} | ${booking.startTime} - ${booking.endTime}",
                          ),
                          SizedBox(
                              height: 6),
                          Text(
                            "Status: ${booking.status}",
                            style: TextStyle(
                              color: isConfirmed
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight:
                              FontWeight
                                  .w600,
                            ),
                          ),
                          if (isConfirmed)
                            Padding(
                              padding:
                              EdgeInsets.only(
                                  top: 8),
                              child: Text(
                                "Tap to cancel",
                                style:
                                TextStyle(
                                  fontSize: 12,
                                  color: Colors
                                      .grey,
                                ),
                              ),
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
      ),
    );
  }
}

