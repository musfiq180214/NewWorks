// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:sensors_plus/sensors_plus.dart';

// void main() {
//   runApp(const GravityMazeApp());
// }

// class GravityMazeApp extends StatelessWidget {
//   const GravityMazeApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: LevelSelectScreen(),
//     );
//   }
// }

// /// ---------------- LEVEL SELECT ----------------
// class LevelSelectScreen extends StatelessWidget {
//   const LevelSelectScreen({super.key});
//   final int totalLevels = 11;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Gravity Maze — Select Level'),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: GridView.builder(
//           itemCount: totalLevels,
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 3,
//             crossAxisSpacing: 12,
//             mainAxisSpacing: 12,
//             childAspectRatio: 1.2,
//           ),
//           itemBuilder: (context, index) {
//             final level = index + 1;
//             return ElevatedButton(
//               onPressed: () {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => GravityMazeScreen(level: level),
//                   ),
//                 );
//               },
//               child: Text('Level $level'),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// /// ---------------- GAME SCREEN ----------------
// class GravityMazeScreen extends StatefulWidget {
//   final int level;
//   const GravityMazeScreen({super.key, required this.level});

//   @override
//   State<GravityMazeScreen> createState() => _GravityMazeScreenState();
// }

// class _GravityMazeScreenState extends State<GravityMazeScreen> {
//   // Ball properties
//   double ballX = 30;
//   double ballY = 0;
//   double velocityX = 0;
//   double velocityY = 0;
//   final double ballRadius = 10;

//   // Game box
//   final double boxWidth = 300;
//   final double boxHeight = 400;

//   // Physics
//   final double gravityAccel = 500;
//   final double damping = 0.6;
//   final double friction = 0.98;

//   bool won = false;
//   bool gameOver = false;

//   // Level elements
//   late List<Rect> steps;
//   late Rect goalRect;
//   List<double> barVelocities = [];
//   List<Offset> fanCenters = [];
//   List<double> fanAngles = [];
//   List<double> fanSpeeds = [];
//   final double fanRadius = 15;
//   final int fanBlades = 4;
//   List<Rect> landingBars = [];
//   late Rect startBar;

//   StreamSubscription<AccelerometerEvent>? accelSub;
//   Timer? _gameTimer;

//   @override
//   void initState() {
//     super.initState();
//     _generateLevel(widget.level);

//     // Physics for all levels
//     accelSub = SensorsPlatform.instance.accelerometerEventStream().listen((e) {
//       velocityX += -e.x * 8;
//       velocityY += e.y * 8;
//     });

//     _gameTimer = Timer.periodic(
//       const Duration(milliseconds: 16),
//       (_) => _tick(),
//     );
//   }

//   /// ---------------- PHYSICS TICK ----------------
//   void _tick() {
//     if (won || gameOver) return;
//     final double dt = 0.016;

//     // Rotate fans only in level 11
//     if (widget.level == 11) {
//       for (int i = 0; i < fanAngles.length; i++) {
//         fanAngles[i] += fanSpeeds[i] * dt;
//         fanAngles[i] %= 2 * pi;
//       }
//     }

//     // Apply gravity
//     velocityY += gravityAccel * dt;

//     double nextX = ballX + velocityX * dt;
//     double nextY = ballY + velocityY * dt;
//     Rect ballRect = Rect.fromCircle(
//       center: Offset(nextX, nextY),
//       radius: ballRadius,
//     );

//     // Collision with steps/landing bars
//     List<Rect> collisionRects = [];
//     if (widget.level == 11) {
//       collisionRects.add(startBar);
//       collisionRects.addAll(landingBars);
//     } else {
//       collisionRects.addAll(steps);
//     }

//     for (Rect rect in collisionRects) {
//       if (ballRect.overlaps(rect)) {
//         if (ballY + ballRadius <= rect.top && nextY + ballRadius >= rect.top) {
//           nextY = rect.top - ballRadius;
//           velocityY = 0;
//         }
//       }
//     }

//     // Fan collision (level 11)
//     if (widget.level == 11) {
//       for (int i = 0; i < fanCenters.length; i++) {
//         Offset center = fanCenters[i];
//         double dx = nextX - center.dx;
//         double dy = nextY - center.dy;
//         double dist = sqrt(dx * dx + dy * dy);
//         if (dist <= fanRadius + ballRadius) {
//           double angleStep = 2 * pi / fanBlades;
//           for (int b = 0; b < fanBlades; b++) {
//             double bladeAngle = fanAngles[i] + b * angleStep;
//             double bladeX = center.dx + cos(bladeAngle) * fanRadius;
//             double bladeY = center.dy + sin(bladeAngle) * fanRadius;
//             double d = sqrt(pow(nextX - bladeX, 2) + pow(nextY - bladeY, 2));
//             if (d <= ballRadius) {
//               gameOver = true;
//               break;
//             }
//           }
//         }
//       }
//     }

//     // Boundaries
//     if (nextX - ballRadius < 0) {
//       nextX = ballRadius;
//       velocityX = -velocityX * damping;
//     }
//     if (nextX + ballRadius > boxWidth) {
//       nextX = boxWidth - ballRadius;
//       velocityX = -velocityX * damping;
//     }
//     if (nextY - ballRadius < 0) {
//       nextY = ballRadius;
//       velocityY = -velocityY * damping;
//     }
//     if (nextY + ballRadius > boxHeight) {
//       nextY = boxHeight - ballRadius;
//       velocityY = -velocityY * damping;
//     }

//     ballX = nextX;
//     ballY = nextY;
//     velocityX *= friction;
//     velocityY *= friction;

//     // Check goal
//     if (goalRect.contains(Offset(ballX, ballY))) {
//       won = true;
//     }

//     setState(() {});
//   }

//   /// ---------------- LEVEL GENERATION ----------------
//   void _generateLevel(int level) {
//     steps = [];
//     barVelocities = [];
//     fanCenters = [];
//     fanAngles = [];
//     fanSpeeds = [];
//     landingBars = [];
//     won = false;
//     gameOver = false;
//     velocityX = 0;
//     velocityY = 0;

//     switch (level) {
//       // Levels 1-10 (static steps)
//       case 1:
//         for (int i = 1; i <= 5; i++)
//           steps.add(Rect.fromLTWH(0, i * 60, 50.0 * i, 20));
//         goalRect = Rect.fromLTWH(boxWidth - 40, boxHeight - 60, 25, 25);
//         ballX = 30;
//         ballY = 0;
//         break;
//       case 2:
//         steps = [
//           Rect.fromLTWH(20, 100, 100, 20),
//           Rect.fromLTWH(boxWidth - 140, 160, 120, 20),
//           Rect.fromLTWH(30, 220, 120, 20),
//           Rect.fromLTWH(boxWidth - 140, 280, 120, 20),
//           Rect.fromLTWH(60, 340, 120, 20),
//         ];
//         goalRect = Rect.fromLTWH(80, 310, 25, 25);
//         ballX = 30;
//         ballY = 0;
//         break;
//       case 3:
//         steps = [
//           Rect.fromLTWH(40, 70, 100, 20),
//           Rect.fromLTWH(160, 130, 90, 20),
//           Rect.fromLTWH(20, 200, 130, 20),
//           Rect.fromLTWH(140, 270, 110, 20),
//         ];
//         goalRect = Rect.fromLTWH(boxWidth - 45, boxHeight - 50, 25, 25);
//         ballX = 30;
//         ballY = 0;
//         break;
//       case 4:
//         steps = [
//           Rect.fromLTWH(20, 40, 100, 20),
//           Rect.fromLTWH(140, 100, 100, 20),
//           Rect.fromLTWH(60, 160, 120, 20),
//           Rect.fromLTWH(180, 220, 80, 20),
//           Rect.fromLTWH(40, 280, 100, 20),
//           Rect.fromLTWH(120, 340, 100, 20),
//         ];
//         goalRect = Rect.fromLTWH(140, 310, 25, 25);
//         ballX = 30;
//         ballY = 0;
//         break;
//       case 5:
//         for (int i = 0; i < 6; i++)
//           steps.add(Rect.fromLTWH(i * 40, 60 * i + 30, 60, 20));
//         goalRect = Rect.fromLTWH(boxWidth - 38, boxHeight - 44, 25, 25);
//         ballX = 30;
//         ballY = 0;
//         break;
//       case 6:
//         steps = [
//           Rect.fromLTWH(0, 80, 120, 20),
//           Rect.fromLTWH(160, 150, 110, 20),
//           Rect.fromLTWH(40, 230, 120, 20),
//           Rect.fromLTWH(150, 300, 120, 20),
//         ];
//         goalRect = Rect.fromLTWH(boxWidth - 40, boxHeight - 46, 25, 25);
//         ballX = 30;
//         ballY = 0;
//         break;
//       case 7:
//         steps = [
//           Rect.fromLTWH(20, 80, 80, 20),
//           Rect.fromLTWH(140, 140, 100, 20),
//           Rect.fromLTWH(50, 200, 120, 20),
//           Rect.fromLTWH(180, 260, 80, 20),
//           Rect.fromLTWH(40, 320, 100, 20),
//           Rect.fromLTWH(120, 380, 100, 20),
//         ];
//         goalRect = Rect.fromLTWH(140, 350, 25, 25);
//         ballX = 30;
//         ballY = 0;
//         break;
//       case 8:
//         steps = [
//           Rect.fromLTWH(40, 100, 160, 20),
//           Rect.fromLTWH(80, 160, 160, 20),
//           Rect.fromLTWH(120, 220, 160, 20),
//           Rect.fromLTWH(160, 280, 120, 20),
//         ];
//         goalRect = Rect.fromLTWH(boxWidth - 45, boxHeight - 50, 25, 25);
//         ballX = 30;
//         ballY = 0;
//         break;
//       case 9:
//         steps = [
//           Rect.fromLTWH(0, 100, 120, 20),
//           Rect.fromLTWH(140, 160, 100, 20),
//           Rect.fromLTWH(60, 220, 140, 20),
//           Rect.fromLTWH(180, 280, 100, 20),
//           Rect.fromLTWH(80, 340, 140, 20),
//         ];
//         goalRect = Rect.fromLTWH(boxWidth - 45, 380, 25, 25);
//         ballX = 30;
//         ballY = 0;
//         break;
//       case 10:
//         steps = [
//           Rect.fromLTWH(40, 100, 80, 20),
//           Rect.fromLTWH(160, 140, 80, 20),
//           Rect.fromLTWH(70, 180, 100, 20),
//           Rect.fromLTWH(150, 220, 100, 20),
//           Rect.fromLTWH(60, 260, 120, 20),
//         ];
//         barVelocities = [60, -50, 40, -60, 50];
//         goalRect = Rect.fromLTWH(boxWidth - 45, 300, 25, 25);
//         ballX = 80;
//         ballY = steps[0].top - ballRadius;
//         break;
//       case 11:
//         // Fans level
//         startBar = Rect.fromLTWH(120, 80, 60, 20);
//         ballX = startBar.left + startBar.width / 2;
//         ballY = startBar.top - ballRadius;

//         fanCenters = [
//           Offset(40, 200),
//           Offset(100, 200),
//           Offset(180, 200),
//           Offset(240, 200),
//         ];
//         fanAngles = [0, 0, 0, 0];
//         fanSpeeds = [5, -5, 4, -4];

//         landingBars = [
//           Rect.fromLTWH(55, 200 + fanRadius + 25, 90, 12),
//           Rect.fromLTWH(175, 200 + fanRadius + 25, 90, 12),
//         ];

//         goalRect = Rect.fromLTWH(150, 350, 25, 25);
//         break;
//     }
//   }

//   void _restartLevel() {
//     setState(() {
//       _generateLevel(widget.level);
//     });
//   }

//   @override
//   void dispose() {
//     accelSub?.cancel();
//     _gameTimer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Text('Gravity Maze — Level ${widget.level}'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             tooltip: 'Level Select',
//             onPressed: () {
//               Navigator.pushAndRemoveUntil(
//                 context,
//                 MaterialPageRoute(builder: (_) => const LevelSelectScreen()),
//                 (route) => false,
//               );
//             },
//           ),
//         ],
//       ),
//       body: Center(
//         child: Stack(
//           children: [
//             Container(
//               width: boxWidth,
//               height: boxHeight,
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.blue, width: 3),
//               ),
//               child: Stack(
//                 children: [
//                   // Steps for levels 1-10
//                   if (widget.level <= 10)
//                     for (Rect step in steps)
//                       Positioned(
//                         left: step.left,
//                         top: step.top,
//                         child: Container(
//                           width: step.width,
//                           height: step.height,
//                           color: Colors.black,
//                         ),
//                       ),
//                   // Start bar for level 11
//                   if (widget.level == 11)
//                     Positioned(
//                       left: startBar.left,
//                       top: startBar.top,
//                       child: Container(
//                         width: startBar.width,
//                         height: startBar.height,
//                         color: Colors.black,
//                       ),
//                     ),
//                   // Landing bars for level 11
//                   if (widget.level == 11)
//                     for (Rect bar in landingBars)
//                       Positioned(
//                         left: bar.left,
//                         top: bar.top,
//                         child: Container(
//                           width: bar.width,
//                           height: bar.height,
//                           color: Colors.brown,
//                         ),
//                       ),
//                   // Fans level 11
//                   if (widget.level == 11)
//                     for (int i = 0; i < fanCenters.length; i++)
//                       Positioned(
//                         left: fanCenters[i].dx - fanRadius,
//                         top: fanCenters[i].dy - fanRadius,
//                         child: Transform.rotate(
//                           angle: fanAngles[i],
//                           child: CustomPaint(
//                             size: Size(fanRadius * 2, fanRadius * 2),
//                             painter: FanPainter(fanBlades),
//                           ),
//                         ),
//                       ),
//                   // Goal
//                   Positioned(
//                     left: goalRect.left,
//                     top: goalRect.top,
//                     child: Container(
//                       width: goalRect.width,
//                       height: goalRect.height,
//                       color: Colors.green,
//                     ),
//                   ),
//                   // Ball
//                   Positioned(
//                     left: ballX - ballRadius,
//                     top: ballY - ballRadius,
//                     child: Container(
//                       width: ballRadius * 2,
//                       height: ballRadius * 2,
//                       decoration: const BoxDecoration(
//                         color: Colors.red,
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             if (won || gameOver)
//               Positioned.fill(
//                 child: Container(
//                   color: Colors.black54,
//                   child: Center(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           won ? '✅ Level Complete!' : '💀 Game Over!',
//                           style: const TextStyle(
//                             color: Colors.yellow,
//                             fontSize: 26,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 18),
//                         ElevatedButton(
//                           onPressed: _restartLevel,
//                           child: Text(won ? 'Play Again' : 'Retry'),
//                         ),
//                         const SizedBox(height: 10),
//                         if (won && widget.level < 11)
//                           ElevatedButton(
//                             onPressed: () {
//                               Navigator.pushReplacement(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (_) => GravityMazeScreen(
//                                     level: widget.level + 1,
//                                   ),
//                                 ),
//                               );
//                             },
//                             child: const Text('Next Level'),
//                           ),
//                         if (won && widget.level == 11)
//                           ElevatedButton(
//                             onPressed: () {
//                               Navigator.pushAndRemoveUntil(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (_) => const LevelSelectScreen(),
//                                 ),
//                                 (route) => false,
//                               );
//                             },
//                             child: const Text('Back to Levels'),
//                           ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class FanPainter extends CustomPainter {
//   final int blades;
//   FanPainter(this.blades);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.grey.shade800
//       ..strokeWidth = 3
//       ..strokeCap = StrokeCap.round;

//     final center = Offset(size.width / 2, size.height / 2);
//     final radius = size.width / 2;

//     for (int i = 0; i < blades; i++) {
//       double angle = i * 2 * pi / blades;
//       final x = center.dx + cos(angle) * radius;
//       final y = center.dy + sin(angle) * radius;
//       canvas.drawLine(center, Offset(x, y), paint);
//     }
//   }

//   @override
//   bool shouldRepaint(covariant FanPainter oldDelegate) => true;
// }

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  runApp(const GravityMazeApp());
}

class GravityMazeApp extends StatelessWidget {
  const GravityMazeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LevelSelectScreen(),
    );
  }
}

/// ---------------- LEVEL SELECT ----------------
class LevelSelectScreen extends StatelessWidget {
  const LevelSelectScreen({super.key});
  final int totalLevels = 11;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gravity Maze — Select Level'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: totalLevels,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemBuilder: (context, index) {
            final level = index + 1;
            return ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GravityMazeScreen(level: level),
                  ),
                );
              },
              child: Text('Level $level'),
            );
          },
        ),
      ),
    );
  }
}

/// ---------------- GAME SCREEN ----------------
class GravityMazeScreen extends StatefulWidget {
  final int level;
  const GravityMazeScreen({super.key, required this.level});

  @override
  State<GravityMazeScreen> createState() => _GravityMazeScreenState();
}

class _GravityMazeScreenState extends State<GravityMazeScreen> {
  // Ball properties
  double ballX = 30;
  double ballY = 0;
  double velocityX = 0;
  double velocityY = 0;
  final double ballRadius = 10;

  // Game box
  final double boxWidth = 300;
  final double boxHeight = 400;

  // Physics
  final double gravityAccel = 500;
  final double damping = 0.6;
  final double friction = 0.98;

  bool won = false;
  bool gameOver = false;

  // Level elements
  late List<Rect> steps;
  late Rect goalRect;
  List<double> barVelocities = [];
  List<Offset> fanCenters = [];
  List<double> fanAngles = [];
  List<double> fanSpeeds = [];
  final double fanRadius = 15;
  final int fanBlades = 4;
  List<Rect> landingBars = [];
  late Rect startBar;

  // Spikes
  late List<Rect> floorSpikes;
  final double spikeWidth = 20;
  final double spikeHeight = 20;

  StreamSubscription<AccelerometerEvent>? accelSub;
  Timer? _gameTimer;

  @override
  void initState() {
    super.initState();
    _generateLevel(widget.level);

    accelSub = SensorsPlatform.instance.accelerometerEventStream().listen((e) {
      velocityX += -e.x * 8;
      velocityY += e.y * 8;
    });

    _gameTimer = Timer.periodic(
      const Duration(milliseconds: 16),
      (_) => _tick(),
    );
  }

  /// ---------------- PHYSICS TICK ----------------
  void _tick() {
    if (won || gameOver) return;
    final double dt = 0.016;

    // Rotate fans only in level 11
    if (widget.level == 11) {
      for (int i = 0; i < fanAngles.length; i++) {
        fanAngles[i] += fanSpeeds[i] * dt;
        fanAngles[i] %= 2 * pi;
      }
    }

    // Apply gravity
    velocityY += gravityAccel * dt;

    double nextX = ballX + velocityX * dt;
    double nextY = ballY + velocityY * dt;
    Rect ballRect = Rect.fromCircle(
      center: Offset(nextX, nextY),
      radius: ballRadius,
    );

    // Collision with steps/landing bars
    List<Rect> collisionRects = [];
    if (widget.level == 11) {
      collisionRects.add(startBar);
      collisionRects.addAll(landingBars);
    } else {
      collisionRects.addAll(steps);
    }

    for (Rect rect in collisionRects) {
      if (ballRect.overlaps(rect)) {
        if (ballY + ballRadius <= rect.top && nextY + ballRadius >= rect.top) {
          nextY = rect.top - ballRadius;
          velocityY = 0;
        }
      }
    }

    // Fan collision (level 11)
    if (widget.level == 11) {
      for (int i = 0; i < fanCenters.length; i++) {
        Offset center = fanCenters[i];
        double dx = nextX - center.dx;
        double dy = nextY - center.dy;
        double dist = sqrt(dx * dx + dy * dy);
        if (dist <= fanRadius + ballRadius) {
          double angleStep = 2 * pi / fanBlades;
          for (int b = 0; b < fanBlades; b++) {
            double bladeAngle = fanAngles[i] + b * angleStep;
            double bladeX = center.dx + cos(bladeAngle) * fanRadius;
            double bladeY = center.dy + sin(bladeAngle) * fanRadius;
            double d = sqrt(pow(nextX - bladeX, 2) + pow(nextY - bladeY, 2));
            if (d <= ballRadius) {
              gameOver = true;
              break;
            }
          }
        }
      }
    }

    // Spike collision
    for (Rect spike in floorSpikes) {
      if (ballRect.overlaps(spike)) {
        gameOver = true;
        break;
      }
    }

    // Boundaries
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
    velocityX *= friction;
    velocityY *= friction;

    // Check goal
    if (goalRect.contains(Offset(ballX, ballY))) {
      won = true;
    }

    setState(() {});
  }

  /// ---------------- LEVEL GENERATION ----------------
  void _generateLevel(int level) {
    steps = [];
    barVelocities = [];
    fanCenters = [];
    fanAngles = [];
    fanSpeeds = [];
    landingBars = [];
    floorSpikes = [];
    won = false;
    gameOver = false;
    velocityX = 0;
    velocityY = 0;

    // Add floor spikes at regular intervals
    for (double x = 0; x < boxWidth; x += spikeWidth) {
      floorSpikes.add(
        Rect.fromLTWH(x, boxHeight - spikeHeight, spikeWidth, spikeHeight),
      );
    }

    switch (level) {
      // Levels 1-10
      case 1:
        for (int i = 1; i <= 5; i++) {
          steps.add(Rect.fromLTWH(0, i * 60, 50.0 * i, 20));
        }
        goalRect = Rect.fromLTWH(boxWidth - 40, boxHeight - 60, 25, 25);
        ballX = 30;
        ballY = 0;
        break;
      case 2:
        steps = [
          Rect.fromLTWH(20, 100, 100, 20),
          Rect.fromLTWH(boxWidth - 140, 160, 120, 20),
          Rect.fromLTWH(30, 220, 120, 20),
          Rect.fromLTWH(boxWidth - 140, 280, 120, 20),
          Rect.fromLTWH(60, 340, 120, 20),
        ];
        goalRect = Rect.fromLTWH(80, 310, 25, 25);
        ballX = 30;
        ballY = 0;
        break;
      case 3:
        steps = [
          Rect.fromLTWH(40, 70, 100, 20),
          Rect.fromLTWH(160, 130, 90, 20),
          Rect.fromLTWH(20, 200, 130, 20),
          Rect.fromLTWH(140, 270, 110, 20),
        ];
        goalRect = Rect.fromLTWH(boxWidth - 45, boxHeight - 50, 25, 25);
        ballX = 30;
        ballY = 0;
        break;
      case 4:
        steps = [
          Rect.fromLTWH(20, 40, 100, 20),
          Rect.fromLTWH(140, 100, 100, 20),
          Rect.fromLTWH(60, 160, 120, 20),
          Rect.fromLTWH(180, 220, 80, 20),
          Rect.fromLTWH(40, 280, 100, 20),
          Rect.fromLTWH(120, 340, 100, 20),
        ];
        goalRect = Rect.fromLTWH(140, 310, 25, 25);
        ballX = 30;
        ballY = 0;
        break;
      case 5:
        for (int i = 0; i < 6; i++)
          steps.add(Rect.fromLTWH(i * 40, 60 * i + 30, 60, 20));
        goalRect = Rect.fromLTWH(boxWidth - 38, boxHeight - 44, 25, 25);
        ballX = 30;
        ballY = 0;
        break;
      case 6:
        steps = [
          Rect.fromLTWH(0, 80, 120, 20),
          Rect.fromLTWH(160, 150, 110, 20),
          Rect.fromLTWH(40, 230, 120, 20),
          Rect.fromLTWH(150, 300, 120, 20),
        ];
        goalRect = Rect.fromLTWH(boxWidth - 40, boxHeight - 46, 25, 25);
        ballX = 30;
        ballY = 0;
        break;
      case 7:
        steps = [
          Rect.fromLTWH(20, 80, 80, 20),
          Rect.fromLTWH(140, 140, 100, 20),
          Rect.fromLTWH(50, 200, 120, 20),
          Rect.fromLTWH(180, 260, 80, 20),
          Rect.fromLTWH(40, 320, 100, 20),
          Rect.fromLTWH(120, 380, 100, 20),
        ];
        goalRect = Rect.fromLTWH(140, 350, 25, 25);
        ballX = 30;
        ballY = 0;
        break;
      case 8:
        steps = [
          Rect.fromLTWH(40, 100, 160, 20),
          Rect.fromLTWH(80, 160, 160, 20),
          Rect.fromLTWH(120, 220, 160, 20),
          Rect.fromLTWH(160, 280, 120, 20),
        ];
        goalRect = Rect.fromLTWH(boxWidth - 45, boxHeight - 50, 25, 25);
        ballX = 30;
        ballY = 0;
        break;
      case 9:
        steps = [
          Rect.fromLTWH(0, 100, 120, 20),
          Rect.fromLTWH(140, 160, 100, 20),
          Rect.fromLTWH(60, 220, 140, 20),
          Rect.fromLTWH(180, 280, 100, 20),
          Rect.fromLTWH(80, 340, 140, 20),
        ];
        // Raise goal above spikes (20 px spikes + extra margin)
        goalRect = Rect.fromLTWH(
          boxWidth - 45,
          boxHeight - spikeHeight - 40,
          25,
          25,
        );
        ballX = 30;
        ballY = 0;
        break;

      case 10:
        steps = [
          Rect.fromLTWH(40, 100, 80, 20),
          Rect.fromLTWH(160, 140, 80, 20),
          Rect.fromLTWH(70, 180, 100, 20),
          Rect.fromLTWH(150, 220, 100, 20),
          Rect.fromLTWH(60, 260, 120, 20),
        ];
        barVelocities = [60, -50, 40, -60, 50];
        goalRect = Rect.fromLTWH(boxWidth - 45, 300, 25, 25);
        ballX = 80;
        ballY = steps[0].top - ballRadius;
        break;

      case 11:
        startBar = Rect.fromLTWH(120, 80, 60, 20);
        ballX = startBar.left + startBar.width / 2;
        ballY = startBar.top - ballRadius;

        fanCenters = [
          Offset(40, 200),
          Offset(100, 200),
          Offset(180, 200),
          Offset(240, 200),
        ];
        fanAngles = [0, 0, 0, 0];
        fanSpeeds = [5, -5, 4, -4];

        landingBars = [
          Rect.fromLTWH(55, 200 + fanRadius + 25, 90, 12),
          Rect.fromLTWH(175, 200 + fanRadius + 25, 90, 12),
        ];

        goalRect = Rect.fromLTWH(150, 350, 25, 25);
        break;
    }
  }

  void _restartLevel() {
    setState(() {
      _generateLevel(widget.level);
    });
  }

  @override
  void dispose() {
    accelSub?.cancel();
    _gameTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Gravity Maze — Level ${widget.level}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Level Select',
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LevelSelectScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
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
                  // Steps for levels 1-10
                  if (widget.level <= 10)
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
                  // Start bar for level 11
                  if (widget.level == 11)
                    Positioned(
                      left: startBar.left,
                      top: startBar.top,
                      child: Container(
                        width: startBar.width,
                        height: startBar.height,
                        color: Colors.black,
                      ),
                    ),
                  // Landing bars for level 11
                  if (widget.level == 11)
                    for (Rect bar in landingBars)
                      Positioned(
                        left: bar.left,
                        top: bar.top,
                        child: Container(
                          width: bar.width,
                          height: bar.height,
                          color: Colors.brown,
                        ),
                      ),
                  // Fans level 11
                  if (widget.level == 11)
                    for (int i = 0; i < fanCenters.length; i++)
                      Positioned(
                        left: fanCenters[i].dx - fanRadius,
                        top: fanCenters[i].dy - fanRadius,
                        child: Transform.rotate(
                          angle: fanAngles[i],
                          child: CustomPaint(
                            size: Size(fanRadius * 2, fanRadius * 2),
                            painter: FanPainter(fanBlades),
                          ),
                        ),
                      ),
                  // Spikes
                  for (Rect spike in floorSpikes)
                    Positioned(
                      left: spike.left,
                      top: spike.top,
                      child: CustomPaint(
                        size: Size(spike.width, spike.height),
                        painter: SpikePainter(),
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
            if (won || gameOver)
              Positioned.fill(
                child: Container(
                  color: Colors.black54,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          won ? '✅ Level Complete!' : '💀 Game Over!',
                          style: const TextStyle(
                            color: Colors.yellow,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 18),
                        ElevatedButton(
                          onPressed: _restartLevel,
                          child: Text(won ? 'Play Again' : 'Retry'),
                        ),
                        const SizedBox(height: 10),
                        if (won && widget.level < 11)
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => GravityMazeScreen(
                                    level: widget.level + 1,
                                  ),
                                ),
                              );
                            },
                            child: const Text('Next Level'),
                          ),
                        if (won && widget.level == 11)
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LevelSelectScreen(),
                                ),
                                (route) => false,
                              );
                            },
                            child: const Text('Back to Levels'),
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

class FanPainter extends CustomPainter {
  final int blades;
  FanPainter(this.blades);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade800
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    for (int i = 0; i < blades; i++) {
      double angle = i * 2 * pi / blades;
      final x = center.dx + cos(angle) * radius;
      final y = center.dy + sin(angle) * radius;
      canvas.drawLine(center, Offset(x, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant FanPainter oldDelegate) => true;
}

class SpikePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant SpikePainter oldDelegate) => false;
}
