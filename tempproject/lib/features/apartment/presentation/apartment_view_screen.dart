import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tempproject/features/apartment/domain/apartment_model.dart';
import 'package:tempproject/features/cart/provider/cart_provider.dart';

class ApartmentViewScreen extends ConsumerWidget {
  const ApartmentViewScreen({super.key, required this.apartment});

  final Apartment apartment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final inCart = cart.any((a) => a.id == apartment.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(apartment.title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              apartment.image,
              height: 220,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            apartment.title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            apartment.description,
            style: const TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
          ),
          const SizedBox(height: 12),
          Text(
            "Price: \$${apartment.price.toStringAsFixed(2)}",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              ref.read(cartProvider.notifier).toggle(apartment);
            },
            icon: Icon(inCart ? Icons.remove_shopping_cart : Icons.add_shopping_cart),
            label: Text(inCart ? 'Remove from Cart' : 'Add to Cart'),
          ),
        ],
      ),
    );
  }
}
