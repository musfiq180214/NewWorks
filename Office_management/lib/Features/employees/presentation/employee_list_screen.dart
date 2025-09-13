import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:office_management/Features/employees/presentation/employee_detail_screen.dart';
import 'package:office_management/Features/employees/provider/employee_provider.dart';
import 'package:office_management/Features/employees/widgets/employee_card.dart';
import 'package:office_management/constants/Colors.dart';
import 'package:office_management/routes/app_routes.dart';

class EmployeeListScreen extends ConsumerStatefulWidget {
  const EmployeeListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends ConsumerState<EmployeeListScreen> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    searchController.addListener(_searchListener);
  }

  void _searchListener() {
    final query = searchController.text.trim().toLowerCase();
    if (query.length >= 3) {
      // ref.read(employeeControllerProvider.notifier).searchEmployees(query);
    } else {
      // ref.read(employeeControllerProvider.notifier).loadEmployees();
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(employeeControllerProvider);

    return GestureDetector(
      onTap: () {
        // Unfocus search field when tapping outside
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Employee List'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          decoration: BoxDecoration(gradient: kAppGradient),
          child: Column(
            children: [
              // Search Field
              Container(
                margin: const EdgeInsets.fromLTRB(15, 80, 15, 10),
                child: TextField(
                  focusNode: searchFocusNode,
                  controller: searchController,
                  autofocus: false, // <-- important
                  keyboardType: TextInputType.name,
                  style: const TextStyle(fontSize: 14.0),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(20, 5, 5, 5),
                    hintText: "Search Employee",
                    suffixIcon: const Icon(Icons.search_sharp),
                    hintStyle: const TextStyle(
                      fontSize: 14.0,
                      color: Color(0xFF616161),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Color(0xFFBBBBBB),
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
              // Employee List
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: state.loading
                      ? const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                      : state.employees.isEmpty
                      ? const Center(
                          child: Text(
                            "NO EMPLOYEE FOUND",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: state.employees.length,
                          itemBuilder: (_, index) {
                            final employee = state.employees[index];
                            return InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.employeeDetail,
                                  arguments: employee,
                                );
                              },
                              child: EmployeeCard(employee: employee),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
