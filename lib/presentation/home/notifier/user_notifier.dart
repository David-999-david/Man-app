import 'package:flutter/material.dart';
import 'package:user_auth/data/model/auth/user_model.dart';
import 'package:user_auth/domain/usecase/auth/auth_usecase.dart';

class UserNotifier extends ChangeNotifier {
  bool _isLoading = false;
  UserModel? _user;

  bool get isLoading => _isLoading;
  UserModel? get user => _user;

  void getUserProfile() async {
    _isLoading = true;
    notifyListeners();
    try {
      _user = await AuthUsecase().getUserProfile();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void signOut() async {
    await AuthUsecase().signOut();
  }
}
