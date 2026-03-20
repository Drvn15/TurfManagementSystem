class BookingModel {
  final String id;
  final String turfName;
  final String date;
  final String startTime;
  final String endTime;
  final String status;

  BookingModel({
    required this.id,
    required this.turfName,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'].toString(), // 🔥 Fix here
      turfName: json['turf_name'] ?? '',
      date: json['date'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
