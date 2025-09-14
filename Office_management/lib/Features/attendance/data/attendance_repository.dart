import 'package:office_management/Features/attendance/domain/attendance_model.dart';
import 'package:office_management/core/api_client.dart';
import 'package:office_management/core/constants.dart';

class AttendanceRepository {
  // Local mock data with multiple dates
  Future<List<Attendance>> fetchAttendances() async {
    await Future.delayed(const Duration(seconds: 1)); // simulate network delay

    return [
      // Day 1 - 2025-09-01
      Attendance(
        id: '1',
        employeeId: 101,
        name: 'John Doe',
        empDeviceId: 501,
        date: '2025-09-01',
        inTime: '09:00',
        outTime: '17:00',
        duration: '8h',
        status: 'Present',
      ),
      Attendance(
        id: '2',
        employeeId: 102,
        name: 'Jane Smith',
        empDeviceId: 502,
        date: '2025-09-01',
        inTime: '09:30',
        outTime: '17:30',
        duration: '8h',
        status: 'Late',
      ),
      Attendance(
        id: '3',
        employeeId: 103,
        name: 'Michael Johnson',
        empDeviceId: 503,
        date: '2025-09-01',
        inTime: '08:45',
        outTime: '16:45',
        duration: '8h',
        status: 'Present',
      ),
      // Day 2 - 2025-09-02
      Attendance(
        id: '4',
        employeeId: 101,
        name: 'John Doe',
        empDeviceId: 501,
        date: '2025-09-02',
        inTime: '09:05',
        outTime: '17:00',
        duration: '7h 55m',
        status: 'Late',
      ),
      Attendance(
        id: '5',
        employeeId: 102,
        name: 'Jane Smith',
        empDeviceId: 502,
        date: '2025-09-02',
        inTime: '09:00',
        outTime: '17:00',
        duration: '8h',
        status: 'Present',
      ),
      Attendance(
        id: '6',
        employeeId: 103,
        name: 'Michael Johnson',
        empDeviceId: 503,
        date: '2025-09-02',
        inTime: '09:00',
        outTime: '17:00',
        duration: '8h',
        status: 'Present',
      ),
      // Day 3 - 2025-09-03
      Attendance(
        id: '7',
        employeeId: 101,
        name: 'John Doe',
        empDeviceId: 501,
        date: '2025-09-03',
        inTime: '09:00',
        outTime: '17:00',
        duration: '8h',
        status: 'Present',
      ),
      Attendance(
        id: '8',
        employeeId: 102,
        name: 'Jane Smith',
        empDeviceId: 502,
        date: '2025-09-03',
        inTime: '09:30',
        outTime: '17:30',
        duration: '8h',
        status: 'Late',
      ),
      Attendance(
        id: '9',
        employeeId: 103,
        name: 'Michael Johnson',
        empDeviceId: 503,
        date: '2025-09-03',
        inTime: '08:50',
        outTime: '16:50',
        duration: '8h',
        status: 'Present',
      ),
    ];
  }

  // Future API version (commented for now)

  // Future<List<Attendance>> fetchAttendances() async {
  //   final resp = await APIClient().get(EndPoints.attendencesPath);
  //   final List<dynamic> data = resp['data'] ?? [];
  //   return data.map((e) => Attendance.fromJson(e)).toList();
  // }
}
