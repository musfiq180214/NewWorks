// abstract class Bird {
//   void fly();
// }

// class Sparrow implements Bird {
//   @override
//   void fly() => print('Sparrow is flying');
// }

// class Ostrich implements Bird {
//   @override
//   void fly() => throw Exception('Ostrich cannot fly');
// }

// void makeBirdFly(Bird bird) {
//   bird.fly();
// }

// void main() {
//   makeBirdFly(Sparrow()); // ✅ Works
//   makeBirdFly(Ostrich()); // ❌ Breaks program
// }
abstract class Bird {} // Base bird, no abilities assumed

abstract class FlyingBird extends Bird {
  void fly();
}

abstract class WalkingBird extends Bird {
  void walk();
}

class Sparrow extends FlyingBird {
  @override
  void fly() => print("Sparrow flying high!");
}

class Ostrich extends WalkingBird {
  @override
  void walk() => print("Ostrich walking fast!");
}

void letBirdFly(FlyingBird bird) => bird.fly();
void letBirdWalk(WalkingBird bird) => bird.walk();

void main() {
  letBirdFly(Sparrow());   // ✅ Works
  letBirdWalk(Ostrich());  // ✅ Works
}
