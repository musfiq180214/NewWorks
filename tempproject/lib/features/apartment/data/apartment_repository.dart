// apartment_repository.dart
import '../domain/apartment_model.dart';
import '../../../core/constants/urls.dart';

class ApartmentRepository {
  List<Apartment> getApartments() {
    return [
      Apartment(
        id: "1",
        title: "Luxury View Apartment 🏖️",
        image: Urls.apartmentImages[0],
        description: "cool apartment, south view",
        price: 10000,
        type: "For Sale",
      ),
      Apartment(
        id: "2",
        title: "Modern City Apartment 🏙️",
        image: Urls.apartmentImages[1],
        description: "nice apartment, lake view",
        price: 15000,
        type: "To Rent",
      ),
      Apartment(
        id: "3",
        title: "Cozy Countryside 🌳",
        image: Urls.apartmentImages[2],
        description: "cool apartment, west view",
        price: 20000,
        type: "For Sale",
      ),
      Apartment(
        id: "4",
        title: "Penthouse with Skyline 🌆",
        image: Urls.apartmentImages[3],
        description: "cool apartment, river view",
        price: 30000,
        type: "For Sale",
      ),
      Apartment(
        id: "5",
        title: "Rustic Mountain Cabin 🏔️",
        image: Urls.apartmentImages[4],
        description: "cool apartment, super view",
        price: 40000,
        type: "To Rent",
      ),
    ];
  }
}
