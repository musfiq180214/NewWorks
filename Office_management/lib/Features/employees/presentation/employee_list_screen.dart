import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:office_management/Features/employees/provider/employee_provider.dart';
import 'package:office_management/Features/employees/widgets/employee_card.dart';
import 'package:office_management/constants/Colors.dart';
import 'package:office_management/routes/app_routes.dart';

class EmployeeListScreen extends ConsumerStatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  ConsumerState<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends ConsumerState<EmployeeListScreen> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Load initial employees
    ref.read(employeeControllerProvider.notifier).fetchEmployees();

    // Listen to scroll for lazy loading
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        ref.read(employeeControllerProvider.notifier).loadMore();
      }
    });
  }

  void _onSearchTap() {
    FocusScope.of(context).requestFocus(searchFocusNode);
    searchController.addListener(_searchListener);
  }

  void _searchListener() {
    final query = searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      ref.read(employeeControllerProvider.notifier).searchEmployees(query);
    } else {
      ref.read(employeeControllerProvider.notifier).loadEmployees();
    }
  }

  void _clearSearch() {
    searchController.clear();
    ref.read(employeeControllerProvider.notifier).loadEmployees();
    FocusScope.of(context).unfocus();
    searchController.removeListener(_searchListener);
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(employeeControllerProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
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
                  autofocus: false,
                  onTap: _onSearchTap,
                  keyboardType: TextInputType.name,
                  style: const TextStyle(fontSize: 14.0),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(20, 5, 5, 5),
                    hintText: "Search Employee",
                    suffixIcon: searchController.text.isEmpty
                        ? const Icon(Icons.search_sharp)
                        : IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: _clearSearch,
                          ),
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
                  child: state.loading && state.employees.isEmpty
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
                          controller: scrollController,
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
