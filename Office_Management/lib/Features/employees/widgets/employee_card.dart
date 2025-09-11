import 'package:flutter/material.dart';
import 'package:office_management/Features/employees/domain/employee.dart';

class EmployeeCard extends StatelessWidget {
  final Employee employee;

  const EmployeeCard({Key? key, required this.employee}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.blue[100],
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Left: Employee details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name on first line
                  Text(
                    employee.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Designation on second line
                  Text(
                    employee.designation,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Email: ${employee.email}',
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Phone: ${employee.phone}',
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text('Blood Group: ${employee.bloodGroup}'),
                  Text('Donor: ${employee.isDonor ? 'Yes' : 'No'}'),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Right: Avatar
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.blueAccent,
              child: Text(
                employee.name.isNotEmpty ? employee.name[0].toUpperCase() : '?',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
