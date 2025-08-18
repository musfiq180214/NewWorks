abstract class Shape {
  double area();
}

class Rectangle implements Shape {
  double width, height;
  Rectangle(this.width, this.height);

  @override
  double area() => width * height;
}

class Circle implements Shape {
  double radius;
  Circle(this.radius);

  @override
  double area() => 3.14 * radius * radius;
}

class Triangle implements Shape {
  double base, height;
  Triangle(this.base, this.height);

  @override
  double area() => 0.5 * base * height;
}

class AreaCalculator {
  double totalArea(List<Shape> shapes) {
    double total = 0;
    for (var shape in shapes) {
      total += shape.area();
    }
    return total;
  }
}

void main() {
  List<Shape> shapes = [
    Rectangle(5, 10),
    Circle(7),
    Triangle(4, 8),
  ];

  var calculator = AreaCalculator();
  print('Total area: ${calculator.totalArea(shapes)}');
}
