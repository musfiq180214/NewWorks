import 'package:flutter/material.dart';
import 'package:office_management/Features/avg_attendance/domain/avg_time_model.dart';

class AverageTimeCard extends StatelessWidget {
  final AverageTime averageTime;
  const AverageTimeCard({Key? key, required this.averageTime})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue[100],
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              averageTime.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text('ID: ${averageTime.id}'),
            Text(
              'Avg In: ${averageTime.avgInTime} | Avg Out: ${averageTime.avgOutTime}',
            ),
            Text('Avg Duration: ${averageTime.avgDuration}'),
          ],
        ),
      ),
    );
  }
}
