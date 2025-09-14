import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmailLauncher extends StatelessWidget {
  final String? email;
  final TextStyle? textStyle; // Add this

  const EmailLauncher({super.key, required this.email, this.textStyle});

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
      child: _infoRow("Email", email),
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
