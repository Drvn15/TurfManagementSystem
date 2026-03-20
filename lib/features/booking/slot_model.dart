class Slot {
  final String startTime;
  final String endTime;
  final bool available;

  Slot({
    required this.startTime,
    required this.endTime,
    required this.available,
  });

  factory Slot.fromJson(Map<String, dynamic> json) {
    return Slot(
      startTime: json['start_time'].toString(),
      endTime: json['end_time'].toString(),
      available: json['available'] ?? false,
    );
  }

}
