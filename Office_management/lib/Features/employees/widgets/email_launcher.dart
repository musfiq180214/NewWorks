import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmailLauncher extends StatelessWidget {
  final String? email;

  const EmailLauncher({Key? key, required this.email}) : super(key: key);

  String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }

  Future<void> _launchEmail(BuildContext context, String email) async {
    final String subject = "Hello";
    final String body = "Write your message here.";

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: _encodeQueryParameters(<String, String>{
        'subject': subject,
        'body': body,
      }),
    );

    final gmailUri = Uri.parse(
      "googlegmail://co?to=$email&subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}",
    );

    try {
      if (await canLaunchUrl(gmailUri)) {
        await launchUrl(gmailUri, mode: LaunchMode.externalApplication);
        return;
      }
    } catch (_) {}

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri, mode: LaunchMode.externalApplication);
    } else {
      _showSnackBar(context, "No email app found on this device.");
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
        if (email != null && email!.isNotEmpty) {
          _launchEmail(context, email!);
        } else {
          _showSnackBar(context, "Email not available.");
        }
      },
      child: _infoRow("Email", email, isClickable: true),
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
