import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';

void main() {
  runApp(const GravityMazeApp());
}

class GravityMazeApp extends StatelessWidget {
  const GravityMazeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GravityMazeScreen(),
    );
  }
}

class GravityMazeScreen extends StatefulWidget {
  const GravityMazeScreen({super.key});

  @override
  State<GravityMazeScreen> createState() => _GravityMazeScreenState();
}

class _GravityMazeScreenState extends State<GravityMazeScreen> {
  double ballX = 30;
  double ballY = 0; // Start above the first stair (empty space)
  double velocityX = 0;
  double velocityY = 0;
  double ballRadius = 10;
  double boxWidth = 300;
  double boxHeight = 400;
  double damping = 0.6;
  bool won = false;

  StreamSubscription<AccelerometerEvent>? accelerometerSub;

  final double stepHeight = 50;
  final double stepWidth = 50;
  late List<Rect> steps;
  late Rect goalRect;

  @override
  void initState() {
    super.initState();
    _generateStaircase();

    // Start ball above empty space (first stair removed)
    ballY = 0;

    // Accelerometer for tilt
    accelerometerSub = SensorsPlatform.instance
        .accelerometerEventStream()
        .listen((event) {
          double ax = event.x;
          double ay = event.y;

          velocityX += -ax * 8;
          velocityY += ay * 8;
        });

    Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (won) return;

      double dt = 0.016;
      velocityY += 500 * dt; // gravity

      double nextX = ballX + velocityX * dt;
      double nextY = ballY + velocityY * dt;

      Rect ballRect = Rect.fromCircle(
        center: Offset(nextX, nextY),
        radius: ballRadius,
      );

      // Collisions with stairs
      for (Rect step in steps) {
        if (ballRect.overlaps(step)) {
          // Ball lands on top
          if (ballY + ballRadius <= step.top &&
              nextY + ballRadius >= step.top) {
            nextY = step.top - ballRadius;
            velocityY = 0;
          }
          // Left collision
          else if (ballX < step.left && nextX + ballRadius >= step.left) {
            nextX = step.left - ballRadius;
            velocityX = 0;
          }
          // Right collision
          else if (ballX > step.right && nextX - ballRadius <= step.right) {
            nextX = step.right + ballRadius;
            velocityX = 0;
          }
          // Top collision
          else if (ballY - ballRadius >= step.bottom &&
              nextY - ballRadius <= step.bottom) {
            nextY = step.bottom + ballRadius;
            velocityY = 0;
          }
        }
      }

      // Boundary collisions
      if (nextX - ballRadius < 0) {
        nextX = ballRadius;
        velocityX = -velocityX * damping;
      }
      if (nextX + ballRadius > boxWidth) {
        nextX = boxWidth - ballRadius;
        velocityX = -velocityX * damping;
      }
      if (nextY - ballRadius < 0) {
        nextY = ballRadius;
        velocityY = -velocityY * damping;
      }
      if (nextY + ballRadius > boxHeight) {
        nextY = boxHeight - ballRadius;
        velocityY = -velocityY * damping;
      }

      ballX = nextX;
      ballY = nextY;

      // Friction
      velocityX *= 0.98;
      velocityY *= 0.98;

      // Check goal
      if (goalRect.contains(Offset(ballX, ballY))) {
        won = true;
      }

      setState(() {});
    });
  }

  void _generateStaircase() {
    steps = [];
    int numSteps = (boxWidth / stepWidth).floor();

    // Staircase top-left down
    for (int i = 0; i < numSteps; i++) {
      // Skip the first stair to create empty space under the ball
      if (i == 0) continue;

      steps.add(
        Rect.fromLTWH(0, i * stepHeight, (i + 1) * stepWidth, stepHeight),
      );
    }

    // Goal on last step, right side
    Rect lastStep = steps.last;
    goalRect = Rect.fromLTWH(lastStep.right - 25, lastStep.top - 20, 20, 20);
  }

  void _resetGame() {
    setState(() {
      won = false;
      ballX = 30;
      ballY = 0; // Above first stair
      velocityX = 0;
      velocityY = 0;
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
      appBar: AppBar(title: const Text("Gravity Staircase Maze")),
      body: Center(
        child: Stack(
          children: [
            Container(
              width: boxWidth,
              height: boxHeight,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 3),
              ),
              child: Stack(
                children: [
                  // Draw steps
                  for (Rect step in steps)
                    Positioned(
                      left: step.left,
                      top: step.top,
                      child: Container(
                        width: step.width,
                        height: step.height,
                        color: Colors.black,
                      ),
                    ),
                  // Goal
                  Positioned(
                    left: goalRect.left,
                    top: goalRect.top,
                    child: Container(
                      width: goalRect.width,
                      height: goalRect.height,
                      color: Colors.green,
                    ),
                  ),
                  // Ball
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
            if (won)
              Positioned.fill(
                child: Container(
                  color: Colors.black54,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "You Win!",
                          style: TextStyle(
                            color: Colors.yellow,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _resetGame,
                          child: const Text("New Game"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
