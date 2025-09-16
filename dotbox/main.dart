import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const DotBoxApp());
}

class DotBoxApp extends StatelessWidget {
  const DotBoxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PlayerSetupScreen(),
    );
  }
}

/// Step 1: Player Setup Screen
class PlayerSetupScreen extends StatefulWidget {
  const PlayerSetupScreen({super.key});

  @override
  State<PlayerSetupScreen> createState() => _PlayerSetupScreenState();
}

class _PlayerSetupScreenState extends State<PlayerSetupScreen> {
  int numPlayers = 2;
  int gridSize = 5;
  List<TextEditingController> playerControllers = [];
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _generateControllers();
  }

  void _generateControllers() {
    playerControllers = List.generate(
      numPlayers,
      (index) => TextEditingController(),
    );
  }

  void _updatePlayerCount(int count) {
    setState(() {
      numPlayers = count;
      _generateControllers();
    });
  }

  void _startGame() {
    List<String> names = playerControllers
        .map((c) => c.text.trim())
        .where((t) => t.isNotEmpty)
        .toList();

    if (names.length != numPlayers) {
      setState(() => errorMessage = "All player names are required");
      return;
    }

    List<String> initials = names.map((n) => n[0].toUpperCase()).toList();
    if (initials.toSet().length != initials.length) {
      setState(() => errorMessage = "Players must have unique initials");
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DotBoxGameScreen(players: names, gridSize: gridSize),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int maxPlayers = gridSize * gridSize - 1;

    return Scaffold(
      appBar: AppBar(title: const Text("Dots & Boxes Setup")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Row(
              children: [
                const Text("Grid Size: "),
                Expanded(
                  child: Slider(
                    value: gridSize.toDouble(),
                    min: 2,
                    max: 10,
                    divisions: 8,
                    label: "$gridSize × $gridSize",
                    onChanged: (val) {
                      setState(() {
                        gridSize = val.toInt();
                      });
                    },
                  ),
                ),
              ],
            ),
            Text("Selected: $gridSize × $gridSize"),
            const SizedBox(height: 20),

            Text("Number of Players (2 - $maxPlayers):"),
            Slider(
              value: numPlayers.toDouble(),
              min: 2,
              max: maxPlayers.toDouble(),
              divisions: maxPlayers - 1,
              label: "$numPlayers",
              onChanged: (val) => _updatePlayerCount(val.toInt()),
            ),
            const SizedBox(height: 20),
            Text("Enter Player Names:"),
            Column(
              children: List.generate(numPlayers, (i) {
                return TextField(
                  controller: playerControllers[i],
                  decoration: InputDecoration(
                    labelText: "Player ${i + 1} Name",
                  ),
                );
              }),
            ),

            const SizedBox(height: 20),
            if (errorMessage != null)
              Text(errorMessage!, style: const TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: _startGame,
              child: const Text("Start Game"),
            ),
          ],
        ),
      ),
    );
  }
}

/// Step 2: Game Screen
class DotBoxGameScreen extends StatefulWidget {
  final List<String> players;
  final int gridSize;

  const DotBoxGameScreen({
    super.key,
    required this.players,
    required this.gridSize,
  });

  @override
  State<DotBoxGameScreen> createState() => _DotBoxGameScreenState();
}

class _DotBoxGameScreenState extends State<DotBoxGameScreen> {
  final double dotRadius = 8;
  final double tolerance = 20;

  List<Offset> dots = [];
  Set<Line> activeLines = {};
  late List<String?> boxOwners;
  int currentPlayer = 0;

  @override
  void initState() {
    super.initState();
    boxOwners = List<String?>.filled(
      (widget.gridSize - 1) * (widget.gridSize - 1),
      null,
    );
  }

  void generateDots(Size size) {
    dots.clear();
    double spacing = size.width / (widget.gridSize + 1);

    for (int row = 1; row <= widget.gridSize; row++) {
      for (int col = 1; col <= widget.gridSize; col++) {
        dots.add(Offset(col * spacing, row * spacing));
      }
    }
  }

  void handleTap(Offset touchPoint) {
    Line? closestLine;
    double minDistance = double.infinity;

    for (var line in _getAllLines()) {
      double dist = _distanceToLine(touchPoint, line.start, line.end);
      if (dist < minDistance && dist <= tolerance) {
        minDistance = dist;
        closestLine = line;
      }
    }

    if (closestLine != null && !activeLines.contains(closestLine)) {
      setState(() {
        activeLines.add(closestLine!);

        bool boxCompleted = _checkAndAssignBoxes();

        if (!boxCompleted) {
          currentPlayer = (currentPlayer + 1) % widget.players.length;
        }

        _checkGameEnd();
      });
    }
  }

  List<Line> _getAllLines() {
    List<Line> lines = [];
    for (int row = 0; row < widget.gridSize; row++) {
      for (int col = 0; col < widget.gridSize; col++) {
        int index = row * widget.gridSize + col;
        if (col < widget.gridSize - 1) {
          lines.add(Line(dots[index], dots[index + 1]));
        }
        if (row < widget.gridSize - 1) {
          lines.add(Line(dots[index], dots[index + widget.gridSize]));
        }
      }
    }
    return lines;
  }

  bool _checkAndAssignBoxes() {
    bool scored = false;
    for (int row = 0; row < widget.gridSize - 1; row++) {
      for (int col = 0; col < widget.gridSize - 1; col++) {
        int boxIndex = row * (widget.gridSize - 1) + col;
        if (boxOwners[boxIndex] != null) continue;

        Offset topLeft = dots[row * widget.gridSize + col];
        Offset topRight = dots[row * widget.gridSize + col + 1];
        Offset bottomLeft = dots[(row + 1) * widget.gridSize + col];
        Offset bottomRight = dots[(row + 1) * widget.gridSize + col + 1];

        Line top = Line(topLeft, topRight);
        Line bottom = Line(bottomLeft, bottomRight);
        Line left = Line(topLeft, bottomLeft);
        Line right = Line(topRight, bottomRight);

        if (activeLines.contains(top) &&
            activeLines.contains(bottom) &&
            activeLines.contains(left) &&
            activeLines.contains(right)) {
          boxOwners[boxIndex] = widget.players[currentPlayer][0].toUpperCase();
          scored = true;
        }
      }
    }
    return scored;
  }

  void _checkGameEnd() {
    if (boxOwners.every((owner) => owner != null)) {
      Map<String, int> scores = {};
      for (var player in widget.players) {
        scores[player] = boxOwners
            .where((o) => o == player[0].toUpperCase())
            .length;
      }

      // Sort players by score (descending)
      var sorted = scores.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      // Assign ranks with ties
      List<String> ranking = [];
      int currentRank = 1;
      for (int i = 0; i < sorted.length; i++) {
        if (i > 0 && sorted[i].value < sorted[i - 1].value) {
          currentRank = i + 1;
        }
        ranking.add(
          "${currentRank == 1
              ? "🥇"
              : currentRank == 2
              ? "🥈"
              : currentRank == 3
              ? "🥉"
              : "$currentRankᵗʰ"} "
          "${sorted[i].key} - ${sorted[i].value} boxes",
        );
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text("Game Over 🎉"),
          content: Text(ranking.join("\n")),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("Exit"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  activeLines.clear();
                  boxOwners = List<String?>.filled(boxOwners.length, null);
                  currentPlayer = 0;
                });
              },
              child: const Text("Play Again"),
            ),
          ],
        ),
      );
    }
  }

  double _distanceToLine(Offset p, Offset a, Offset b) {
    final double dx = b.dx - a.dx;
    final double dy = b.dy - a.dy;
    if (dx == 0 && dy == 0) return (p - a).distance;

    double t = ((p.dx - a.dx) * dx + (p.dy - a.dy) * dy) / (dx * dx + dy * dy);
    t = max(0, min(1, t));
    Offset projection = Offset(a.dx + t * dx, a.dy + t * dy);
    return (p - projection).distance;
  }

  @override
  Widget build(BuildContext context) {
    String turnName = widget.players[currentPlayer];

    return Scaffold(
      appBar: AppBar(title: Text("Turn: $turnName")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          generateDots(constraints.biggest);
          return GestureDetector(
            onTapDown: (details) {
              handleTap(details.localPosition);
            },
            child: CustomPaint(
              painter: DotBoxPainter(
                dots: dots,
                gridSize: widget.gridSize,
                activeLines: activeLines,
                dotRadius: dotRadius,
                boxOwners: boxOwners,
              ),
              size: Size.infinite,
            ),
          );
        },
      ),
    );
  }
}

/// Painter
class DotBoxPainter extends CustomPainter {
  final List<Offset> dots;
  final int gridSize;
  final Set<Line> activeLines;
  final double dotRadius;
  final List<String?> boxOwners;

  DotBoxPainter({
    required this.dots,
    required this.gridSize,
    required this.activeLines,
    required this.dotRadius,
    required this.boxOwners,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint dotPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final Paint linePaint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 2;

    final Paint activeLinePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3;

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    // Draw all lines
    for (var line in _getAllLines()) {
      if (activeLines.contains(line)) {
        canvas.drawLine(line.start, line.end, activeLinePaint);
      } else {
        canvas.drawLine(line.start, line.end, linePaint);
      }
    }

    // Draw box owners
    for (int row = 0; row < gridSize - 1; row++) {
      for (int col = 0; col < gridSize - 1; col++) {
        int boxIndex = row * (gridSize - 1) + col;
        if (boxOwners[boxIndex] != null) {
          Offset topLeft = dots[row * gridSize + col];
          Offset bottomRight = dots[(row + 1) * gridSize + col + 1];
          Offset center = Offset(
            (topLeft.dx + bottomRight.dx) / 2,
            (topLeft.dy + bottomRight.dy) / 2,
          );

          textPainter.text = TextSpan(
            text: boxOwners[boxIndex],
            style: const TextStyle(
              color: Colors.red,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          );
          textPainter.layout();
          textPainter.paint(
            canvas,
            center - Offset(textPainter.width / 2, textPainter.height / 2),
          );
        }
      }
    }

    // Draw dots
    for (var dot in dots) {
      canvas.drawCircle(dot, dotRadius, dotPaint);
    }
  }

  List<Line> _getAllLines() {
    List<Line> lines = [];
    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        int index = row * gridSize + col;
        if (col < gridSize - 1) {
          lines.add(Line(dots[index], dots[index + 1]));
        }
        if (row < gridSize - 1) {
          lines.add(Line(dots[index], dots[index + gridSize]));
        }
      }
    }
    return lines;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Line object
class Line {
  final Offset start;
  final Offset end;

  Line(this.start, this.end);

  @override
  bool operator ==(Object other) {
    return other is Line &&
        ((start == other.start && end == other.end) ||
            (start == other.end && end == other.start));
  }

  @override
  int get hashCode => start.hashCode ^ end.hashCode;
}
