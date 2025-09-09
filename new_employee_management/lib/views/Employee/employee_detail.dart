import 'package:employee_management/controllers/loginController.dart';
import 'package:employee_management/views/custom_widgets/custom_appbar.dart';
import 'package:employee_management/views/custom_widgets/menubar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class EmployeeDetailPage extends StatefulWidget {
  const EmployeeDetailPage({super.key});

  @override
  State<EmployeeDetailPage> createState() => _EmployeeDetailPageState();
}

class _EmployeeDetailPageState extends State<EmployeeDetailPage> {
  late final dynamic employeeDetail; // Add proper type if known, e.g., Employee

  @override
  void initState() {
    super.initState();
    employeeDetail = Get.arguments;
  }

  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: employeeDetail.email,
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch email client';
    }
  }

  Future<void> _launchPhone(String phone) async {
    final Uri telUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    } else {
      throw 'Could not launch phone dialer';
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> employeeDetailKey = GlobalKey();
    final LoginController loginController = Get.find<LoginController>();

    return Scaffold(
      key: employeeDetailKey,
      appBar: CustomAppBar(
        compaq: false,
        drawer: false,
        notification: false,
        scaffoldkey: employeeDetailKey,
        title: 'Employee Details',
      ),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            children: [
              _buildInfoCard(
                title: employeeDetail.name,
                subtitle: employeeDetail.designation,
              ),
              _buildContactRow(
                label: "Email:",
                value: employeeDetail.email,
                iconPath: 'assets/images/mailicon.svg',
                onPressed: _launchEmail,
              ),
              _buildContactRow(
                label: "Phone:",
                value: employeeDetail.phone,
                iconPath: 'assets/images/phoneicon.svg',
                onPressed: () => _launchPhone(employeeDetail.phone),
              ),
              _buildContactRow(
                label: "Blood Group:",
                value: employeeDetail.bloodGroup,
                iconPath: 'assets/images/bloodicon.svg',
                onPressed: null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({required String title, required String subtitle}) {
    return Container(
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
          Text(subtitle,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[400])),
        ],
      ),
    );
  }

  Widget _buildContactRow({
    required String label,
    required String value,
    required String iconPath,
    VoidCallback? onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      height: 60,
      alignment: Alignment.center,
      width: double.infinity,
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.grey.shade200,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w400)),
              const SizedBox(width: 5),
              value != ""
                  ? SizedBox(
                      width: 180,
                      child: Text(value,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black54)),
                    )
                  : const Text("N/A",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black54)),
            ],
          ),
          if (onPressed != null)
            TextButton(
              onPressed: onPressed,
              child: SvgPicture.asset(iconPath),
            ),
        ],
      ),
    );
  }
}
