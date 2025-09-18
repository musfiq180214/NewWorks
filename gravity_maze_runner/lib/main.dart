// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:sensors_plus/sensors_plus.dart';

// void main() {
//   runApp(const GravityMazeApp());
// }

// /// ---------------- MAIN APP ----------------
// class GravityMazeApp extends StatelessWidget {
//   const GravityMazeApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: ModeSelectScreen(),
//     );
//   }
// }

// /// ---------------- MODE SELECT ----------------
// class ModeSelectScreen extends StatelessWidget {
//   const ModeSelectScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Gravity Maze — Select Mode')),
//       body: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => const LevelSelectScreen(isProMode: false),
//                   ),
//                 );
//               },
//               child: const Text('Rookie Mode (No Timer)'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => const LevelSelectScreen(isProMode: true),
//                   ),
//                 );
//               },
//               child: const Text('Pro Mode (Timed Levels)'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// /// ---------------- LEVEL SELECT ----------------
// class LevelSelectScreen extends StatelessWidget {
//   final bool isProMode;
//   const LevelSelectScreen({super.key, required this.isProMode});
//   final int totalLevels = 11;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Gravity Maze — Select Level (${isProMode ? "Pro" : "Rookie"})',
//         ),
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pushAndRemoveUntil(
//               context,
//               MaterialPageRoute(builder: (_) => const ModeSelectScreen()),
//               (route) => false,
//             );
//           },
//         ),
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
//                     builder: (_) =>
//                         GravityMazeScreen(level: level, isProMode: isProMode),
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

// class FanBladePainter extends CustomPainter {
//   final int blades;
//   FanBladePainter(this.blades);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()..color = Colors.purple;
//     final center = Offset(size.width / 2, size.height / 2);
//     final radius = size.width / 2;

//     for (int i = 0; i < blades; i++) {
//       double angle = 2 * pi * i / blades;
//       Path path = Path();
//       // Create a sharp triangular blade
//       Offset tip = Offset(
//         center.dx + radius * cos(angle),
//         center.dy + radius * sin(angle),
//       );
//       Offset base1 = Offset(
//         center.dx + radius * 0.3 * cos(angle + pi / 20),
//         center.dy + radius * 0.3 * sin(angle + pi / 20),
//       );
//       Offset base2 = Offset(
//         center.dx + radius * 0.3 * cos(angle - pi / 20),
//         center.dy + radius * 0.3 * sin(angle - pi / 20),
//       );
//       path.moveTo(center.dx, center.dy);
//       path.lineTo(base1.dx, base1.dy);
//       path.lineTo(tip.dx, tip.dy);
//       path.lineTo(base2.dx, base2.dy);
//       path.close();
//       canvas.drawPath(path, paint);
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }

// /// ---------------- GAME SCREEN ----------------
// enum GameStatus { playing, won, gameOver }

// class GravityMazeScreen extends StatefulWidget {
//   final int level;
//   final bool isProMode;
//   const GravityMazeScreen({
//     super.key,
//     required this.level,
//     required this.isProMode,
//   });

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

//   GameStatus gameStatus = GameStatus.playing;

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

//   // Spikes
//   late List<Rect> floorSpikes;
//   final double spikeWidth = 20;
//   final double spikeHeight = 20;

//   // Timer
//   late int levelTime; // seconds
//   late int remainingTime;
//   Timer? _countdownTimer;

//   StreamSubscription<AccelerometerEvent>? accelSub;
//   Timer? _gameTimer;

//   @override
//   void initState() {
//     super.initState();
//     _generateLevel(widget.level);

//     accelSub = SensorsPlatform.instance.accelerometerEventStream().listen((e) {
//       velocityX += -e.x * 8;
//       velocityY += e.y * 8;
//     });

//     _gameTimer = Timer.periodic(
//       const Duration(milliseconds: 16),
//       (_) => _tick(),
//     );

//     if (widget.isProMode) {
//       _startLevelTimer();
//     }
//   }

//   /// ---------------- LEVEL TIMER ----------------
//   void _startLevelTimer() {
//     remainingTime = levelTime;
//     _countdownTimer?.cancel();
//     _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
//       if (gameStatus != GameStatus.playing) {
//         _countdownTimer?.cancel();
//         return;
//       }
//       setState(() {
//         remainingTime--;
//         if (remainingTime <= 0) {
//           gameStatus = GameStatus.gameOver;
//           _countdownTimer?.cancel();
//         }
//       });
//     });
//   }

//   /// ---------------- PHYSICS TICK ----------------
//   void _tick() {
//     if (gameStatus != GameStatus.playing) return;

//     final double dt = 0.016;

//     if (widget.level == 11) {
//       for (int i = 0; i < fanAngles.length; i++) {
//         fanAngles[i] += fanSpeeds[i] * dt;
//         fanAngles[i] %= 2 * pi;
//       }
//     }

//     velocityY += gravityAccel * dt;

//     double nextX = ballX + velocityX * dt;
//     double nextY = ballY + velocityY * dt;
//     Rect ballRect = Rect.fromCircle(
//       center: Offset(nextX, nextY),
//       radius: ballRadius,
//     );

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
//               gameStatus = GameStatus.gameOver;
//               break;
//             }
//           }
//         }
//       }
//     }

//     for (Rect spike in floorSpikes) {
//       if (ballRect.overlaps(spike)) {
//         gameStatus = GameStatus.gameOver;
//         break;
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

//     if (goalRect.contains(Offset(ballX, ballY))) {
//       gameStatus = GameStatus.won;
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
//     floorSpikes = [];
//     gameStatus = GameStatus.playing;
//     velocityX = 0;
//     velocityY = 0;

//     final levelTimes = {
//       1: 5,
//       2: 7,
//       3: 6,
//       4: 8,
//       5: 4,
//       6: 4,
//       7: 8,
//       8: 6,
//       9: 5,
//       10: 3,
//       11: 4,
//     };
//     levelTime = levelTimes[level] ?? 20;

//     for (double x = 0; x < boxWidth; x += spikeWidth) {
//       floorSpikes.add(
//         Rect.fromLTWH(x, boxHeight - spikeHeight, spikeWidth, spikeHeight),
//       );
//     }

//     switch (level) {
//       case 1:
//         for (int i = 1; i <= 5; i++) {
//           steps.add(Rect.fromLTWH(0, i * 60, 50.0 * i, 20));
//         }
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
//         for (int i = 0; i < 6; i++) {
//           steps.add(Rect.fromLTWH(i * 40, 60 * i + 30, 60, 20));
//         }
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
//         goalRect = Rect.fromLTWH(
//           boxWidth - 45,
//           boxHeight - spikeHeight - 40,
//           25,
//           25,
//         );
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

//   @override
//   void dispose() {
//     accelSub?.cancel();
//     _gameTimer?.cancel();
//     _countdownTimer?.cancel();
//     super.dispose();
//   }

//   /// ---------------- BUILD ----------------
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Level ${widget.level}'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pushAndRemoveUntil(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => LevelSelectScreen(isProMode: widget.isProMode),
//               ),
//               (route) => false,
//             );
//           },
//         ),
//       ),
//       body: Center(
//         child: Stack(
//           children: [
//             Container(
//               width: boxWidth,
//               height: boxHeight,
//               color: Colors.grey[300],
//             ),
//             for (var step in steps)
//               Positioned(
//                 left: step.left,
//                 top: step.top,
//                 child: Container(
//                   width: step.width,
//                   height: step.height,
//                   color: Colors.brown,
//                 ),
//               ),
//             if (widget.level == 11)
//               Positioned(
//                 left: startBar.left,
//                 top: startBar.top,
//                 child: Container(
//                   width: startBar.width,
//                   height: startBar.height,
//                   color: Colors.blue,
//                 ),
//               ),
//             for (var bar in landingBars)
//               Positioned(
//                 left: bar.left,
//                 top: bar.top,
//                 child: Container(
//                   width: bar.width,
//                   height: bar.height,
//                   color: Colors.orange,
//                 ),
//               ),
//             if (widget.level == 11)
//               for (int i = 0; i < fanCenters.length; i++)
//                 Positioned(
//                   left: fanCenters[i].dx - fanRadius,
//                   top: fanCenters[i].dy - fanRadius,
//                   child: Transform.rotate(
//                     angle: fanAngles[i],
//                     child: CustomPaint(
//                       size: Size(fanRadius * 2, fanRadius * 2),
//                       painter: FanBladePainter(fanBlades),
//                     ),
//                   ),
//                 ),
//             Positioned(
//               left: goalRect.left,
//               top: goalRect.top,
//               child: Container(
//                 width: goalRect.width,
//                 height: goalRect.height,
//                 color: Colors.green,
//               ),
//             ),
//             Positioned(
//               left: ballX - ballRadius,
//               top: ballY - ballRadius,
//               child: Container(
//                 width: ballRadius * 2,
//                 height: ballRadius * 2,
//                 decoration: const BoxDecoration(
//                   color: Colors.red,
//                   shape: BoxShape.circle,
//                 ),
//               ),
//             ),
//             for (var spike in floorSpikes)
//               Positioned(
//                 left: spike.left,
//                 top: spike.top,
//                 child: Container(
//                   width: spike.width,
//                   height: spike.height,
//                   color: Colors.black,
//                 ),
//               ),
//             if (widget.isProMode)
//               Positioned(
//                 top: 10,
//                 left: 10,
//                 child: Text(
//                   'Time: $remainingTime s',
//                   style: const TextStyle(fontSize: 20),
//                 ),
//               ),

//             // Overlay: Game over
//             if (gameStatus == GameStatus.gameOver)
//               Positioned.fill(
//                 child: Container(
//                   color: Colors.black45,
//                   child: Center(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Text(
//                           'Game Over',
//                           style: TextStyle(color: Colors.white, fontSize: 30),
//                         ),
//                         const SizedBox(height: 20),
//                         ElevatedButton(
//                           onPressed: () {
//                             Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => LevelSelectScreen(
//                                   isProMode: widget.isProMode,
//                                 ),
//                               ),
//                             );
//                           },
//                           child: const Text('Back to Levels'),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),

//             // Overlay: Won
//             if (gameStatus == GameStatus.won)
//               Positioned.fill(
//                 child: Container(
//                   color: Colors.black45,
//                   child: Center(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Text(
//                           'You Won!',
//                           style: TextStyle(color: Colors.white, fontSize: 30),
//                         ),
//                         const SizedBox(height: 20),
//                         if (widget.level < 11)
//                           ElevatedButton(
//                             onPressed: () {
//                               Navigator.pushReplacement(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (_) => GravityMazeScreen(
//                                     level: widget.level + 1,
//                                     isProMode: widget.isProMode,
//                                   ),
//                                 ),
//                               );
//                             },
//                             child: const Text('Next Level'),
//                           ),
//                         const SizedBox(height: 10),
//                         ElevatedButton(
//                           onPressed: () {
//                             Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => LevelSelectScreen(
//                                   isProMode: widget.isProMode,
//                                 ),
//                               ),
//                             );
//                           },
//                           child: const Text('Back to Levels'),
//                         ),
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

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  runApp(const GravityMazeApp());
}

/// ---------------- MAIN APP ----------------
class GravityMazeApp extends StatelessWidget {
  const GravityMazeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ModeSelectScreen(),
    );
  }
}

/// ---------------- MODE SELECT ----------------
class ModeSelectScreen extends StatelessWidget {
  const ModeSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gravity Maze — Select Mode')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LevelSelectScreen(isProMode: false),
                  ),
                );
              },
              child: const Text('Rookie Mode (No Timer)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LevelSelectScreen(isProMode: true),
                  ),
                );
              },
              child: const Text('Pro Mode (Timed Levels)'),
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------- LEVEL SELECT ----------------
class LevelSelectScreen extends StatelessWidget {
  final bool isProMode;
  const LevelSelectScreen({super.key, required this.isProMode});
  final int totalLevels = 14;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gravity Maze — Select Level (${isProMode ? "Pro" : "Rookie"})',
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const ModeSelectScreen()),
              (route) => false,
            );
          },
        ),
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
                    builder: (_) =>
                        GravityMazeScreen(level: level, isProMode: isProMode),
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

class FanBladePainter extends CustomPainter {
  final int blades;
  FanBladePainter(this.blades);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.purple;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    for (int i = 0; i < blades; i++) {
      double angle = 2 * pi * i / blades;
      Path path = Path();
      // Create a sharp triangular blade
      Offset tip = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      Offset base1 = Offset(
        center.dx + radius * 0.3 * cos(angle + pi / 20),
        center.dy + radius * 0.3 * sin(angle + pi / 20),
      );
      Offset base2 = Offset(
        center.dx + radius * 0.3 * cos(angle - pi / 20),
        center.dy + radius * 0.3 * sin(angle - pi / 20),
      );
      path.moveTo(center.dx, center.dy);
      path.lineTo(base1.dx, base1.dy);
      path.lineTo(tip.dx, tip.dy);
      path.lineTo(base2.dx, base2.dy);
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// ---------------- GAME SCREEN ----------------
enum GameStatus { playing, won, gameOver }

class GravityMazeScreen extends StatefulWidget {
  final int level;
  final bool isProMode;
  const GravityMazeScreen({
    super.key,
    required this.level,
    required this.isProMode,
  });

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

  GameStatus gameStatus = GameStatus.playing;

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

  // Timer
  late int levelTime; // seconds
  late int remainingTime;
  Timer? _countdownTimer;

  StreamSubscription<AccelerometerEvent>? accelSub;
  Timer? _gameTimer;

  // --- NEW MECHANICS ---
  // Springs
  List<Rect> springs = [];
  List<double> springStrengths =
      []; // positive magnitudes (px/s) used as negative velocity

  // Moving platforms
  List<Rect> movingPlatforms = [];
  List<Offset> movingPlatformVelocities = [];

  // Conveyors
  List<Rect> conveyors = [];
  List<double> conveyorSpeeds = [];

  // Portals (must be even-length; paired as 0<->1, 2<->3, ...)
  List<Rect> portals = [];
  double teleportCooldownRemaining = 0.0;

  // Magnets
  List<Offset> magnetsCenters = [];
  List<double> magnetStrengths = [];
  List<double> magnetRadii = [];

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

    if (widget.isProMode) {
      _startLevelTimer();
    }
  }

  /// ---------------- LEVEL TIMER ----------------
  void _startLevelTimer() {
    remainingTime = levelTime;
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (gameStatus != GameStatus.playing) {
        _countdownTimer?.cancel();
        return;
      }
      setState(() {
        remainingTime--;
        if (remainingTime <= 0) {
          gameStatus = GameStatus.gameOver;
          _countdownTimer?.cancel();
        }
      });
    });
  }

  /// ---------------- PHYSICS TICK ----------------
  void _tick() {
    if (gameStatus != GameStatus.playing) return;

    final double dt = 0.016;

    // update fan angles for level 11 (unchanged)
    if (widget.level == 11) {
      for (int i = 0; i < fanAngles.length; i++) {
        fanAngles[i] += fanSpeeds[i] * dt;
        fanAngles[i] %= 2 * pi;
      }
    }

    // update moving platforms (only used in levels that set them)
    for (int i = 0; i < movingPlatforms.length; i++) {
      Offset v = movingPlatformVelocities[i];
      Rect moved = movingPlatforms[i].shift(Offset(v.dx * dt, v.dy * dt));

      // bounce on horizontal bounds
      if (moved.left < 0) {
        moved = moved.shift(Offset(-moved.left, 0));
        movingPlatformVelocities[i] = Offset(-v.dx, v.dy);
      } else if (moved.right > boxWidth) {
        moved = moved.shift(Offset(boxWidth - moved.right, 0));
        movingPlatformVelocities[i] = Offset(-v.dx, v.dy);
      }

      // bounce on vertical bounds
      if (moved.top < 0) {
        moved = moved.shift(Offset(0, -moved.top));
        movingPlatformVelocities[i] = Offset(
          movingPlatformVelocities[i].dx,
          -movingPlatformVelocities[i].dy,
        );
      } else if (moved.bottom > boxHeight) {
        moved = moved.shift(Offset(0, boxHeight - moved.bottom));
        movingPlatformVelocities[i] = Offset(
          movingPlatformVelocities[i].dx,
          -movingPlatformVelocities[i].dy,
        );
      }

      movingPlatforms[i] = moved;
    }

    // gravity
    velocityY += gravityAccel * dt;

    // Basic integrate
    double nextX = ballX + velocityX * dt;
    double nextY = ballY + velocityY * dt;

    // Ball rect at next position
    Rect ballRect = Rect.fromCircle(
      center: Offset(nextX, nextY),
      radius: ballRadius,
    );

    // Build collision rects (preserve original behavior for levels 1-11)
    List<Rect> collisionRects = [];
    if (widget.level == 11) {
      collisionRects.add(startBar);
      collisionRects.addAll(landingBars);
    } else {
      collisionRects.addAll(steps);
    }

    // include moving platforms in collision checks when present (levels that define them)
    if (movingPlatforms.isNotEmpty && (widget.level == 13)) {
      collisionRects.addAll(movingPlatforms);
    }

    // include springs as collision surfaces so the ball can land on them
    if (springs.isNotEmpty && (widget.level == 12)) {
      collisionRects.addAll(springs);
    }

    // include conveyors as collision surfaces for level 14
    if (conveyors.isNotEmpty && (widget.level == 14)) {
      collisionRects.addAll(conveyors);
    }

    // existing collision handling (stops falling through)
    for (Rect rect in collisionRects) {
      if (ballRect.overlaps(rect)) {
        if (ballY + ballRadius <= rect.top && nextY + ballRadius >= rect.top) {
          nextY = rect.top - ballRadius;
          velocityY = 0;
        }
      }
    }

    // SPRINGS (level 12) - bounce effect
    if (widget.level == 12) {
      for (int i = 0; i < springs.length; i++) {
        Rect s = springs[i];
        if (ballRect.overlaps(s)) {
          // only bounce when landing on spring from above
          if (ballY + ballRadius <= s.top && nextY + ballRadius >= s.top) {
            nextY = s.top - ballRadius;
            // springStrength is magnitude; apply negative velocity for upward bounce
            velocityY = -springStrengths[i];
          }
        }
      }
    }

    // MOVING PLATFORMS: if ball stands on a moving platform, carry it horizontally/vertically
    if (widget.level == 13 && movingPlatforms.isNotEmpty) {
      for (int i = 0; i < movingPlatforms.length; i++) {
        Rect p = movingPlatforms[i];
        Offset v = movingPlatformVelocities[i];
        if (ballRect.overlaps(p)) {
          if (ballY + ballRadius <= p.top && nextY + ballRadius >= p.top) {
            // landed on platform
            nextY = p.top - ballRadius;
            velocityY = 0;
            // gently add platform motion to the ball so it moves with it
            velocityX += v.dx * dt * 1.0;
            velocityY += v.dy * dt * 1.0;
          }
        }
      }
    }

    // CONVEYORS: push the ball horizontally when overlapped (level 14)
    if (widget.level == 14 && conveyors.isNotEmpty) {
      for (int i = 0; i < conveyors.length; i++) {
        Rect c = conveyors[i];
        if (ballRect.overlaps(c)) {
          // push the ball horizontally
          velocityX += conveyorSpeeds[i] * dt;
        }
      }
    }

    // FANS (level 11) - unchanged: check blades for collision
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
              gameStatus = GameStatus.gameOver;
              break;
            }
          }
        }
      }
    }

    // PORTALS (level 15)
    teleportCooldownRemaining = max(0.0, teleportCooldownRemaining - dt);
    if (widget.level == 15 &&
        portals.isNotEmpty &&
        teleportCooldownRemaining <= 0.0) {
      for (int i = 0; i < portals.length; i++) {
        Rect p = portals[i];
        if (ballRect.overlaps(p)) {
          int dest = (i % 2 == 0) ? i + 1 : i - 1;
          if (dest >= 0 && dest < portals.length) {
            Rect target = portals[dest];
            // teleport the ball to the center of the paired portal
            nextX = target.left + target.width / 2;
            nextY = target.top + target.height / 2;
            velocityX = 0;
            velocityY = 0;
            teleportCooldownRemaining =
                0.35; // small cooldown to avoid immediate re-teleport
            break;
          }
        }
      }
    }

    // MAGNETS (level 15) - pull the ball toward the magnet center
    if (widget.level == 15 && magnetsCenters.isNotEmpty) {
      for (int i = 0; i < magnetsCenters.length; i++) {
        Offset c = magnetsCenters[i];
        double radius = magnetRadii[i];
        double strength = magnetStrengths[i];
        double dx = (c.dx - nextX);
        double dy = (c.dy - nextY);
        double dist = sqrt(dx * dx + dy * dy);
        if (dist < radius && dist > 1.0) {
          double factor = (1 - (dist / radius)); // closer = stronger
          double ax = (dx / dist) * (strength * factor);
          double ay = (dy / dist) * (strength * factor);
          // apply magnet acceleration to velocity
          velocityX += ax * dt;
          velocityY += ay * dt;
        }
      }
    }

    // Spikes
    for (Rect spike in floorSpikes) {
      if (ballRect.overlaps(spike)) {
        gameStatus = GameStatus.gameOver;
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

    // commit next positions & damping/friction
    ballX = nextX;
    ballY = nextY;
    velocityX *= friction;
    velocityY *= friction;

    // check win
    if (goalRect.contains(Offset(ballX, ballY))) {
      gameStatus = GameStatus.won;
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
    springs = [];
    springStrengths = [];
    movingPlatforms = [];
    movingPlatformVelocities = [];
    conveyors = [];
    conveyorSpeeds = [];
    portals = [];
    teleportCooldownRemaining = 0.0;
    magnetsCenters = [];
    magnetStrengths = [];
    magnetRadii = [];
    gameStatus = GameStatus.playing;
    velocityX = 0;
    velocityY = 0;

    Map<int, int> portalPairs = {};

    final levelTimes = {
      1: 5,
      2: 7,
      3: 6,
      4: 8,
      5: 4,
      6: 4,
      7: 8,
      8: 6,
      9: 5,
      10: 3,
      11: 4,
      12: 8, // spring level
      13: 10, // moving platforms
      14: 10, // portals + magnets
    };
    levelTime = levelTimes[level] ?? 20;

    // floor spikes along bottom (unchanged)
    for (double x = 0; x < boxWidth; x += spikeWidth) {
      floorSpikes.add(
        Rect.fromLTWH(x, boxHeight - spikeHeight, spikeWidth, spikeHeight),
      );
    }

    switch (level) {
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
        for (int i = 0; i < 6; i++) {
          steps.add(Rect.fromLTWH(i * 40, 60 * i + 30, 60, 20));
        }
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

      // --------------- NEW LEVELS ----------------
      case 12:
        // Springs level
        steps = [
          Rect.fromLTWH(0, 120, 100, 18),
          Rect.fromLTWH(180, 160, 110, 18),
          Rect.fromLTWH(80, 240, 100, 18),
        ];
        // springs between steps to bounce across
        springs = [
          Rect.fromLTWH(110, 200, 20, 10),
          Rect.fromLTWH(130, 150, 20, 10),
        ];
        springStrengths = [420.0, 380.0]; // magnitudes (px/s)
        goalRect = Rect.fromLTWH(boxWidth - 38, boxHeight - 44, 25, 25);
        ballX = 30;
        ballY = 0;
        break;

      case 13:
        // Moving platforms level
        movingPlatforms = [
          Rect.fromLTWH(20, 100, 100, 16),
          Rect.fromLTWH(160, 180, 120, 16),
          Rect.fromLTWH(40, 260, 140, 16),
        ];
        movingPlatformVelocities = [
          const Offset(40, 0), // horizontal right
          const Offset(-60, 0), // horizontal left
          const Offset(0, 30), // vertical down
        ];

        // Some static steps to jump between moving platforms
        steps = [
          Rect.fromLTWH(
            0,
            boxHeight - 120,
            120,
            18,
          ), // raised higher, wide enough for ball
          Rect.fromLTWH(210, 320, 90, 16),
        ];

        // Goal moved closer to bottom-left
        goalRect = Rect.fromLTWH(20, boxHeight - 45, 25, 25);

        // start on first moving platform
        ballX = movingPlatforms[0].left + movingPlatforms[0].width / 2;
        ballY = movingPlatforms[0].top - ballRadius;
        break;

      case 14:
        portals = [
          Rect.fromLTWH(20, 60, 30, 30), // index 0
          Rect.fromLTWH(230, 160, 30, 30), // index 1
          Rect.fromLTWH(40, 300, 30, 30), // index 2 (left bottom)
          Rect.fromLTWH(240, 320, 30, 30), // index 3
        ];

        magnetsCenters = [Offset(150, 140), Offset(80, 260)];
        magnetRadii = [80.0, 70.0];
        magnetStrengths = [600.0, 480.0];

        steps = [
          Rect.fromLTWH(110, 200, 80, 16),
          Rect.fromLTWH(0, 350, 80, 16),
        ];

        goalRect = Rect.fromLTWH(boxWidth - 45, 350, 25, 25);

        ballX = portals[0].left + portals[0].width / 2;
        ballY = portals[0].top + portals[0].height + ballRadius + 2;

        // Custom portal mapping
        portalPairs = {
          0: 1,
          1: 0,
          2: 1, // bottom-left exits top-right
          3: 0, // optional mapping, can go to 0
        };
        break;
    }
  }

  @override
  void dispose() {
    accelSub?.cancel();
    _gameTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  /// ---------------- BUILD ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Level ${widget.level}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => LevelSelectScreen(isProMode: widget.isProMode),
              ),
              (route) => false,
            );
          },
        ),
      ),
      body: Center(
        child: Stack(
          children: [
            Container(
              width: boxWidth,
              height: boxHeight,
              color: Colors.grey[300],
            ),
            // static steps
            for (var step in steps)
              Positioned(
                left: step.left,
                top: step.top,
                child: Container(
                  width: step.width,
                  height: step.height,
                  color: Colors.brown,
                ),
              ),

            // moving platforms (level 13)
            for (var i = 0; i < movingPlatforms.length; i++)
              Positioned(
                left: movingPlatforms[i].left,
                top: movingPlatforms[i].top,
                child: Container(
                  width: movingPlatforms[i].width,
                  height: movingPlatforms[i].height,
                  color: Colors.blueGrey,
                  child: const Center(
                    child: Text('', style: TextStyle(fontSize: 10)),
                  ),
                ),
              ),

            // springs (level 12)
            for (var s in springs)
              Positioned(
                left: s.left,
                top: s.top,
                child: Container(
                  width: s.width,
                  height: s.height,
                  decoration: BoxDecoration(
                    color: Colors.pink,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),

            // conveyors (level 14)
            for (var c in conveyors)
              Positioned(
                left: c.left,
                top: c.top,
                child: Container(
                  width: c.width,
                  height: c.height,
                  color: Colors.teal,
                  child: const SizedBox.shrink(),
                ),
              ),

            // portals (level 15)
            for (var p in portals)
              Positioned(
                left: p.left,
                top: p.top,
                child: Container(
                  width: p.width,
                  height: p.height,
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                ),
              ),

            // magnets (level 15) - show translucent pull area and center
            for (int i = 0; i < magnetsCenters.length; i++)
              Positioned(
                left: magnetsCenters[i].dx - magnetRadii[i],
                top: magnetsCenters[i].dy - magnetRadii[i],
                child: SizedBox(
                  width: magnetRadii[i] * 2,
                  height: magnetRadii[i] * 2,
                  child: Opacity(
                    opacity: 0.18,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.indigo,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            for (int i = 0; i < magnetsCenters.length; i++)
              Positioned(
                left: magnetsCenters[i].dx - 8,
                top: magnetsCenters[i].dy - 8,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.indigo[900],
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                ),
              ),

            if (widget.level == 11)
              Positioned(
                left: startBar.left,
                top: startBar.top,
                child: Container(
                  width: startBar.width,
                  height: startBar.height,
                  color: Colors.blue,
                ),
              ),
            for (var bar in landingBars)
              Positioned(
                left: bar.left,
                top: bar.top,
                child: Container(
                  width: bar.width,
                  height: bar.height,
                  color: Colors.orange,
                ),
              ),
            if (widget.level == 11)
              for (int i = 0; i < fanCenters.length; i++)
                Positioned(
                  left: fanCenters[i].dx - fanRadius,
                  top: fanCenters[i].dy - fanRadius,
                  child: Transform.rotate(
                    angle: fanAngles[i],
                    child: CustomPaint(
                      size: Size(fanRadius * 2, fanRadius * 2),
                      painter: FanBladePainter(fanBlades),
                    ),
                  ),
                ),
            Positioned(
              left: goalRect.left,
              top: goalRect.top,
              child: Container(
                width: goalRect.width,
                height: goalRect.height,
                color: Colors.green,
              ),
            ),
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
            for (var spike in floorSpikes)
              Positioned(
                left: spike.left,
                top: spike.top,
                child: Container(
                  width: spike.width,
                  height: spike.height,
                  color: Colors.black,
                ),
              ),

            if (widget.isProMode)
              Positioned(
                top: 10,
                left: 10,
                child: Text(
                  'Time: $remainingTime s',
                  style: const TextStyle(fontSize: 20),
                ),
              ),

            // Overlay: Game over
            if (gameStatus == GameStatus.gameOver)
              Positioned.fill(
                child: Container(
                  color: Colors.black45,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Game Over',
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LevelSelectScreen(
                                  isProMode: widget.isProMode,
                                ),
                              ),
                            );
                          },
                          child: const Text('Back to Levels'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Overlay: Won
            if (gameStatus == GameStatus.won)
              Positioned.fill(
                child: Container(
                  color: Colors.black45,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'You Won!',
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        ),
                        const SizedBox(height: 20),
                        if (widget.level < 15)
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => GravityMazeScreen(
                                    level: widget.level + 1,
                                    isProMode: widget.isProMode,
                                  ),
                                ),
                              );
                            },
                            child: const Text('Next Level'),
                          ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LevelSelectScreen(
                                  isProMode: widget.isProMode,
                                ),
                              ),
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
