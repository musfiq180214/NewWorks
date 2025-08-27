import 'package:flutter/material.dart';
import '../../auth/domain/user_entity.dart';
import '../data/home_repository.dart';

class HomeProvider extends ChangeNotifier {
  final HomeRepository _repository = HomeRepository();
  UserEntity? currentUser;
  bool isLoading = false;

  Future<void> loadUser(UserEntity user) async {
    isLoading = true;
    notifyListeners();

    currentUser = await _repository.getUserProfile(user);

    isLoading = false;
    notifyListeners();
  }
}
