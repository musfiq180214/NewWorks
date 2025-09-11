import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:office_management/Features/attendance/provider/attendance_provider.dart';
import 'package:office_management/Features/attendance/widgets/attendance_card.dart';
import 'package:office_management/constants/Colors.dart';

class AttendanceScreen extends ConsumerWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(attendanceControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendances'),
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
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(top: 80.0), // space from top
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  children: groupBy(state.attendances, (a) => a.date).entries
                      .mapIndexed((dateIndex, entry) {
                        final date = entry.key;
                        final attendances = entry.value;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Date header
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Text(
                                date,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            // Attendance cards
                            ...attendances.mapIndexed(
                              (i, a) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 16,
                                ),
                                child: AttendanceCard(attendance: a, index: i),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        );
                      })
                      .toList(),
                ),
              ),
      ),
    );
  }
}
