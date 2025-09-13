import 'package:office_management/Features/avg_attendance/domain/avg_time_model.dart';

class AverageTimeRepository {
  // Local mock data
  Future<List<AverageTime>> fetchAverageTimes() async {
    await Future.delayed(const Duration(seconds: 1)); // simulate network delay

    return [
      AverageTime(
        id: '101',
        name: 'John Doe',
        avgInTime: '09:05',
        avgOutTime: '17:10',
        avgDuration: '8h 5m',
      ),
      AverageTime(
        id: '102',
        name: 'Jane Smith',
        avgInTime: '09:15',
        avgOutTime: '17:20',
        avgDuration: '8h 5m',
      ),
      AverageTime(
        id: '103',
        name: 'Michael Johnson',
        avgInTime: '08:55',
        avgOutTime: '16:55',
        avgDuration: '8h',
      ),
      AverageTime(
        id: '104',
        name: 'Emily Davis',
        avgInTime: '09:10',
        avgOutTime: '17:10',
        avgDuration: '8h',
      ),
      AverageTime(
        id: '105',
        name: 'Chris Brown',
        avgInTime: '09:00',
        avgOutTime: '17:05',
        avgDuration: '8h 5m',
      ),
    ];
  }

  // Future API version (commented)
  /*
  Future<List<AverageTime>> fetchFromApi() async {
    final resp = await APIClient().get(EndPoints.avgAttendecPath);
    final List<dynamic> data = resp['data'] ?? [];
    return data.map((e) => AverageTime.fromJson(e)).toList();
  }
  */
}
