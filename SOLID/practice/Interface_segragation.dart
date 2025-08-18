// abstract class Machine {
//   void printDocument();
//   void scanDocument();
//   void faxDocument();
// }

// class OldPrinter implements Machine {
//   @override
//   void printDocument() => print("Printing...");
  
//   @override
//   void scanDocument() {
//     throw Exception("I cannot scan!"); // ❌ Problem
//   }

//   @override
//   void faxDocument() {
//     throw Exception("I cannot fax!"); // ❌ Problem
//   }
// }

abstract class Printer {
  void printDocument();
}

abstract class Scanner {
  void scanDocument();
}

abstract class Fax {
  void faxDocument();
}

class OldPrinter implements Printer {
  @override
  void printDocument() => print("Printing...");
}

class MultiFunctionPrinter implements Printer, Scanner, Fax {
  @override
  void printDocument() => print("Printing...");

  @override
  void scanDocument() => print("Scanning...");

  @override
  void faxDocument() => print("Faxing...");
}
