import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:office_management/Features/avg_attendance/provider/avarage_time_provider.dart';
import 'package:office_management/Features/avg_attendance/widgets/avarage_time_card.dart';
import 'package:office_management/constants/Colors.dart';

class AverageTimeScreen extends ConsumerWidget {
  const AverageTimeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(averageTimeControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Average Attendance'),
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
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemCount: state.averages.length,
                  itemBuilder: (_, i) => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    child: AverageTimeCard(averageTime: state.averages[i]),
                  ),
                ),
              ),
      ),
    );
  }
}
