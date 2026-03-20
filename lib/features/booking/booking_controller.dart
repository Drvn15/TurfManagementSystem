import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api/api_client.dart';
import 'booking_state.dart';
import 'slot_model.dart';
import 'booking_model.dart';

final bookingControllerProvider = StateNotifierProvider<BookingController, BookingState>(
      (ref) => BookingController(),
);

class BookingController extends StateNotifier<BookingState> {
  BookingController() : super(BookingState.initial());

  final ApiClient _api = ApiClient();

  // ============================
  // FETCH AVAILABILITY BY COURT
  // ============================
  Future<List<Slot>> fetchAvailabilityByCourt({
    required String courtId,
    required String date,
  }) async {
    try {
      print("📅 Fetching availability for court: $courtId on $date");

      final response = await _api.get(
        "/bookings/availability/$courtId?date=$date",
      );

      print("✅ Availability response: $response");

      if (response is Map && response['slots'] != null) {
        final slots = (response['slots'] as List)
            .map((s) => Slot.fromJson(s))
            .toList();

        print("✅ Found ${slots.length} slots");
        return slots;
      } else {
        print("⚠️ Unexpected response format: $response");
        return [];
      }
    } catch (e) {
      print("❌ Error fetching availability: $e");
      rethrow;
    }
  }

  // ============================
  // CREATE BOOKING
  // ============================
  Future<void> createBooking({
    required String courtId,
    required String date,
    required String startTime,
    required String endTime,
  }) async {
    state = state.copyWith(status: BookingStatus.loading);

    try {
      print("📝 Creating booking for court: $courtId");
      print("   Date: $date, Time: $startTime - $endTime");

      final response = await _api.post(
        "/bookings",
        body: {
          "court_id": courtId,
          "date": date,
          "start_time": startTime,
          "end_time": endTime,
        },
      );

      print("✅ Booking created successfully: $response");

      state = state.copyWith(
        status: BookingStatus.success,
        message: "Booking successful",
      );

      // Refresh my bookings after successful booking
      await fetchMyBookings();

    } catch (e) {
      print("❌ Error creating booking: $e");

      state = state.copyWith(
        status: BookingStatus.error,
        message: e.toString(),
      );
    }
  }

  // ============================
  // FETCH MY BOOKINGS
  // ============================
  Future<void> fetchMyBookings() async {
    state = state.copyWith(status: BookingStatus.loading);

    try {
      print("📋 Fetching user bookings");

      final response = await _api.get("/bookings/my");

      print("✅ Bookings response: $response");

      List<BookingModel> bookings = [];

      if (response is List) {
        bookings = response
            .map((b) => BookingModel.fromJson(b))
            .toList();
      }

      print("✅ Found ${bookings.length} bookings");

      state = state.copyWith(
        status: BookingStatus.success,
        bookings: bookings,
      );

    } catch (e) {
      print("❌ Error fetching bookings: $e");

      state = state.copyWith(
        status: BookingStatus.error,
        message: e.toString(),
      );
    }
  }

  // ============================
  // CANCEL BOOKING
  // ============================
  Future<void> cancelBooking(String bookingId) async {
    state = state.copyWith(status: BookingStatus.loading);

    try {
      print("🗑️ Cancelling booking: $bookingId");

      await _api.patch("/bookings/$bookingId/cancel");

      print("✅ Booking cancelled successfully");

      // Refresh the list after cancellation
      await fetchMyBookings();

      state = state.copyWith(
        status: BookingStatus.success,
        message: "Booking cancelled",
      );

    } catch (e) {
      print("❌ Error cancelling booking: $e");

      state = state.copyWith(
        status: BookingStatus.error,
        message: e.toString(),
      );
    }
  }

  // ============================
  // CLEAR MESSAGE
  // ============================
  void clearMessage() {
    state = state.copyWith(message: null);

  }
}