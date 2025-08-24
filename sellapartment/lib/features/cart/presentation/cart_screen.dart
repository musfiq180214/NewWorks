import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sellapartment/core/provider/locale_provider.dart';
import 'package:sellapartment/core/theme/theme_provider.dart';
import 'package:sellapartment/features/cart/provider/cart_provider.dart';
import 'package:sellapartment/generated/l10n.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).cartTitle),
  // title: Text('Cart'), // or S.of(context).cart if you want localization
  centerTitle: true,
  actions: [
    // Language toggle button
    IconButton(
      icon: const Icon(Icons.language),
      tooltip: "Toggle Language",
      onPressed: () => ref.read(localeProvider.notifier).toggleLocale(),
    ),
    // Theme toggle button
    IconButton(
      icon: const Icon(Icons.brightness_6),
      tooltip: "Toggle Theme",
      onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
    ),
  ],
),

      body: cart.isEmpty
          ? const Center(
              child: Text(
                "Your cart is empty",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final apt = cart[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        apt.image,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(apt.title),
                    subtitle: Text("Price: \$${apt.price.toStringAsFixed(2)}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      tooltip: "Remove",
                      onPressed: () {
                        ref.read(cartProvider.notifier).remove(apt);
                      },
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: cart.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Placeholder for checkout action
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Checkout not implemented')),
                    );
                  },
                  icon: const Icon(Icons.payment),
                  label: Text('Checkout (${cart.length})'),
                ),
              ),
            ),
    );
  }
}
