import '../core/api_client.dart';
import '../core/constants.dart';

class AttendanceRepository {
  final APIClient api;
  AttendanceRepository({APIClient? apiClient}) : api = apiClient ?? APIClient();

  Future<Map<String, dynamic>> fetchAttendances({
    Map<String, String>? headers,
  }) async {
    return await api.get(EndPoints.attendencesPath, headers: headers);
  }
}
