import 'package:flutter/material.dart';

void main() {
  runApp(const TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tic Tac Toe',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TicTacToeScreen(),
    );
  }
}

class TicTacToeScreen extends StatefulWidget {
  const TicTacToeScreen({super.key});

  @override
  State<TicTacToeScreen> createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  static const int boardSize = 9;
  List<String> _board = List.filled(boardSize, '');
  String _currentPlayer = 'X';
  List<int>? _winningLine;
  String _resultMessage = '';

  void _resetBoard() {
    setState(() {
      _board = List.filled(boardSize, '');
      _currentPlayer = 'X';
      _winningLine = null;
      _resultMessage = '';
    });
  }

  void _makeMove(int index) {
    if (_board[index] == '' && _resultMessage.isEmpty) {
      setState(() {
        _board[index] = _currentPlayer;
        _winningLine = _checkWinner(_currentPlayer);
        if (_winningLine != null) {
          _resultMessage = 'Player $_currentPlayer Wins!';
        } else if (!_board.contains('')) {
          _resultMessage = 'It\'s a Draw!';
        } else {
          _currentPlayer = _currentPlayer == 'X' ? 'O' : 'X';
        }
      });
    }
  }

  List<int>? _checkWinner(String player) {
    const winningPositions = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var pos in winningPositions) {
      if (_board[pos[0]] == player &&
          _board[pos[1]] == player &&
          _board[pos[2]] == player) {
        return pos;
      }
    }
    return null;
  }

  Widget _buildBoard() {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: boardSize,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemBuilder: (context, index) {
              bool isWinningCell =
                  _winningLine != null && _winningLine!.contains(index);
              return GestureDetector(
                onTap: () => _makeMove(index),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    color: isWinningCell ? Colors.red.shade100 : Colors.white,
                  ),
                  child: Center(
                    child: Text(
                      _board[index],
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: isWinningCell ? Colors.red : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          if (_winningLine != null) _buildWinningLine(),
        ],
      ),
    );
  }

  Widget _buildWinningLine() {
    double cellSize = MediaQuery.of(context).size.width / 3 - 16;
    int a = _winningLine![0];
    int b = _winningLine![2];

    double startX = (a % 3) * cellSize + cellSize / 2 + 8;
    double startY = (a ~/ 3) * cellSize + cellSize / 2 + 8;
    double endX = (b % 3) * cellSize + cellSize / 2 + 8;
    double endY = (b ~/ 3) * cellSize + cellSize / 2 + 8;

    return Positioned(
      left: 0,
      top: 0,
      child: CustomPaint(
        size: Size(cellSize * 3, cellSize * 3),
        painter: LinePainter(
          start: Offset(startX, startY),
          end: Offset(endX, endY),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tic Tac Toe'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildBoard(),
            const SizedBox(height: 20),
            Text(
              _resultMessage.isEmpty
                  ? 'Current Player: $_currentPlayer'
                  : _resultMessage,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetBoard,
              child: const Text('Reset Game'),
            ),
          ],
        ),
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  final Offset start;
  final Offset end;

  LinePainter({required this.start, required this.end});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
