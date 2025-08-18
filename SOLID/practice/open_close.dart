// class Runner {
//   void run(String type) {
//     if (type == 'fast') {
//       print('Running fast!');
//     } else if (type == 'slow') {
//       print('Running slow!');
//     } else if (type == 'normal') {
//       print('Running normal!');
//     }
//   }
// }


abstract class Runner {
  void run();
}

class FastRunner implements Runner {
  @override
  void run() => print('Running fast!');
}

class SlowRunner implements Runner {
  @override
  void run() => print('Running slow!');
}

class NormalRunner implements Runner {
  @override
  void run() => print('Running normal!');
}

class MazeRunner implements Runner {
  @override
  void run() => print('Running in a maze!');
}

void main() {
  FastRunner fastRunner = FastRunner();
  fastRunner.run();
  SlowRunner slowRunner = SlowRunner();
  slowRunner.run();   
  NormalRunner normalRunner = NormalRunner();
  normalRunner.run();
  MazeRunner mazeRunner = MazeRunner();
  mazeRunner.run();
}

