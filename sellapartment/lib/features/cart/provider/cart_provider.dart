import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sellapartment/features/apartment/domain/apartment_model.dart';

/// Holds the list of apartments currently in the cart
class CartNotifier extends StateNotifier<List<Apartment>> {
  CartNotifier() : super(const []);

  bool isInCart(String id) => state.any((a) => a.id == id);

  void add(Apartment apt) {
    if (!isInCart(apt.id)) {
      state = [...state, apt];
    }
  }

  void remove(Apartment apt) {
    state = state.where((a) => a.id != apt.id).toList();
  }

  void toggle(Apartment apt) {
    if (isInCart(apt.id)) {
      remove(apt);
    } else {
      add(apt);
    }
  }

  void clear() {
    state = const [];
  }
}

final cartProvider =
    StateNotifierProvider<CartNotifier, List<Apartment>>((ref) {
  return CartNotifier();
});
