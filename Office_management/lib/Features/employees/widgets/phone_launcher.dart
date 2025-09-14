import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PhoneLauncher extends StatelessWidget {
  final String? phone;

  const PhoneLauncher({Key? key, required this.phone}) : super(key: key);

  Future<void> _launchDialer(BuildContext context, String phoneNumber) async {
    final Uri telUri = Uri(scheme: 'tel', path: phoneNumber);

    try {
      await launchUrl(telUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      _showSnackBar(context, "Could not launch dialer.");
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (phone != null && phone!.isNotEmpty) {
          _launchDialer(context, phone!);
        } else {
          _showSnackBar(context, "Phone number not available.");
        }
      },
      child: _infoRow("Phone", phone, isClickable: true),
    );
  }

  Widget _infoRow(String label, dynamic value, {bool isClickable = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      height: 60,
      alignment: Alignment.center,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: isClickable ? Colors.blue.shade50 : Colors.grey.shade200,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          ),
          Expanded(
            child: Text(
              value != null && value.toString().isNotEmpty
                  ? value.toString()
                  : "N/A",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: isClickable ? Colors.blue : Colors.black54,
                decoration: isClickable
                    ? TextDecoration.underline
                    : TextDecoration.none,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
