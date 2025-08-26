import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tempproject/features/apartment/provider/apartment_sort_provider.dart';
import 'package:tempproject/features/cart/provider/cart_provider.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/provider/locale_provider.dart';
import '../../../core/provider/is_logged_in_provider.dart';
import '../../../core/provider/user_profile_provider.dart';
import '../../../core/routing/app_router.dart';
import '../../../generated/l10n.dart';

class ApartmentScreen extends ConsumerWidget {
  const ApartmentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apartments = ref.watch(apartmentListProvider);
    final sortType = ref.watch(apartmentSortProvider);
    final user = ref.watch(userProfileProvider);

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("No user logged in")),
      );
    }

    final cart = ref.watch(cartProvider(user.email));

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
            onPressed: () async {
              await ref.read(isLoggedInProvider.notifier).logout();
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
                final inCart = cart.any((a) => a.id == apt.id);

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
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
                        _buildApartmentImage(apt.image),
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                apt.title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                apt.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 10),
                              Text("Price: \$${apt.price.toStringAsFixed(2)}"),
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerRight,
                                child: FilledButton.icon(
                                  onPressed: () {
                                    ref.read(cartProvider(user.email).notifier).toggle(apt);
                                  },
                                  icon: Icon(inCart
                                      ? Icons.remove_shopping_cart
                                      : Icons.add_shopping_cart),
                                  label: Text(inCart ? 'Remove' : 'Add'),
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

  /// Helper method to display network or file image correctly
  Widget _buildApartmentImage(String path) {
    if (path.startsWith("http")) {
      return Image.network(
        path,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholderImage(),
      );
    } else if (path.startsWith("file://")) {
      return Image.file(
        File(path.replaceFirst("file://", "")),
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholderImage(),
      );
    } else {
      return _placeholderImage();
    }
  }

  Widget _placeholderImage() {
    return Container(
      height: 200,
      color: Colors.grey[300],
      child: const Icon(Icons.image_not_supported, size: 48),
    );
  }
}
