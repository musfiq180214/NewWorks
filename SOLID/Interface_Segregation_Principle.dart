abstract class Printer {
  void printDocument();
}

abstract class Scanner {
  void scanDocument();
}

abstract class Fax {
  void faxDocument();
}

class SimplePrinter implements Printer {
  @override
  void printDocument() => print("Printing document");
}

class MultiFunctionPrinter implements Printer, Scanner, Fax {
  @override
  void printDocument() => print("Printing document");

  @override
  void scanDocument() => print("Scanning document");

  @override
  void faxDocument() => print("Faxing document");
}
