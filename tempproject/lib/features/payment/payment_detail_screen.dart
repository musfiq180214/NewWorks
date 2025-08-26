import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tempproject/core/provider/user_profile_provider.dart';
import 'package:tempproject/features/cart/provider/cart_provider.dart';

class PaymentDetailScreen extends ConsumerWidget {
  final double totalAmount;
  final String cardHolder;
  final String maskedCard;

  const PaymentDetailScreen({
    super.key,
    required this.totalAmount,
    required this.cardHolder,
    required this.maskedCard,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WillPopScope(
      onWillPop: () async => false, // Disable Android back button
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Payment Confirmation"),
          centerTitle: true,
          automaticallyImplyLeading: false, // Remove back button
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 80),
              const SizedBox(height: 16),
              const Text(
                "Payment Successful!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Text(
                "Total Paid: \$${totalAmount.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                "Card Holder: $cardHolder",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                "Card Used: $maskedCard",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // After confirmation, go back to Apartments screen
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text("Back to Apartments"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
