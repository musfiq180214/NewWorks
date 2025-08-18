class Invoice {
  double amount;
  Invoice(this.amount);
}

class InvoicePrinter {
  void printInvoice(Invoice invoice) 
  {
    print('Invoice: \$${invoice.amount}');
  }
}

class InvoiceRepository {
  void save(Invoice invoice)
  {
    print('Saving invoice to database');
  }
}

void main() {
  final invoice = Invoice(100.0);
  final printer = InvoicePrinter();
  final repository = InvoiceRepository();

  printer.printInvoice(invoice);
  repository.save(invoice);
}
