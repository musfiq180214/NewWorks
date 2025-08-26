import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tempproject/core/provider/user_profile_provider.dart';
import 'package:tempproject/features/cart/provider/cart_provider.dart';
import 'payment_detail_screen.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameController = TextEditingController();

  int? _selectedMonth;
  int? _selectedYear;
  bool _submitted = false;

  @override
  void dispose() {
    _cardController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  bool get isExpiryValid {
    if (_selectedMonth == null || _selectedYear == null) return false;
    final now = DateTime.now();
    final lastDayOfMonth = DateTime(_selectedYear!, _selectedMonth! + 1, 0);
    return lastDayOfMonth.isAfter(now);
  }

  String? cvvValidator(String? v) {
    if (v == null || v.isEmpty) return "Required";
    if (!RegExp(r'^\d{3,4}$').hasMatch(v)) return "Invalid CVV";
    return null;
  }

  String? nameValidator(String? v) => v == null || v.isEmpty ? "Required" : null;

  // Updated Card Validator: Must be exactly 16 digits
  String? cardValidator(String? v) {
    if (v == null || v.isEmpty) return "Required";
    if (!RegExp(r'^\d{16}$').hasMatch(v)) return "Card number must be 16 digits";
    return null;
  }

  void _submit() {
    setState(() => _submitted = true);
    if (_formKey.currentState!.validate() && isExpiryValid) {
      final user = ref.read(userProfileProvider)!;
      final cart = ref.read(cartProvider(user.email));
      double total = cart.fold(0, (sum, apt) => sum + apt.price);

      String card = _cardController.text;
      String maskedCard = "**** **** **** ${card.substring(card.length - 4)}";

      ref.read(cartProvider(user.email).notifier).clear();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentDetailScreen(
            totalAmount: total,
            cardHolder: _nameController.text,
            maskedCard: maskedCard,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProfileProvider);
    final cart = ref.watch(cartProvider(user!.email));
    double total = cart.fold(0, (sum, apt) => sum + apt.price);

    final months = List.generate(12, (i) => i + 1);
    final now = DateTime.now();
    final years = List.generate(10, (i) => now.year + i);

    return Scaffold(
      appBar: AppBar(title: const Text("Payment"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 6,
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              autovalidateMode: _submitted
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Total: \$${total.toStringAsFixed(2)}",
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),

                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                        labelText: "Cardholder Name",
                        border: OutlineInputBorder()),
                    validator: nameValidator,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _cardController,
                    decoration: const InputDecoration(
                        labelText: "Card Number", border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    validator: cardValidator,
                  ),
                  const SizedBox(height: 16),

                  // Expiry MM / YY inline with label
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Expiry (MM / YY)",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              value: _selectedMonth,
                              items: months
                                  .map((m) => DropdownMenuItem(
                                        value: m,
                                        child: Text(m.toString().padLeft(2, '0')),
                                      ))
                                  .toList(),
                              onChanged: (v) => setState(() => _selectedMonth = v),
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(), hintText: "MM"),
                              validator: (_) =>
                                  isExpiryValid ? null : "Invalid expiry",
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              value: _selectedYear,
                              items: years
                                  .map((y) => DropdownMenuItem(
                                        value: y,
                                        child: Text(y.toString()),
                                      ))
                                  .toList(),
                              onChanged: (v) => setState(() => _selectedYear = v),
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(), hintText: "YY"),
                              validator: (_) =>
                                  isExpiryValid ? null : "Invalid expiry",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _cvvController,
                    decoration: const InputDecoration(
                        labelText: "CVV (3 or 4 digits)",
                        border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    validator: cvvValidator,
                  ),
                  const SizedBox(height: 24),

                  ElevatedButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.payment),
                    label: const Text("Pay Now"),
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
