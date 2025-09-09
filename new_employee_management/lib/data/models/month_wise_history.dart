class MonthWiseHistoryModel {
  MonthWiseHistoryModel({
    required this.success,
    required this.message,
    required this.status,
    required this.data,
  });

  bool success;
  String message;
  int status;
  List<MonthWiseHistoryModelData> data;

  factory MonthWiseHistoryModel.fromJson(Map<String, dynamic> json) {
    return MonthWiseHistoryModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      status: json['status'] as int,
      data: (json['data'] as List)
          .map((e) => MonthWiseHistoryModelData.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'status': status,
        'data': data.map((e) => e.toJson()).toList(), // ✅ correct
      };
}

class MonthWiseHistoryModelData {
  MonthWiseHistoryModelData({
    required this.id,
    required this.employeeId,
    required this.name,
    required this.empDeviceId,
    required this.date,
    required this.inTime,
    required this.outTime,
    required this.duration,
  });

  String id;
  int employeeId;
  String name;
  int empDeviceId;
  String date;
  String inTime;
  String outTime;
  String duration;

  factory MonthWiseHistoryModelData.fromJson(Map<String, dynamic> json) {
    return MonthWiseHistoryModelData(
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
