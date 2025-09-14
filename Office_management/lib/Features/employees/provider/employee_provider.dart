// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:office_management/Features/employees/domain/employee.dart';
// import '../data/employee_repository.dart';

// class EmployeeState {
//   final bool loading;
//   final String? error;
//   final List<Employee> employees;

//   EmployeeState({this.loading = false, this.error, this.employees = const []});

//   EmployeeState copyWith({
//     bool? loading,
//     String? error,
//     List<Employee>? employees,
//   }) {
//     return EmployeeState(
//       loading: loading ?? this.loading,
//       error: error,
//       employees: employees ?? this.employees,
//     );
//   }
// }

// class EmployeeController extends StateNotifier<EmployeeState> {
//   final EmployeeRepository repository;

//   // Hold the full list for searching
//   List<Employee> _allEmployees = [];

//   EmployeeController(this.repository) : super(EmployeeState()) {
//     fetchEmployees();
//   }

//   Future<void> fetchEmployees() async {
//     state = state.copyWith(loading: true, error: null);
//     try {
//       final employees = await repository.fetchEmployees();
//       _allEmployees = employees; // store the full list
//       state = state.copyWith(loading: false, employees: employees);
//     } catch (e) {
//       state = state.copyWith(loading: false, error: e.toString());
//     }
//   }

//   void searchEmployees(String query) {
//     final filtered = _allEmployees
//         .where(
//           (e) =>
//               e.name.toLowerCase().contains(query) ||
//               e.email.toLowerCase().contains(query) ||
//               e.designation.toLowerCase().contains(query),
//         )
//         .toList();
//     state = state.copyWith(employees: filtered, loading: false);
//   }

//   void loadEmployees() {
//     // Restore full list
//     state = state.copyWith(employees: _allEmployees);
//   }
// }

// final employeeControllerProvider =
//     StateNotifierProvider<EmployeeController, EmployeeState>(
//       (ref) => EmployeeController(EmployeeRepository()),
//     );

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
  List<Employee> _displayedEmployees = [];
  int _perPage = 10;
  int _currentPage = 0;

  EmployeeController(this.repository) : super(EmployeeState()) {
    fetchEmployees();
  }

  Future<void> fetchEmployees() async {
    state = state.copyWith(loading: true, error: null);
    try {
      _allEmployees = await repository.fetchEmployees();
      _displayedEmployees = [];
      _currentPage = 0;
      loadMore(); // load first 10 employees
      state = state.copyWith(loading: false, employees: _displayedEmployees);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  void loadMore() {
    final nextPage = _currentPage + 1;
    final nextItems = _allEmployees
        .skip(_currentPage * _perPage)
        .take(_perPage)
        .toList();
    _displayedEmployees.addAll(nextItems);
    _currentPage = nextPage;
    state = state.copyWith(employees: List.from(_displayedEmployees));
  }

  void searchEmployees(String query) {
    final filtered = _allEmployees
        .where(
          (e) =>
              e.name.toLowerCase().contains(query) ||
              e.email.toLowerCase().contains(query) ||
              e.designation.toLowerCase().contains(query),
        )
        .toList();
    _displayedEmployees = filtered.take(_perPage).toList();
    _currentPage = 1;
    state = state.copyWith(employees: List.from(_displayedEmployees));
  }

  void loadEmployees() {
    _displayedEmployees = _allEmployees.take(_perPage).toList();
    _currentPage = 1;
    state = state.copyWith(employees: List.from(_displayedEmployees));
  }
}

final employeeControllerProvider =
    StateNotifierProvider<EmployeeController, EmployeeState>(
      (ref) => EmployeeController(EmployeeRepository()),
    );
