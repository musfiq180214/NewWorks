import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:office_management/Features/month_wise_history/data/month_wise_history_repository.dart';
import 'package:office_management/Features/month_wise_history/domain/month_wise_history_model.dart';

class MonthWiseHistoryState {
  final List<MonthWiseHistoryModelData> histories;
  final bool loading;
  final String? error;

  const MonthWiseHistoryState({
    this.histories = const [],
    this.loading = false,
    this.error,
  });

  MonthWiseHistoryState copyWith({
    List<MonthWiseHistoryModelData>? histories,
    bool? loading,
    String? error,
  }) {
    return MonthWiseHistoryState(
      histories: histories ?? this.histories,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}

class MonthWiseHistoryNotifier extends StateNotifier<MonthWiseHistoryState> {
  final MonthWiseHistoryRepository repository;

  MonthWiseHistoryNotifier(this.repository)
    : super(const MonthWiseHistoryState()) {
    fetchMonthHistory();
  }

  Future<void> fetchMonthHistory() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final list = await repository.fetchMonthHistory();
      state = state.copyWith(histories: list, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }
}

// Providers
final monthWiseHistoryRepositoryProvider = Provider(
  (ref) => MonthWiseHistoryRepository(),
);

final monthWiseHistoryControllerProvider =
    StateNotifierProvider<MonthWiseHistoryNotifier, MonthWiseHistoryState>(
      (ref) => MonthWiseHistoryNotifier(
        ref.read(monthWiseHistoryRepositoryProvider),
      ),
    );
