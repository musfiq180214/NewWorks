class AverageTime {
  AverageTime({
    this.success,
    this.message,
    this.status,
    this.data,
  });

  bool? success;
  String? message;
  int? status;
  List<AverageTimeData>? data;

  factory AverageTime.fromJson(Map<String, dynamic> json) {
    return AverageTime(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      status: json['status'] as int?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => AverageTimeData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'status': status,
        'data': data?.map((e) => e.toJson()).toList(),
      };
}

class AverageTimeData {
  AverageTimeData({
    this.id,
    this.name,
    this.avgInTime,
    this.avgOutTime,
    this.avgDuration,
  });

  int? id;
  String? name;
  String? avgInTime;
  String? avgOutTime;
  String? avgDuration;

  factory AverageTimeData.fromJson(Map<String, dynamic> json) {
    return AverageTimeData(
      id: json['id'] as int?,
      name: json['name'] as String?,
      avgInTime: json['avg_in_time'] as String?,
      avgOutTime: json['avg_out_time'] as String?,
      avgDuration: json['avg_duration'] as String?,
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
