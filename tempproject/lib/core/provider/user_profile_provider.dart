import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tempproject/data/user_repository.dart';
import 'is_logged_in_provider.dart';

class UserProfile {
  final String email;
  final String name;
  final String contact;
  final int age;

  UserProfile({
    required this.email,
    required this.name,
    required this.contact,
    required this.age,
  });
}

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile?>(
  (ref) => UserProfileNotifier(ref),
);

class UserProfileNotifier extends StateNotifier<UserProfile?> {
  final Ref ref;
  UserProfileNotifier(this.ref) : super(null) {
    _loadUser();
  }

  Future<void> _loadUser() async {
    final email = await ref.read(isLoggedInProvider.notifier).getLoggedInEmail();
    if (email != null) {
      final user = UserRepository().getUserByEmail(email);
      if (user != null) setUser(user);
    }
  }

  void setUser(User user) {
    state = UserProfile(
      email: user.email,
      name: user.name,
      contact: user.contact,
      age: user.age,
    );
  }

  void clearUser() {
    state = null;
  }
}
