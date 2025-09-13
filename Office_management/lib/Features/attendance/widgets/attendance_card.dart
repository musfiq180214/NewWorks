import 'package:flutter/material.dart';
import 'package:office_management/Features/attendance/domain/attendance_model.dart';

class AttendanceCard extends StatelessWidget {
  final Attendance attendance;
  final int index;
  const AttendanceCard({
    Key? key,
    required this.attendance,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.grey.shade100,
        border: Border.all(width: 1, color: Colors.grey.shade300),
      ),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          // Left index box
          Container(
            margin: const EdgeInsets.fromLTRB(5, 20, 10, 20),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(width: 1, color: Colors.black),
            ),
            alignment: Alignment.center,
            width: 40,
            child: Text(
              (index + 1).toString(),
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Employee info and timings
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name
              Text(
                attendance.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),

              // In/Out/Duration Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // In time
                  Row(
                    children: [
                      const Icon(Icons.login, size: 20, color: Colors.green),
                      Container(
                        padding: const EdgeInsets.only(left: 2),
                        width: MediaQuery.of(context).size.width * .18,
                        child: Text(
                          attendance.inTime ?? '-',
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),

                  // Out time
                  Row(
                    children: [
                      const Icon(Icons.logout, size: 20, color: Colors.red),
                      Container(
                        padding: const EdgeInsets.only(left: 2),
                        width: MediaQuery.of(context).size.width * .18,
                        child: Text(
                          attendance.outTime ?? '-',
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),

                  // Duration
                  Row(
                    children: [
                      const Icon(Icons.timer, size: 20, color: Colors.blue),
                      Container(
                        padding: const EdgeInsets.only(left: 2),
                        width: MediaQuery.of(context).size.width * .18,
                        child: Text(
                          attendance.duration ?? '-',
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
