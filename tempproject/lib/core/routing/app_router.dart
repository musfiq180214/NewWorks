import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:tempproject/core/provider/is_logged_in_provider.dart';
import 'package:tempproject/features/apartment/presentation/apartment_screen.dart';
import 'package:tempproject/features/apartment/presentation/apartment_view_screen.dart';
import 'package:tempproject/features/cart/presentation/cart_screen.dart';
import 'package:tempproject/features/checkout/checkout_screen.dart';
import 'package:tempproject/features/intro/intro_screen.dart';
import 'package:tempproject/features/login/presentation/login_screen.dart';
import 'package:tempproject/features/payment/payment_screen.dart';
import 'package:tempproject/features/register/presentation/register_screen.dart';
import 'package:tempproject/features/user_profile/user_profile_screen.dart';
import '../../features/apartment/presentation/post_apartment_screen.dart';
import '../../features/apartment/domain/apartment_model.dart';

class AppRouter {
  static const String intro = '/intro';
  static const String root = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String apartment = '/apartment';
  static const String apartmentView = '/apartment-view';
  static const String cart = '/cart';
  static const String postApartment = '/post-apartment';
  static const String userProfile = '/user-profile';
  static const String checkout = '/checkout';
  static const String payment = '/payment';
  static const String paymentSlip = '/payment_slip';

  /// Generate route dynamically
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case intro:
        return MaterialPageRoute(builder: (_) => const IntroScreen());
      case root:
        // Placeholder: redirect logic can be handled in main.dart
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case userProfile:
        return MaterialPageRoute(builder: (_) => const UserProfileScreen());
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
      case checkout:
        return MaterialPageRoute(builder: (_) => const CheckoutScreen());
      case payment:
        return MaterialPageRoute(builder: (_) => const PaymentScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }

  /// Navigation helper to **replace entire stack**
  static void pushReplacementAll(BuildContext context, String routeName) {
    Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false);
  }
}
