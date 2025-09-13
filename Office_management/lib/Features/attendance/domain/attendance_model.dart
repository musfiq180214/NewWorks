class Attendance {
  final String id;
  final int employeeId;
  final String name;
  final int empDeviceId;
  final String date;
  final String inTime;
  final String outTime;
  final String duration;
  final String status;

  Attendance({
    required this.id,
    required this.employeeId,
    required this.name,
    required this.empDeviceId,
    required this.date,
    required this.inTime,
    required this.outTime,
    required this.duration,
    required this.status,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'] ?? '',
      employeeId: json['employee_id'] ?? 0,
      name: json['name'] ?? '',
      empDeviceId: json['emp_device_id'] ?? 0,
      date: json['date'] ?? '',
      inTime: json['in_time'] ?? '',
      outTime: json['out_time'] ?? '',
      duration: json['duration'] ?? '',
      status: json['status'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'employee_id': employeeId,
    'name': name,
    'emp_device_id': empDeviceId,
    'date': date,
    'in_time': inTime,
    'out_time': outTime,
    'duration': duration,
    'status': status,
  };
}
