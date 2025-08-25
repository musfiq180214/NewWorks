import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tempproject/features/apartment/provider/apartment_sort_provider.dart';
import 'package:tempproject/features/cart/provider/cart_provider.dart';
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
          // =======================
          // Updated logout button
          // =======================
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: () async {
              await ref.read(isLoggedInProvider.notifier).logout();
              // Clear entire navigation stack and go to login
              AppRouter.pushReplacementAll(context, AppRouter.login);
            },
          ),
          IconButton(
  icon: const Icon(Icons.person),
  tooltip: "Profile",
  onPressed: () {
    Navigator.pushNamed(context, AppRouter.userProfile);
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
                final inCart = cart.any((a) => a?.id == apt.id);

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Colors.grey[50],
                  shadowColor: Colors.black.withValues(alpha: 0.2),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
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
                        // Apartment image
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          child: Image.network(
                            apt.image,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return SizedBox(
                                height: 200,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (_, __, ___) => Container(
                              height: 200,
                              color: Colors.grey[300],
                              child: const Icon(Icons.image_not_supported, size: 48),
                            ),
                          ),
                        ),

                        // Content
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                apt.title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                apt.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black54,
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Price: \$${apt.price.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerRight,
                                child: FilledButton.icon(
                                  onPressed: () {
                                    ref.read(cartProvider.notifier).toggle(apt);
                                  },
                                  style: FilledButton.styleFrom(
                                    backgroundColor: inCart ? Colors.red[400] : Colors.blue[600],
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 2,
                                  ),
                                  icon: Icon(
                                    inCart ? Icons.remove_shopping_cart : Icons.add_shopping_cart,
                                  ),
                                  label: Text(
                                    inCart ? 'Remove from Cart' : 'Add to Cart',
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
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
