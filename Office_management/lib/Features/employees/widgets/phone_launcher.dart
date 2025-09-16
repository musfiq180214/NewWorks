import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PhoneLauncher extends StatelessWidget {
  final String? phone;
  final TextStyle? textStyle;
  final Widget? trailing;

  const PhoneLauncher({
    super.key,
    required this.phone,
    this.textStyle,
    this.trailing,
  });

  Future<void> _launchPhone(String phone) async {
    final Uri uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw "Could not launch $uri";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (phone == null || phone!.isEmpty) {
      return _buildRow("N/A");
    }
    return InkWell(onTap: () => _launchPhone(phone!), child: _buildRow(phone!));
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
