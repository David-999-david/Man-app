import 'package:flutter/material.dart';
import 'package:user_auth/data/model/auth/login_model.dart';
import 'package:user_auth/domain/usecase/auth/auth_usecase.dart';

class LoginNotifier extends ChangeNotifier {
  final TextEditingController _emailCtr = TextEditingController();
  final TextEditingController _pssCtr = TextEditingController();
  bool _isLoading = false;

  TextEditingController get emailCtr => _emailCtr;
  TextEditingController get pssCtr => _pssCtr;
  bool get isLoading => _isLoading;

  bool isVisable = true;

  void onShown() {
    if (_pssCtr.text.trim().isNotEmpty) {
      isVisable = !isVisable;
      notifyListeners();
    } else {
      isVisable = !isVisable;
      notifyListeners();
    }
  }

  Future<void> login() async {
    _isLoading = true;
    notifyListeners();
    try {
      final payload = LoginModel(email: _emailCtr.text, password: _pssCtr.text);
      await AuthUsecase().login(payload);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _emailCtr.dispose();
    _pssCtr.dispose();
    super.dispose();
  }
}
