import 'package:flutter/material.dart';
import 'package:office_management/Features/employees/widgets/email_launcher.dart';
import 'package:office_management/Features/employees/widgets/phone_launcher.dart';
import 'package:office_management/constants/Colors.dart';

class EmployeeDetailPage extends StatelessWidget {
  final dynamic employeeDetail;

  const EmployeeDetailPage({super.key, required this.employeeDetail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(gradient: kAppGradient),
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              children: [
                // Custom AppBar
                _customAppBar(context, 'Employee Details'),
                const SizedBox(height: 15),

                // Name & Designation Card
                _infoCard(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        employeeDetail.name ?? "N/A",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: kTextColor,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        employeeDetail.designation ?? "N/A",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: kTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Clickable Email (whole row clickable including arrow)
                _gradientCard(
                  child: EmailLauncher(
                    email: employeeDetail.email,
                    textStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Clickable Phone (whole row clickable including arrow)
                _gradientCard(
                  child: PhoneLauncher(
                    phone: employeeDetail.phone,
                    textStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Blood Group
                _gradientCard(
                  child: _infoTextRow("Blood Group", employeeDetail.bloodGroup),
                ),
                const SizedBox(height: 10),

                // Donor
                _gradientCard(
                  child: _infoTextRow(
                    "Donor",
                    employeeDetail.isDonor == true ? "Yes" : "No",
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Custom AppBar
  Widget _customAppBar(BuildContext context, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      width: double.infinity,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back, color: kTextColor),
          ),
          const SizedBox(width: 15),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: kTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard({required Widget child}) {
    return Container(
      height: 150,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: kPrimaryColor.withAlpha((0.2 * 255).round()),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withAlpha((0.3 * 255).round()),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(child: child),
    );
  }

  // Non-clickable text row
  Widget _infoTextRow(String label, dynamic value) {
    return Container(
      height: 50,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Text(
              value != null && value.toString().isNotEmpty
                  ? value.toString()
                  : "N/A",
              style: const TextStyle(fontSize: 14, color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Gradient card wrapper
  Widget _gradientCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        gradient: kAppGradient,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withAlpha((0.3 * 255).round()),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
