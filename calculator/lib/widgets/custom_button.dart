import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;

  const CustomButton({
    super.key,
    required this.label,
    required this.color,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(12),
        color: color,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            height: 60,
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
