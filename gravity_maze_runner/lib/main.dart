import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';

void main() {
  runApp(const GravityBallApp());
}

class GravityBallApp extends StatelessWidget {
  const GravityBallApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GravityBallScreen(),
    );
  }
}

class GravityBallScreen extends StatefulWidget {
  const GravityBallScreen({super.key});

  @override
  State<GravityBallScreen> createState() => _GravityBallScreenState();
}

class _GravityBallScreenState extends State<GravityBallScreen> {
  double ballX = 150;
  double ballY = 200;
  double velocityX = 0;
  double velocityY = 0;
  double ballRadius = 20;
  double boxWidth = 300;
  double boxHeight = 400;
  double damping = 0.7; // bounce damping

  StreamSubscription<AccelerometerEvent>? accelerometerSub;

  @override
  void initState() {
    super.initState();

    // Use the updated accelerometerEventStream() method
    accelerometerSub = SensorsPlatform.instance
        .accelerometerEventStream()
        .listen((event) {
          double ax = event.x;
          double ay = event.y;

          // Update velocity (invert axes for natural feel)
          velocityX += -ax * 10; // adjust sensitivity
          velocityY += ay * 10;
        });

    // Update ball position ~60FPS
    Timer.periodic(const Duration(milliseconds: 16), (timer) {
      double dt = 0.016;

      ballX += velocityX * dt;
      ballY += velocityY * dt;

      // Bounce on walls
      if (ballX - ballRadius < 0) {
        ballX = ballRadius;
        velocityX = -velocityX * damping;
      }
      if (ballX + ballRadius > boxWidth) {
        ballX = boxWidth - ballRadius;
        velocityX = -velocityX * damping;
      }
      if (ballY - ballRadius < 0) {
        ballY = ballRadius;
        velocityY = -velocityY * damping;
      }
      if (ballY + ballRadius > boxHeight) {
        ballY = boxHeight - ballRadius;
        velocityY = -velocityY * damping;
      }

      // Apply friction to slow down
      velocityX *= 0.98;
      velocityY *= 0.98;

      setState(() {});
    });
  }

  @override
  void dispose() {
    accelerometerSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gravity Ball")),
      body: Center(
        child: Container(
          width: boxWidth,
          height: boxHeight,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, width: 3),
          ),
          child: Stack(
            children: [
              Positioned(
                left: ballX - ballRadius,
                top: ballY - ballRadius,
                child: Container(
                  width: ballRadius * 2,
                  height: ballRadius * 2,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
