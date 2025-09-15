import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:office_management/Features/month_wise_history/domain/month_wise_history_model.dart';
import 'package:office_management/Features/month_wise_history/provider/monthWiseHistoryProvider.dart';
import 'package:office_management/constants/Colors.dart';

class MonthWiseHistoryScreen extends ConsumerStatefulWidget {
  const MonthWiseHistoryScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MonthWiseHistoryScreen> createState() =>
      _MonthWiseHistoryScreenState();
}

class _MonthWiseHistoryScreenState
    extends ConsumerState<MonthWiseHistoryScreen> {
  String? selectedEmployee;
  String? selectedMonth;
  DateTime? startDate;
  DateTime? endDate;

  List<String> getEmployeeList(List<MonthWiseHistoryModelData> data) {
    final employees = data.map((e) => e.name).toSet().toList();
    employees.sort();
    return employees;
  }

  List<String> getMonthList() {
    return List.generate(
      12,
      (i) => DateFormat('MMMM').format(DateTime(0, i + 1)),
    );
  }

  Future<void> pickStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        startDate = picked;
      });
    }
  }

  Future<void> pickEndDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        endDate = picked;
      });
    }
  }

  Color _timeColor(String time, bool isInTime) {
    if (time == '-') return Colors.grey;
    final parts = time.split(':');
    final hour = int.tryParse(parts[0]) ?? 0;

    if (isInTime) {
      return hour < 9 ? Colors.green : Colors.red;
    } else {
      return hour > 17 ? Colors.green : Colors.red;
    }
  }

  List<MonthWiseHistoryModelData> applyFilters(
    List<MonthWiseHistoryModelData> data,
  ) {
    return data.where((e) {
      bool matchesEmployee =
          selectedEmployee == null || e.name == selectedEmployee;
      bool matchesMonth =
          selectedMonth == null ||
          DateFormat('MMMM').format(e.date) == selectedMonth;
      bool matchesStartDate = startDate == null || !e.date.isBefore(startDate!);
      bool matchesEndDate = endDate == null || !e.date.isAfter(endDate!);
      return matchesEmployee &&
          matchesMonth &&
          matchesStartDate &&
          matchesEndDate;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(monthWiseHistoryControllerProvider);

    String getAvgInTime(List<MonthWiseHistoryModelData> filtered) {
      if (filtered.isEmpty) return '-';
      final totalMinutes = filtered.fold<int>(0, (sum, e) {
        final parts = e.inTime.split(':');
        return sum + int.parse(parts[0]) * 60 + int.parse(parts[1]);
      });
      final avgMinutes = totalMinutes ~/ filtered.length;
      final hours = avgMinutes ~/ 60;
      final minutes = avgMinutes % 60;
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
    }

    String getAvgOutTime(List<MonthWiseHistoryModelData> filtered) {
      if (filtered.isEmpty) return '-';
      final totalMinutes = filtered.fold<int>(0, (sum, e) {
        final parts = e.outTime.split(':');
        return sum + int.parse(parts[0]) * 60 + int.parse(parts[1]);
      });
      final avgMinutes = totalMinutes ~/ filtered.length;
      final hours = avgMinutes ~/ 60;
      final minutes = avgMinutes % 60;
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
    }

    String getAvgDuration(List<MonthWiseHistoryModelData> filtered) {
      if (filtered.isEmpty) return '-';
      final totalMinutes = filtered.fold<int>(0, (sum, e) {
        final match = RegExp(r'(\d+)h (\d+)m').firstMatch(e.duration);
        if (match == null) return sum;
        final hours = int.parse(match.group(1)!);
        final minutes = int.parse(match.group(2)!);
        return sum + hours * 60 + minutes;
      });
      final avgMinutes = totalMinutes ~/ filtered.length;
      final hours = avgMinutes ~/ 60;
      final minutes = avgMinutes % 60;
      return '${hours}h ${minutes}m';
    }

    final filteredHistories = applyFilters(state.histories);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Month-wise Attendance'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(gradient: kAppGradient),
        child: state.loading
            ? const Center(child: CircularProgressIndicator())
            : state.error != null
            ? Center(
                child: Text(
                  'Error: ${state.error}',
                  style: const TextStyle(color: Colors.white),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(top: 80.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Filters
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Filters',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 12,
                            runSpacing: 8,
                            children: [
                              // Employee Dropdown
                              DropdownButton<String>(
                                dropdownColor: Colors.grey[800],
                                value: selectedEmployee,
                                hint: const Text(
                                  'Select Employee',
                                  style: TextStyle(color: Colors.white),
                                ),
                                items: getEmployeeList(state.histories)
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(
                                          e,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (v) {
                                  setState(() {
                                    selectedEmployee = v;
                                  });
                                },
                              ),
                              // Month Dropdown
                              DropdownButton<String>(
                                dropdownColor: Colors.grey[800],
                                value: selectedMonth,
                                hint: const Text(
                                  'Select Month',
                                  style: TextStyle(color: Colors.white),
                                ),
                                items: getMonthList()
                                    .map(
                                      (m) => DropdownMenuItem(
                                        value: m,
                                        child: Text(
                                          m,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (v) {
                                  setState(() {
                                    selectedMonth = v;
                                  });
                                },
                              ),
                              // Start Date Picker
                              TextButton(
                                onPressed: () => pickStartDate(context),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      startDate == null
                                          ? 'Start Date'
                                          : DateFormat(
                                              'dd MMM yyyy',
                                            ).format(startDate!),
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // End Date Picker
                              TextButton(
                                onPressed: () => pickEndDate(context),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      endDate == null
                                          ? 'End Date'
                                          : DateFormat(
                                              'dd MMM yyyy',
                                            ).format(endDate!),
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Clear Filters
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    selectedEmployee = null;
                                    selectedMonth = null;
                                    startDate = null;
                                    endDate = null;
                                  });
                                },
                                child: const Text(
                                  'Clear',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Summary
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildSummaryCard(
                            'Avg IN',
                            getAvgInTime(filteredHistories),
                          ),
                          _buildSummaryCard(
                            'Avg OUT',
                            getAvgOutTime(filteredHistories),
                          ),
                          _buildSummaryCard(
                            'Avg Duration',
                            getAvgDuration(filteredHistories),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Daily History
                    Expanded(
                      child: filteredHistories.isEmpty
                          ? const Center(
                              child: Text(
                                'NO DATA AVAILABLE',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              itemCount: filteredHistories.length,
                              itemBuilder: (_, i) {
                                final entry = filteredHistories[i];
                                return Card(
                                  color: Colors.white.withOpacity(0.2),
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Employee Info
                                        Text(
                                          '${entry.name} (${entry.employeeId})',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        // Attendance Info
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              DateFormat(
                                                'dd MMM',
                                              ).format(entry.date),
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              entry.inTime,
                                              style: TextStyle(
                                                color: _timeColor(
                                                  entry.inTime,
                                                  true,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              entry.outTime,
                                              style: TextStyle(
                                                color: _timeColor(
                                                  entry.outTime,
                                                  false,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              entry.duration,
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value) {
    return Expanded(
      child: Card(
        color: Colors.white.withOpacity(0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
