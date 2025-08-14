import 'package:flutter/material.dart';

class WaterDropButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color color;

  const WaterDropButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: GestureDetector(
          onTap: onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Water drop shaped container
              ClipPath(
                clipper: _WaterDropClipper(),
                child: Container(
                  width: 70,
                  height: 90,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color.withOpacity(0.7), color],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.5),
                        offset: const Offset(0, 5),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black38,
                          offset: Offset(0, 2),
                          blurRadius: 3,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WaterDropClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    final width = size.width;
    final height = size.height;

    // Draw a water drop shape
    path.moveTo(width / 2, 0);
    path.quadraticBezierTo(width * 0.9, height * 0.4, width / 2, height);
    path.quadraticBezierTo(width * 0.1, height * 0.4, width / 2, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
