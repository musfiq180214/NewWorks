import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PhoneLauncher extends StatelessWidget {
  final String? phone;
  final TextStyle? textStyle; // Add this

  const PhoneLauncher({super.key, required this.phone, this.textStyle});

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
      child: _infoRow("Phone", phone),
    );
  }

  Widget _infoRow(String label, dynamic value, {IconData? icon}) {
    return Container(
      height: 50,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: textStyle?.color ?? Colors.black54, size: 18),
            const SizedBox(width: 5),
          ],
          Text(
            "$label: ",
            style:
                textStyle ??
                const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          Expanded(
            child: Text(
              value != null && value.toString().isNotEmpty
                  ? value.toString()
                  : "N/A",
              style:
                  textStyle ??
                  const TextStyle(fontSize: 14, color: Colors.black54),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
