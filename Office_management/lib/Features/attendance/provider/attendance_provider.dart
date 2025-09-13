import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:office_management/Features/attendance/domain/attendance_model.dart';
import '../data/attendance_repository.dart';

class AttendanceState {
  final List<Attendance> attendances;
  final bool loading;
  final String? error;

  const AttendanceState({
    this.attendances = const [],
    this.loading = false,
    this.error,
  });

  AttendanceState copyWith({
    List<Attendance>? attendances,
    bool? loading,
    String? error,
  }) {
    return AttendanceState(
      attendances: attendances ?? this.attendances,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}

class AttendanceNotifier extends StateNotifier<AttendanceState> {
  final AttendanceRepository repository;

  AttendanceNotifier(this.repository) : super(const AttendanceState()) {
    fetchAttendances();
  }

  Future<void> fetchAttendances() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final list = await repository.fetchAttendances(); // List<Attendance>
      state = state.copyWith(attendances: list, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }
}

// Providers
final attendanceRepositoryProvider = Provider((ref) => AttendanceRepository());

final attendanceControllerProvider =
    StateNotifierProvider<AttendanceNotifier, AttendanceState>(
      (ref) => AttendanceNotifier(ref.read(attendanceRepositoryProvider)),
    );
