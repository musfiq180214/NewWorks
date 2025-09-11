import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:office_management/Features/avg_attendance/data/avg_time_repository.dart';
import 'package:office_management/Features/avg_attendance/domain/avg_time_model.dart';

class AverageTimeState {
  final List<AverageTime> averages;
  final bool loading;
  final String? error;

  const AverageTimeState({
    this.averages = const [],
    this.loading = false,
    this.error,
  });

  AverageTimeState copyWith({
    List<AverageTime>? averages,
    bool? loading,
    String? error,
  }) {
    return AverageTimeState(
      averages: averages ?? this.averages,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}

class AverageTimeNotifier extends StateNotifier<AverageTimeState> {
  final AverageTimeRepository repository;

  AverageTimeNotifier(this.repository) : super(const AverageTimeState()) {
    fetchAverageTimes();
  }

  Future<void> fetchAverageTimes() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final list = await repository.fetchAverageTimes();
      state = state.copyWith(averages: list, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }
}

// Providers
final averageTimeRepositoryProvider = Provider(
  (ref) => AverageTimeRepository(),
);

final averageTimeControllerProvider =
    StateNotifierProvider<AverageTimeNotifier, AverageTimeState>(
      (ref) => AverageTimeNotifier(ref.read(averageTimeRepositoryProvider)),
    );
