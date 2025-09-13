import 'package:flutter/material.dart';

class EmployeeDetailPage extends StatelessWidget {
  final dynamic employeeDetail;

  const EmployeeDetailPage({Key? key, required this.employeeDetail})
    : super(key: key);

  // Helper function to open phone or email is removed for simplicity
  // You can implement url_launcher later if needed

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Details'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            children: [
              // Name & Designation
              Container(
                height: 150,
                margin: const EdgeInsets.only(bottom: 10),
                alignment: Alignment.center,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey.shade200,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      employeeDetail.name ?? "N/A",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      employeeDetail.designation ?? "N/A",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
              // Email
              _infoRow("Email", employeeDetail.email),
              // Phone
              _infoRow("Phone", employeeDetail.phone),
              // Blood Group
              _infoRow("Blood Group", employeeDetail.bloodGroup),
              // Donor
              _infoRow("Donor", employeeDetail.isDonor == true ? "Yes" : "No"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, dynamic value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      height: 60,
      alignment: Alignment.center,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.grey.shade200,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          ),
          Text(
            value != null && value.toString().isNotEmpty
                ? value.toString()
                : "N/A",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
