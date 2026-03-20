import 'booking_model.dart';

enum BookingStatus {
  initial,
  loading,
  success,
  error,
}

class BookingState {
  final BookingStatus status;
  final String? message;
  final List<BookingModel> bookings;

  BookingState({
    required this.status,
    this.message,
    required this.bookings,
  });

  factory BookingState.initial() {
    return BookingState(status: BookingStatus.initial,bookings:[],);
  }
  BookingState copyWith({
    BookingStatus? status,
    String? message,
    List<BookingModel>? bookings,
  }) {
    return BookingState(
      status: status ?? this.status,
      message: message,
      bookings: bookings ?? this.bookings,
    );
  }
}

