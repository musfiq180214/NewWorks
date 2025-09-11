class AverageTime {
  final String id;
  final String name;
  final String avgInTime;
  final String avgOutTime;
  final String avgDuration;

  AverageTime({
    required this.id,
    required this.name,
    required this.avgInTime,
    required this.avgOutTime,
    required this.avgDuration,
  });

  factory AverageTime.fromJson(Map<String, dynamic> json) {
    return AverageTime(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      avgInTime: json['avgInTime'] ?? '',
      avgOutTime: json['avgOutTime'] ?? '',
      avgDuration: json['avgDuration'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'avgInTime': avgInTime,
    'avgOutTime': avgOutTime,
    'avgDuration': avgDuration,
  };
}
