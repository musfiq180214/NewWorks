// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../domain/apartment_model.dart';
// import '../data/apartment_repository.dart';

// enum SortType { none, alphabetic, priceHighToLow, priceLowToHigh }

// final apartmentListProvider = StateProvider<List<Apartment>>((ref) {
//   return ApartmentRepository().getApartments();
// });

// final apartmentSortProvider = StateProvider<SortType>((ref) => SortType.none);

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/apartment_model.dart';
import '../data/apartment_repository.dart';

enum SortType { none, alphabetic, priceHighToLow, priceLowToHigh }

/// A StateNotifier to manage apartments (add/remove/mutate).
class ApartmentListNotifier extends StateNotifier<List<Apartment>> {
  ApartmentListNotifier() : super(ApartmentRepository().getApartments());

  void addApartment(Apartment apt) {
    state = [...state, apt];
  }

  void removeApartment(String id) {
    state = state.where((a) => a.id != id).toList();
  }
}

/// Provide the apartments list.
final apartmentListProvider =
    StateNotifierProvider<ApartmentListNotifier, List<Apartment>>(
  (ref) => ApartmentListNotifier(),
);

/// Sort type provider stays the same.
final apartmentSortProvider = StateProvider<SortType>((ref) => SortType.none);
