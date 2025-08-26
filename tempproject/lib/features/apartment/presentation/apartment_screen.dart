import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tempproject/core/provider/user_profile_provider.dart';
import 'package:tempproject/features/apartment/provider/apartment_provider.dart';
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

    // Apply type filter
    final typeFilter = ref.watch(apartmentTypeFilterProvider);
    final typeFilteredApartments = sortedApartments.where((apt) {
      switch (typeFilter) {
        case ApartmentTypeFilter.all:
          return true;
        case ApartmentTypeFilter.forSale:
          return apt.type.toLowerCase() == 'for sale';
        case ApartmentTypeFilter.toRent:
          return apt.type.toLowerCase() == 'to rent';
      }
    }).toList();

    // --- Price filter ---
    final maxPrice = typeFilteredApartments.isEmpty
        ? 1000.0
        : typeFilteredApartments
            .map((a) => a.price)
            .reduce((a, b) => a > b ? a : b)
            .toDouble();

    final priceRange = ref.watch(priceRangeProvider);
    final adjustedRange = RangeValues(
      priceRange.start.clamp(0, maxPrice),
      priceRange.end.isInfinite ? maxPrice : priceRange.end.clamp(0, maxPrice),
    );

    final filteredApartments = typeFilteredApartments.where((apt) {
      return apt.price >= adjustedRange.start &&
          apt.price <= adjustedRange.end;
    }).toList();

    return Scaffold(
      appBar: AppBar(
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
          const SizedBox(height: 5),
          FloatingActionButton.extended(
            onPressed: () {
              Navigator.pushNamed(context, AppRouter.postApartment);
            },
            icon: const Icon(Icons.add),
            label: const Text("Post"),
          ),
          const SizedBox(height: 10),

          // Type filter buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ApartmentTypeFilter.values.map((filter) {
                final isSelected =
                    ref.watch(apartmentTypeFilterProvider) == filter;
                String label;
                switch (filter) {
                  case ApartmentTypeFilter.all:
                    label = "All types";
                    break;
                  case ApartmentTypeFilter.forSale:
                    label = "For Sale";
                    break;
                  case ApartmentTypeFilter.toRent:
                    label = "To Rent";
                    break;
                }
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isSelected ? Colors.blue : Colors.grey[300],
                    foregroundColor:
                        isSelected ? Colors.white : Colors.black,
                  ),
                  onPressed: () {
                    ref.read(apartmentTypeFilterProvider.notifier).state =
                        filter;
                  },
                  child: Text(label),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 10),

          // Sort filter buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:
                  SortType.values.where((s) => s != SortType.none).map((sort) {
                final isSelected = ref.watch(apartmentSortProvider) == sort;
                String label;
                switch (sort) {
                  case SortType.alphabetic:
                    label = "A-Z";
                    break;
                  case SortType.priceHighToLow:
                    label = "Price ⬆";
                    break;
                  case SortType.priceLowToHigh:
                    label = "Price ⬇";
                    break;
                  default:
                    label = "";
                }
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isSelected ? Colors.blue : Colors.grey[300],
                    foregroundColor:
                        isSelected ? Colors.white : Colors.black,
                  ),
                  onPressed: () {
                    ref.read(apartmentSortProvider.notifier).state = sort;
                  },
                  child: Text(label),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 10),

          // Price Range Slider + Apartment Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Text(
                  "Price Range: \$${adjustedRange.start.toStringAsFixed(0)} - \$${adjustedRange.end.toStringAsFixed(0)}",
                  style: const TextStyle(fontSize: 16),
                ),
                RangeSlider(
                  values: adjustedRange,
                  min: 0,
                  max: maxPrice,
                  divisions: maxPrice > 100 ? 100 : maxPrice.toInt(),
                  labels: RangeLabels(
                    adjustedRange.start.toStringAsFixed(0),
                    adjustedRange.end.toStringAsFixed(0),
                  ),
                  onChanged: (values) {
                    if (values.start <= values.end) {
                      ref.read(priceRangeProvider.notifier).state = values;
                    }
                  },
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Text(
                    "Showing ${filteredApartments.length} apartment(s)",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(),

          // Scrollable apartment list
          Expanded(
            child: filteredApartments.isEmpty
                ? const Center(
                    child: Text(
                      "No results match your search.",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredApartments.length,
                    itemBuilder: (context, index) {
                      final apt = filteredApartments[index];
                      final inCart = cart.any((a) => a.id == apt.id);

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
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
                                      apt.type,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      apt.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                        "Price: \$${apt.price.toStringAsFixed(2)}"),
                                    const SizedBox(height: 12),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: FilledButton.icon(
                                        onPressed: () {
                                          ref
                                              .read(cartProvider(user.email)
                                                  .notifier)
                                              .toggle(apt);
                                        },
                                        icon: Icon(
                                          inCart
                                              ? Icons.remove_shopping_cart
                                              : Icons.add_shopping_cart,
                                        ),
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
