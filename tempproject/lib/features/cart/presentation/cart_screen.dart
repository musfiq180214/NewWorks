import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tempproject/core/provider/locale_provider.dart';
import 'package:tempproject/core/provider/user_profile_provider.dart';
import 'package:tempproject/core/routing/app_router.dart';
import 'package:tempproject/core/theme/theme_provider.dart';
import 'package:tempproject/features/cart/provider/cart_provider.dart';
import 'package:tempproject/generated/l10n.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProfileProvider);

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("No user logged in")),
      );
    }

    final cart = ref.watch(cartProvider(user.email));

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).cartTitle),
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
          : ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final apt = cart[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      // Navigate to ApartmentView Screen
                      Navigator.pushNamed(
                        context,
                        AppRouter.apartmentView,
                        arguments: apt,
                      );
                    },
                    child: ListTile(
                      leading: _buildApartmentImage(apt.image, width: 64, height: 64),
                      title: Text(apt.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Type: ${apt.type}"),
                          const SizedBox(height: 4),
                          Text("Price: \$${apt.price.toStringAsFixed(2)}"),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          ref.read(cartProvider(user.email).notifier).remove(apt);
                        },
                      ),
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
                    Navigator.pushNamed(context, AppRouter.checkout);
                  },
                  icon: const Icon(Icons.payment),
                  label: Text('Checkout (${cart.length})'),
                ),
              ),
            ),
    );
  }

  /// Helper to display network or local file image
  Widget _buildApartmentImage(String path, {double width = 64, double height = 64}) {
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
