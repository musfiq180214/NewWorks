class Attendance {
  final String id;
  final String date;
  final String status;

  Attendance({required this.id, required this.date, required this.status});

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id']?.toString() ?? '',
      date: json['date'] ?? json['created_at'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
