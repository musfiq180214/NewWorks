import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sellapartment/features/apartment/provider/apartment_sort_provider.dart';
import 'package:sellapartment/features/cart/provider/cart_provider.dart';
import '../provider/apartment_provider.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/provider/locale_provider.dart';
import '../../../core/provider/is_logged_in_provider.dart';
import '../../../core/routing/app_router.dart';
import '../../../generated/l10n.dart';

class ApartmentScreen extends ConsumerWidget {
  const ApartmentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apartments = ref.watch(apartmentListProvider);
    final sortType = ref.watch(apartmentSortProvider);
    final cart = ref.watch(cartProvider);

    // Sort apartments
    final sortedApartments = List.of(apartments);
    switch (sortType) {
      case SortType.alphabetic:
        sortedApartments.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortType.priceHighToLow:
        sortedApartments.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortType.priceLowToHigh:
        sortedApartments.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortType.none:
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).apartmentTitle),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            tooltip: "Toggle Language",
            onPressed: () => ref.read(localeProvider.notifier).toggleLocale(),
          ),
          IconButton(
            icon: const Icon(Icons.brightness_6),
            tooltip: "Toggle Theme",
            onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
          ),
          // Cart with badge
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                tooltip: "Cart",
                onPressed: () {
                  Navigator.pushNamed(context, AppRouter.cart);
                },
              ),
              if (cart.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: Text(
                      '${cart.length}',
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: () {
              ref.read(isLoggedInProvider.notifier).state = false;
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRouter.login,
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          FloatingActionButton.extended(
            onPressed: () {
              Navigator.pushNamed(context, AppRouter.postApartment);
              },
              icon: const Icon(Icons.add),
              label: const Text("Post"),
              ),
          
          // Sorting buttons
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => ref.read(apartmentSortProvider.notifier).state =
                      SortType.alphabetic,
                  child: const Text("A"),
                ),
                ElevatedButton(
                  onPressed: () => ref.read(apartmentSortProvider.notifier).state =
                      SortType.priceHighToLow,
                  child: const Icon(Icons.arrow_upward),
                ),
                ElevatedButton(
                  onPressed: () => ref.read(apartmentSortProvider.notifier).state =
                      SortType.priceLowToHigh,
                  child: const Icon(Icons.arrow_downward),
                ),
              ],
            ),
          ),
          const Divider(),
          // Scrollable apartment list
          Expanded(
            child: ListView.builder(
              itemCount: sortedApartments.length,
              itemBuilder: (context, index) {
                final apt = sortedApartments[index];
                final inCart = cart.any((a) => a.id == apt.id);

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRouter.apartmentView,
                        arguments: apt,
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Image.network(
                          apt.image,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                apt.title,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                apt.description,
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.grey),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Price: \$${apt.price.toStringAsFixed(2)}",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton.icon(
                                  onPressed: () {
                                    ref.read(cartProvider.notifier).toggle(apt);
                                  },
                                  icon: Icon(inCart
                                      ? Icons.remove_shopping_cart
                                      : Icons.add_shopping_cart),
                                  label: Text(
                                      inCart ? 'Remove from Cart' : 'Add to Cart'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),


        ],
      ),
    );
  }
}
