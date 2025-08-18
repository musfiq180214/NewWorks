
// wrong approach
class runner{

  void fastRun() {
    print('Running fast!!!!!');
  }
  void slowRun() {
    print('Running slowly!!!!!!');
  }
  void normalRun() {
    print('Running at normal speed!!!!!');    
  }

}

// correct approach
class runFast {
  void run() {
    print('Running fast!');
  }
}

class runSlow {
  void run() {
    print('Running slow!');
  }
}

class runNormal {
  void run() {
    print('Running at normal speed!');
  }
}

void main(List<String> args) {

  runner r = runner();
  r.fastRun();
  r.slowRun();
  r.normalRun();


  print("---------------------------");


  runFast fastRunner = runFast();
  fastRunner.run();

  runSlow slowRunner = runSlow();
  slowRunner.run();

  runNormal normalRunner = runNormal();
  normalRunner.run();

}