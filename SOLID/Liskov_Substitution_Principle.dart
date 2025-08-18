abstract class Bird {}           // All birds

abstract class FlyingBird extends Bird {
  void fly();                   // Only flying birds
}

class Sparrow extends FlyingBird {
  @override
  void fly() => print('Sparrow flying');
}

class Ostrich extends Bird {}    // No fly method needed

void main() {
  Sparrow().fly(); // Flying
  
}