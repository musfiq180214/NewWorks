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

//     _startLevelTimer();
//   }

//   /// ---------------- LEVEL TIMER ----------------
//   void _startLevelTimer() {
//     remainingTime = levelTime;
//     _countdownTimer?.cancel();
//     _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
//       if (won || gameOver) {
//         _countdownTimer?.cancel();
//         return;
//       }
//       setState(() {
//         remainingTime--;
//       });
//       if (remainingTime <= 0) {
//         setState(() {
//           gameOver = true;
//         });
//         _countdownTimer?.cancel();
//       }
//     });
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

//     // Spike collision
//     for (Rect spike in floorSpikes) {
//       if (ballRect.overlaps(spike)) {
//         gameOver = true;
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
//     floorSpikes = [];
//     won = false;
//     gameOver = false;
//     velocityX = 0;
//     velocityY = 0;

//     // Level-specific timer durations (in seconds)
//     // You can adjust each level time here
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

//     // Add floor spikes at regular intervals
//     for (double x = 0; x < boxWidth; x += spikeWidth) {
//       floorSpikes.add(
//         Rect.fromLTWH(x, boxHeight - spikeHeight, spikeWidth, spikeHeight),
//       );
//     }

//     switch (level) {
//       // Levels 1-10
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

//   void _restartLevel() {
//     setState(() {
//       _generateLevel(widget.level);
//       _startLevelTimer();
//     });
//   }

//   @override
//   void dispose() {
//     accelSub?.cancel();
//     _gameTimer?.cancel();
//     _countdownTimer?.cancel();
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
//                   // Spikes
//                   for (Rect spike in floorSpikes)
//                     Positioned(
//                       left: spike.left,
//                       top: spike.top,
//                       child: CustomPaint(
//                         size: Size(spike.width, spike.height),
//                         painter: SpikePainter(),
//                       ),
//                     ),
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
//                   // Timer display
//                   Positioned(
//                     top: 5,
//                     right: 10,
//                     child: Text(
//                       'Time: $remainingTime s',
//                       style: const TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.red,
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

// class SpikePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.orange
//       ..style = PaintingStyle.fill;

//     Path path = Path();
//     path.moveTo(0, size.height);
//     path.lineTo(size.width / 2, 0);
//     path.lineTo(size.width, size.height);
//     path.close();
//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant SpikePainter oldDelegate) => false;
// }

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

// /// ---------------- GAME SCREEN ----------------
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
//       if (won || gameOver) {
//         _countdownTimer?.cancel();
//         return;
//       }
//       setState(() {
//         remainingTime--;
//       });
//       if (remainingTime <= 0) {
//         setState(() {
//           gameOver = true;
//         });
//         _countdownTimer?.cancel();
//       }
//     });
//   }

//   /// ---------------- PHYSICS TICK ----------------
//   void _tick() {
//     if (won || gameOver) return;
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
//               gameOver = true;
//               break;
//             }
//           }
//         }
//       }
//     }

//     for (Rect spike in floorSpikes) {
//       if (ballRect.overlaps(spike)) {
//         gameOver = true;
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
//     floorSpikes = [];
//     won = false;
//     gameOver = false;
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
//       // Other levels can be added similarly
//     }
//   }

//   void _restartLevel() {
//     setState(() {
//       _generateLevel(widget.level);
//       if (widget.isProMode) _startLevelTimer();
//     });
//   }

//   @override
//   void dispose() {
//     accelSub?.cancel();
//     _gameTimer?.cancel();
//     _countdownTimer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Text(
//           'Gravity Maze — Level ${widget.level} (${widget.isProMode ? "Pro" : "Rookie"})',
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             tooltip: 'Mode Select',
//             onPressed: () {
//               Navigator.pushAndRemoveUntil(
//                 context,
//                 MaterialPageRoute(builder: (_) => const ModeSelectScreen()),
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
//                   for (Rect spike in floorSpikes)
//                     Positioned(
//                       left: spike.left,
//                       top: spike.top,
//                       child: CustomPaint(
//                         size: Size(spike.width, spike.height),
//                         painter: SpikePainter(),
//                       ),
//                     ),
//                   Positioned(
//                     left: goalRect.left,
//                     top: goalRect.top,
//                     child: Container(
//                       width: goalRect.width,
//                       height: goalRect.height,
//                       color: Colors.green,
//                     ),
//                   ),
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
//                   if (widget.isProMode)
//                     Positioned(
//                       top: 5,
//                       right: 10,
//                       child: Text(
//                         'Time: $remainingTime s',
//                         style: const TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.red,
//                         ),
//                       ),
//                     ),
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
//                                     isProMode: widget.isProMode,
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
//                                   builder: (_) => const ModeSelectScreen(),
//                                 ),
//                                 (route) => false,
//                               );
//                             },
//                             child: const Text('Back to Modes'),
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

// class SpikePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.orange
//       ..style = PaintingStyle.fill;
//     Path path = Path();
//     path.moveTo(0, size.height);
//     path.lineTo(size.width / 2, 0);
//     path.lineTo(size.width, size.height);
//     path.close();
//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant SpikePainter oldDelegate) => false;
// }

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
//             // Steps (for levels 1-10)
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
//             // Start Bar (Level 11)
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
//             // Landing Bars (Level 11)
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
//             // Fans (Level 11)
//             if (widget.level == 11)
//               for (int i = 0; i < fanCenters.length; i++)
//                 Positioned(
//                   left: fanCenters[i].dx - fanRadius,
//                   top: fanCenters[i].dy - fanRadius,
//                   child: Transform.rotate(
//                     angle: fanAngles[i],
//                     child: Container(
//                       width: fanRadius * 2,
//                       height: fanRadius * 2,
//                       decoration: BoxDecoration(
//                         color: Colors.purple,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Center(
//                         child: Stack(
//                           children: List.generate(fanBlades, (b) {
//                             double bladeAngle = b * 2 * pi / fanBlades;
//                             return Transform.rotate(
//                               angle: bladeAngle,
//                               child: Align(
//                                 alignment: Alignment.topCenter,
//                                 child: Container(
//                                   width: 4,
//                                   height: fanRadius,
//                                   color: Colors.yellow,
//                                 ),
//                               ),
//                             );
//                           }),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//             // Goal
//             Positioned(
//               left: goalRect.left,
//               top: goalRect.top,
//               child: Container(
//                 width: goalRect.width,
//                 height: goalRect.height,
//                 color: Colors.green,
//               ),
//             ),
//             // Ball
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
//             // Spikes (floor)
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
//             // Game over / Won
//             if (gameStatus == GameStatus.gameOver)
//               Positioned.fill(
//                 child: Container(
//                   color: Colors.black45,
//                   child: const Center(
//                     child: Text(
//                       'Game Over',
//                       style: TextStyle(color: Colors.white, fontSize: 30),
//                     ),
//                   ),
//                 ),
//               ),
//             if (gameStatus == GameStatus.won)
//               Positioned.fill(
//                 child: Container(
//                   color: Colors.black45,
//                   child: const Center(
//                     child: Text(
//                       'You Won!',
//                       style: TextStyle(color: Colors.white, fontSize: 30),
//                     ),
//                   ),
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
  final int totalLevels = 11;

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

    if (widget.level == 11) {
      for (int i = 0; i < fanAngles.length; i++) {
        fanAngles[i] += fanSpeeds[i] * dt;
        fanAngles[i] %= 2 * pi;
      }
    }

    velocityY += gravityAccel * dt;

    double nextX = ballX + velocityX * dt;
    double nextY = ballY + velocityY * dt;
    Rect ballRect = Rect.fromCircle(
      center: Offset(nextX, nextY),
      radius: ballRadius,
    );

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

    ballX = nextX;
    ballY = nextY;
    velocityX *= friction;
    velocityY *= friction;

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
    gameStatus = GameStatus.playing;
    velocityX = 0;
    velocityY = 0;

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
    };
    levelTime = levelTimes[level] ?? 20;

    for (double x = 0; x < boxWidth; x += spikeWidth) {
      floorSpikes.add(
        Rect.fromLTWH(x, boxHeight - spikeHeight, spikeWidth, spikeHeight),
      );
    }

    switch (level) {
      case 1:
        for (int i = 1; i <= 5; i++)
          steps.add(Rect.fromLTWH(0, i * 60, 50.0 * i, 20));
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
                        if (widget.level < 11)
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
