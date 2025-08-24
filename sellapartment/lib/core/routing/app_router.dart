import 'package:flutter/material.dart';
import 'package:sellapartment/features/login/presentation/login_screen.dart';
import 'package:sellapartment/features/apartment/presentation/apartment_screen.dart';
import 'package:sellapartment/features/landing/presentation/landing_screen.dart';
import 'package:sellapartment/features/apartment/presentation/apartment_view_screen.dart';
import 'package:sellapartment/features/cart/presentation/cart_screen.dart';
import 'package:sellapartment/features/apartment/domain/apartment_model.dart';
import '../../features/apartment/presentation/post_apartment_screen.dart';
class AppRouter {
  static const String root = '/';
  static const String login = '/login';
  static const String apartment = '/apartment';
  static const String apartmentView = '/apartment-view';
  static const String cart = '/cart';
  static const String postApartment = '/post-apartment';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case root:
        return MaterialPageRoute(builder: (_) => const LandingScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case apartment:
        return MaterialPageRoute(builder: (_) => const ApartmentScreen());
      case postApartment:
        return MaterialPageRoute(builder: (_) => const PostApartmentScreen());
      case apartmentView:
        final apt = settings.arguments as Apartment;
        return MaterialPageRoute(
          builder: (_) => ApartmentViewScreen(apartment: apt),
        );
      case cart:
        return MaterialPageRoute(builder: (_) => const CartScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
