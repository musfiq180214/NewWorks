import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tempproject/core/provider/locale_provider.dart';
import 'package:tempproject/core/theme/theme_provider.dart';
import 'package:tempproject/core/provider/user_profile_provider.dart';
import 'package:tempproject/features/cart/provider/cart_provider.dart';
// import 'package:tempproject/features/payment/payment_screen.dart';
import 'package:tempproject/generated/l10n.dart';
import '../../core/routing/app_router.dart';

class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProfileProvider);

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("No user logged in")),
      );
    }

    final cart = ref.watch(cartProvider(user.email));

    double totalPrice = cart.fold(0, (sum, apt) => sum + apt.price);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).checkoutTitle),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => ref.read(localeProvider.notifier).toggleLocale(),
          ),
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
          ),
        ],
      ),
      body: cart.isEmpty
          ? const Center(child: Text("Your cart is empty"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final apt = cart[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        child: ListTile(
                          leading:
                              _buildApartmentImage(apt.image, width: 64, height: 64),
                          title: Text(apt.title),
                          subtitle:
                              Text("Price: \$${apt.price.toStringAsFixed(2)}"),
                          trailing: IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              ref
                                  .read(cartProvider(user.email).notifier)
                                  .remove(apt);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    border: const Border(top: BorderSide(color: Colors.grey)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Total: \$${totalPrice.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Navigate to PaymentScreen
                          Navigator.pushNamed(context, AppRouter.payment);
                        },
                        icon: const Icon(Icons.payment),
                        label: const Text("Proceed to Payment"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  /// Helper to display network or local file image
  Widget _buildApartmentImage(String path,
      {double width = 64, double height = 64}) {
    if (path.startsWith("http")) {
      return Image.network(
        path,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholderImage(width, height),
      );
    } else if (path.startsWith("file://")) {
      return Image.file(
        File(path.replaceFirst("file://", "")),
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholderImage(width, height),
      );
    } else {
      return _placeholderImage(width, height);
    }
  }

  Widget _placeholderImage(double width, double height) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[300],
      child: const Icon(Icons.image_not_supported, size: 24),
    );
  }
}
