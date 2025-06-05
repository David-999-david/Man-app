import 'package:flutter/material.dart';
import 'package:user_auth/data/model/auth/register_model.dart';
import 'package:user_auth/domain/usecase/auth/auth_usecase.dart';

class RegisterNotifier extends ChangeNotifier {
  final TextEditingController _emailCtr = TextEditingController();
  final TextEditingController _pssCtr = TextEditingController();
  final TextEditingController _nameCtr = TextEditingController();
  bool _isLoading = false;

  TextEditingController get emailCtr => _emailCtr;
  TextEditingController get pssCtr => _pssCtr;
  TextEditingController get nameCtr => _nameCtr;
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

  Future<void> register() async {
    _isLoading = true;
    notifyListeners();
    try {
      await AuthUsecase().register(RegisterModel(
          name: _nameCtr.text, email: _emailCtr.text, password: _pssCtr.text));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _nameCtr.dispose();
    _emailCtr.dispose();
    _pssCtr.dispose();
    super.dispose();
  }
}
