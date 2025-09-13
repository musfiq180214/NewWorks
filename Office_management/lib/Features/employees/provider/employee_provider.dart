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

  EmployeeController(this.repository) : super(EmployeeState()) {
    fetchEmployees();
  }

  Future<void> fetchEmployees() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final employees = await repository.fetchEmployees();
      state = state.copyWith(loading: false, employees: employees);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}

final employeeControllerProvider =
    StateNotifierProvider<EmployeeController, EmployeeState>(
      (ref) => EmployeeController(EmployeeRepository()),
    );
