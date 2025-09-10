import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/attendance.dart';
import '../providers/attendance_repository.dart';
import '../utils/storage.dart';
import '../utils/logger.dart';

class AttendanceState {
  final bool loading;
  final List<Attendance> items;
  final String? error;

  AttendanceState({this.loading = false, this.items = const [], this.error});

  AttendanceState copyWith({
    bool? loading,
    List<Attendance>? items,
    String? error,
  }) => AttendanceState(
    loading: loading ?? this.loading,
    items: items ?? this.items,
    error: error,
  );
}

class AttendanceController extends StateNotifier<AttendanceState> {
  final AttendanceRepository repo;

  AttendanceController({required this.repo}) : super(AttendanceState());

  Future<void> fetchAttendances() async {
    state = state.copyWith(loading: true, error: null);
    logger.i('Fetching attendances... 🔵');

    try {
      final token = await Storage.getToken();
      final headers = token != null ? {'Authorization': 'Bearer $token'} : null;
      final resp = await repo.fetchAttendances(headers: headers);

      logger.i('API Response: ${resp.toString()} 🔵');

      final data = resp['data'] ?? resp['attendances'] ?? resp;
      final list = <Attendance>[];

      if (data is List) {
        for (final item in data) list.add(Attendance.fromJson(item));
      } else if (data is Map && data['items'] is List) {
        for (final item in data['items']) list.add(Attendance.fromJson(item));
      }

      state = state.copyWith(items: list, loading: false);
      logger.i('Fetched ${list.length} attendances ✅');
    } catch (e, stackTrace) {
      state = state.copyWith(error: e.toString(), loading: false);
      logger.e(
        'Error fetching attendances ❌',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
}

// **Add this at the bottom**
final attendanceRepositoryProvider = Provider<AttendanceRepository>(
  (ref) => AttendanceRepository(),
);

final attendanceControllerProvider =
    StateNotifierProvider<AttendanceController, AttendanceState>((ref) {
      final repo = ref.watch(attendanceRepositoryProvider);
      return AttendanceController(repo: repo);
    });
