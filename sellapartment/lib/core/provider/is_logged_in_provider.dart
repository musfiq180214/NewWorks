import 'package:flutter_riverpod/flutter_riverpod.dart';

// Keeps track if user is logged in globally
final isLoggedInProvider = StateProvider<bool>((ref) => false);
