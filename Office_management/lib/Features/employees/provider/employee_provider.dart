import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:office_management/Features/employees/domain/employee.dart';
import '../data/employee_repository.dart';

class EmployeeState {
  final bool loading;
  final String? error;
  final List<Employee> employees;

  EmployeeState({this.loading = false, this.error, this.employees = const []});

  EmployeeState copyWith({
    bool? loading,
    String? error,
    List<Employee>? employees,
  }) {
    return EmployeeState(
      loading: loading ?? this.loading,
      error: error,
      employees: employees ?? this.employees,
    );
  }
}

class EmployeeController extends StateNotifier<EmployeeState> {
  final EmployeeRepository repository;

  List<Employee> _allEmployees = [];
  List<Employee> _searchResults = [];
  List<Employee> _displayedEmployees = [];

  final int _perPage = 10;
  int _currentPage = 0;
  bool _isSearching = false;

  EmployeeController(this.repository) : super(EmployeeState()) {
    fetchEmployees();
  }

  Future<void> fetchEmployees() async {
    state = state.copyWith(loading: true, error: null);
    try {
      _allEmployees = await repository.fetchEmployees();
      _resetPagination();
      loadMore(); // load first page
      state = state.copyWith(
        loading: false,
        employees: List.from(_displayedEmployees),
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  void _resetPagination() {
    _displayedEmployees = [];
    _currentPage = 0;
  }

  /// Load next page (works for both search mode & normal mode)
  void loadMore() {
    final source = _isSearching ? _searchResults : _allEmployees;

    final nextPage = _currentPage + 1;
    final nextItems = source
        .skip(_currentPage * _perPage)
        .take(_perPage)
        .toList();

    if (nextItems.isNotEmpty) {
      _displayedEmployees.addAll(nextItems);
      _currentPage = nextPage;
    }

    // Update state even if nextItems is empty so the UI can show "No Employee Found"
    state = state.copyWith(employees: List.from(_displayedEmployees));
  }

  /// Search employees (resets pagination)
  void searchEmployees(String query) {
    _isSearching = true;
    _searchResults = _allEmployees
        .where(
          (e) =>
              e.name.toLowerCase().contains(query) ||
              e.email.toLowerCase().contains(query) ||
              e.designation.toLowerCase().contains(query),
        )
        .toList();

    _resetPagination();
    loadMore(); // load first page of search results
  }

  /// Clear search and show normal list again
  void loadEmployees() {
    _isSearching = false;
    _resetPagination();
    loadMore(); // load first page of full dataset
  }
}

final employeeControllerProvider =
    StateNotifierProvider<EmployeeController, EmployeeState>(
      (ref) => EmployeeController(EmployeeRepository()),
    );
