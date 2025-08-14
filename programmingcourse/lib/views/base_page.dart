import 'package:flutter/material.dart';
import 'home_page.dart';

class BasePage extends StatelessWidget {
  const BasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Blue top portion with curved bottom edge
            SizedBox(
              height: 250, // height of blue area including curve
              width: double.infinity,
              child: CustomPaint(
                painter: BlueBackgroundWithCurvePainter(),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.book,
                        size: 72,
                        color: Colors.white,
                      ),
                      SizedBox(width: 30),
                      Icon(
                        Icons.lightbulb,
                        size: 72,
                        color: Colors.amber,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Below blue curved area is white by default
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),

                    const Text(
                      'Learning is Everything',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Learning with Pleasure with Dear Programmer, Wherever you are',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),

                    const Spacer(),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const HomePage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Get Start',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RiseStraightFallPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.blue;

    final path = Path();

    // Start bottom-left, a bit above bottom edge to have some margin
    path.moveTo(0, size.height * 0.8);

    // Rise curve: from bottom-left to about 35% width and 40% height (peak)
    path.quadraticBezierTo(
      size.width * 0.2, size.height * 0.3,
      size.width * 0.35, size.height * 0.4,
    );

    // Straight line from 35% to 65% width at same height (plateau)
    path.lineTo(size.width * 0.65, size.height * 0.4);

    // Fall curve: from 65% width, 40% height to 100% width, 80% height (down to near start)
    path.quadraticBezierTo(
      size.width * 0.8, size.height * 0.6,
      size.width, size.height * 0.8,
    );

    // Bottom right corner down to bottom edge
    path.lineTo(size.width, size.height);

    // Bottom edge back to bottom left
    path.lineTo(0, size.height);

    // Close the path
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


class BlueBackgroundWithCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.blue;

    final path = Path();

    // Start at top-left
    path.moveTo(0, 0);

    // Left side straight down to start of curve
    path.lineTo(0, size.height - 60);

    // Reverse cubic Bezier curve:
    // Starts below baseline (rises up),
    // then goes down towards right side smoothly
    path.cubicTo(
      size.width * 0.10, size.height - 140, // Control point 1: high above baseline
      size.width * 0.75, size.height + 40,  // Control point 2: below baseline
      size.width, size.height - 60,          // End point near baseline
    );

    // Right side straight up to top-right corner
    path.lineTo(size.width, 0);

    // Close the path (top edge)
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
