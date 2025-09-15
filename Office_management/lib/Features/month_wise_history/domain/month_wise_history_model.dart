class MonthWiseHistoryModelData {
  final String id;
  final String employeeId;
  final String name;
  final String empDeviceId;
  final DateTime date;
  final String inTime; // e.g., "09:05"
  final String outTime; // e.g., "17:10"
  final String duration; // e.g., "8h 5m"

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

  factory MonthWiseHistoryModelData.fromJson(Map<String, dynamic> json) {
    return MonthWiseHistoryModelData(
      id: json['id'] ?? '',
      employeeId: json['employeeId'] ?? '',
      name: json['name'] ?? '',
      empDeviceId: json['empDeviceId'] ?? '',
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(),
      inTime: json['inTime'] ?? '-',
      outTime: json['outTime'] ?? '-',
      duration: json['duration'] ?? '-',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'employeeId': employeeId,
    'name': name,
    'empDeviceId': empDeviceId,
    'date': date.toIso8601String(),
    'inTime': inTime,
    'outTime': outTime,
    'duration': duration,
  };
}
