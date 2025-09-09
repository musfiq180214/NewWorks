class AttendanceModel {
  AttendanceModel({
    required this.success,
    required this.message,
    required this.status,
    required this.data,
  });

  final bool success;
  final String message;
  final int status;
  final List<AttendanceModelData> data;

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      status: json['status'] as int,
      data: (json['data'] as List<dynamic>)
          .map((e) => AttendanceModelData.fromJson(e as Map<String, dynamic>))
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

class AttendanceModelData {
  AttendanceModelData({
    required this.id,
    required this.employeeId,
    required this.name,
    required this.empDeviceId,
    required this.date,
    required this.inTime,
    required this.outTime,
    required this.duration,
  });

  final String id;
  final int employeeId;
  final String name;
  final int empDeviceId;
  final String date;
  final String inTime;
  final String outTime;
  final String duration;

  factory AttendanceModelData.fromJson(Map<String, dynamic> json) {
    return AttendanceModelData(
      id: json['id'] as String,
      employeeId: json['employee_id'] as int,
      name: json['name'] as String,
      empDeviceId: json['emp_device_id'] as int,
      date: json['date'] as String,
      inTime: json['in_time'] as String,
      outTime: json['out_time'] as String,
      duration: json['duration'] as String,
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
      };
}
