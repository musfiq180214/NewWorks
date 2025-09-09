class AttendanceTime {
  AttendanceTime({
    required this.success,
    required this.message,
    required this.status,
    required this.data,
  });

  final bool success;
  final String message;
  final int status;
  final List<AttendanceTimeData> data;

  factory AttendanceTime.fromJson(Map<String, dynamic> json) {
    return AttendanceTime(
      success: json['success'] as bool,
      message: json['message'] as String,
      status: json['status'] as int,
      data: (json['data'] as List<dynamic>)
          .map((e) => AttendanceTimeData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'status': status,
        'data': data.map((e) => e.toJson()).toList(),
      };
}

class AttendanceTimeData {
  AttendanceTimeData({
    required this.id,
    required this.name,
    required this.avgInTime,
    required this.avgOutTime,
    required this.avgDuration,
  });

  final String id;
  final String name;
  final String avgInTime;
  final String avgOutTime;
  final String avgDuration;

  factory AttendanceTimeData.fromJson(Map<String, dynamic> json) {
    return AttendanceTimeData(
      id: json['id'] as String,
      name: json['name'] as String,
      avgInTime: json['avg_in_time'] ?? '-',
      avgOutTime: json['avg_out_time'] ?? '-',
      avgDuration: json['avg_duration'] ?? '-',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'avg_in_time': avgInTime,
        'avg_out_time': avgOutTime,
        'avg_duration': avgDuration,
      };
}
