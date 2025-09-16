import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const TetrisApp());
}

class TetrisApp extends StatelessWidget {
  const TetrisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tetris',
      home: const TetrisGame(),
    );
  }
}

const int rowCount = 20;
const int colCount = 10;
const double blockSize = 20.0;

class TetrisGame extends StatefulWidget {
  const TetrisGame({super.key});

  @override
  _TetrisGameState createState() => _TetrisGameState();
}

class _TetrisGameState extends State<TetrisGame> {
  List<List<Color>> grid = List.generate(
    rowCount,
    (_) => List.generate(colCount, (_) => Colors.black),
  );

  Timer? timer;
  Tetromino? currentPiece;
  int score = 0;

  Offset? initialSwipeOffset;
  DateTime? swipeStartTime;

  @override
  void initState() {
    super.initState();
    spawnPiece();
    startGame();
  }

  void startGame() {
    timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      setState(() {
        moveDown();
      });
    });
  }

  void spawnPiece() {
    currentPiece = Tetromino.getRandom();
    currentPiece!.position = Point(colCount ~/ 2 - 1, 0);
  }

  void moveDown() {
    if (canMove(0, 1, currentPiece!)) {
      currentPiece!.position = Point(
        currentPiece!.position.x,
        currentPiece!.position.y + 1,
      );
    } else {
      mergePiece();
      clearLines();
      spawnPiece();
      if (!canMove(0, 0, currentPiece!)) {
        timer?.cancel();
        showGameOverDialog();
      }
    }
  }

  void moveLeft() {
    if (canMove(-1, 0, currentPiece!)) {
      setState(() {
        currentPiece!.position = Point(
          currentPiece!.position.x - 1,
          currentPiece!.position.y,
        );
      });
    }
  }

  void moveRight() {
    if (canMove(1, 0, currentPiece!)) {
      setState(() {
        currentPiece!.position = Point(
          currentPiece!.position.x + 1,
          currentPiece!.position.y,
        );
      });
    }
  }

  void rotate() {
    currentPiece!.rotate();
    if (!canMove(0, 0, currentPiece!)) {
      currentPiece!.rotate(reverse: true);
    } else {
      setState(() {});
    }
  }

  bool canMove(int dx, int dy, Tetromino piece) {
    for (var p in piece.getBlocks()) {
      int x = p.x + dx + piece.position.x;
      int y = p.y + dy + piece.position.y;
      if (x < 0 || x >= colCount || y < 0 || y >= rowCount) return false;
      if (grid[y][x] != Colors.black) return false;
    }
    return true;
  }

  void mergePiece() {
    for (var p in currentPiece!.getBlocks()) {
      int x = p.x + currentPiece!.position.x;
      int y = p.y + currentPiece!.position.y;
      grid[y][x] = currentPiece!.color;
    }
  }

  void clearLines() {
    for (int y = rowCount - 1; y >= 0; y--) {
      if (!grid[y].contains(Colors.black)) {
        grid.removeAt(y);
        grid.insert(0, List.generate(colCount, (_) => Colors.black));
        score += 100;
        y++;
      }
    }
  }

  void drop() {
    while (canMove(0, 1, currentPiece!)) {
      currentPiece!.position = Point(
        currentPiece!.position.x,
        currentPiece!.position.y + 1,
      );
    }
    setState(() {
      moveDown();
    });
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Game Over"),
        content: Text("Score: $score"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                grid = List.generate(
                  rowCount,
                  (_) => List.generate(colCount, (_) => Colors.black),
                );
                score = 0;
                spawnPiece();
                startGame();
              });
            },
            child: const Text("Restart"),
          ),
        ],
      ),
    );
  }

  void handleSwipe(DragEndDetails details, Offset velocity) {
    final dx = velocity.dx;
    final dy = velocity.dy;

    if (dx.abs() > dy.abs()) {
      if (dx > 0) {
        moveRight();
      } else {
        moveLeft();
      }
    } else {
      if (dy > 1000) {
        // Fast downward swipe → drop instantly
        drop();
      } else if (dy > 0) {
        moveDown();
      } else {
        rotate();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const SizedBox(height: 40),
          Text(
            "Score: $score",
            style: const TextStyle(color: Colors.white, fontSize: 24),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: GestureDetector(
                onPanEnd: (details) {
                  handleSwipe(details, details.velocity.pixelsPerSecond);
                },
                child: Container(
                  width: colCount * blockSize,
                  height: rowCount * blockSize,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                  ),
                  child: Stack(
                    children: [
                      // Grid
                      for (int y = 0; y < rowCount; y++)
                        for (int x = 0; x < colCount; x++)
                          Positioned(
                            left: x * blockSize,
                            top: y * blockSize,
                            child: Container(
                              width: blockSize,
                              height: blockSize,
                              decoration: BoxDecoration(
                                color: grid[y][x],
                                border: Border.all(color: Colors.grey[900]!),
                              ),
                            ),
                          ),
                      // Current Piece
                      if (currentPiece != null)
                        for (var p in currentPiece!.getBlocks())
                          Positioned(
                            left: (p.x + currentPiece!.position.x) * blockSize,
                            top: (p.y + currentPiece!.position.y) * blockSize,
                            child: Container(
                              width: blockSize,
                              height: blockSize,
                              decoration: BoxDecoration(
                                color: currentPiece!.color,
                                border: Border.all(color: Colors.white),
                              ),
                            ),
                          ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Tetromino {
  Point<int> position = const Point(0, 0);
  late List<List<Point<int>>> rotations;
  int rotationIndex = 0;
  Color color;

  Tetromino(this.rotations, this.color);

  List<Point<int>> getBlocks() => rotations[rotationIndex];

  void rotate({bool reverse = false}) {
    if (reverse) {
      rotationIndex = (rotationIndex - 1) % rotations.length;
      if (rotationIndex < 0) rotationIndex += rotations.length;
    } else {
      rotationIndex = (rotationIndex + 1) % rotations.length;
    }
  }

  static Tetromino getRandom() {
    final random = Random();
    int type = random.nextInt(7);
    switch (type) {
      case 0:
        return Tetromino([
          [Point(0, 1), Point(1, 1), Point(2, 1), Point(3, 1)],
          [Point(2, 0), Point(2, 1), Point(2, 2), Point(2, 3)],
        ], Colors.cyan);
      case 1:
        return Tetromino([
          [Point(1, 0), Point(2, 0), Point(1, 1), Point(2, 1)],
        ], Colors.yellow);
      case 2:
        return Tetromino([
          [Point(1, 0), Point(0, 1), Point(1, 1), Point(2, 1)],
          [Point(1, 0), Point(1, 1), Point(2, 1), Point(1, 2)],
          [Point(0, 1), Point(1, 1), Point(2, 1), Point(1, 2)],
          [Point(1, 0), Point(0, 1), Point(1, 1), Point(1, 2)],
        ], Colors.purple);
      case 3:
        return Tetromino([
          [Point(0, 0), Point(0, 1), Point(0, 2), Point(1, 2)],
          [Point(0, 1), Point(1, 1), Point(2, 1), Point(0, 2)],
          [Point(0, 0), Point(1, 0), Point(1, 1), Point(1, 2)],
          [Point(2, 0), Point(0, 1), Point(1, 1), Point(2, 1)],
        ], Colors.orange);
      case 4:
        return Tetromino([
          [Point(1, 0), Point(1, 1), Point(1, 2), Point(0, 2)],
          [Point(0, 0), Point(0, 1), Point(1, 1), Point(2, 1)],
          [Point(1, 0), Point(2, 0), Point(1, 1), Point(1, 2)],
          [Point(0, 1), Point(1, 1), Point(2, 1), Point(2, 2)],
        ], Colors.blue);
      case 5:
        return Tetromino([
          [Point(1, 0), Point(2, 0), Point(0, 1), Point(1, 1)],
          [Point(1, 0), Point(1, 1), Point(2, 1), Point(2, 2)],
        ], Colors.green);
      case 6:
        return Tetromino([
          [Point(0, 0), Point(1, 0), Point(1, 1), Point(2, 1)],
          [Point(2, 0), Point(1, 1), Point(2, 1), Point(1, 2)],
        ], Colors.red);
      default:
        return Tetromino([
          [Point(0, 0), Point(1, 0), Point(0, 1), Point(1, 1)],
        ], Colors.white);
    }
  }
}
