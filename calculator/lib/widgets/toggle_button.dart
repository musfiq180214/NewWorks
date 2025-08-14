import 'package:flutter/material.dart';

class ToggleButton extends StatelessWidget {
  final bool isCalculatorShown;
  final VoidCallback onPressed;

  const ToggleButton({
    super.key,
    required this.isCalculatorShown,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amberAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        child: Text(
          isCalculatorShown ? 'History' : 'Calculator',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
