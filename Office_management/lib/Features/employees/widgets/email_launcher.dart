import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmailLauncher extends StatelessWidget {
  final String? email;
  final TextStyle? textStyle;
  final Widget? trailing;

  const EmailLauncher({
    super.key,
    required this.email,
    this.textStyle,
    this.trailing,
  });

  Future<void> _launchEmail(String email) async {
    final Uri uri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw "Could not launch $uri";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (email == null || email!.isEmpty) {
      return _buildRow("N/A");
    }
    return InkWell(onTap: () => _launchEmail(email!), child: _buildRow(email!));
  }

  Widget _buildRow(String text) {
    return Container(
      height: 50,
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: textStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
