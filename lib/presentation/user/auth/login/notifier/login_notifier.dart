import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:user_auth/data/model/auth/login_model.dart';
import 'package:user_auth/domain/usecase/auth/auth_usecase.dart';

class LoginNotifier extends ChangeNotifier {
  final TextEditingController _emailCtr = TextEditingController();
  final TextEditingController _pssCtr = TextEditingController();
  bool _isLoading = false;
  String? _emailErr;
  String? _pswErr;

  TextEditingController get emailCtr => _emailCtr;
  TextEditingController get pssCtr => _pssCtr;
  bool get isLoading => _isLoading;
  String? get emailErr => _emailErr;
  String? get pswErr => _pswErr;

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

  Future<bool> login() async {
    _isLoading = true;
    _pswErr = null;
    _emailErr = null;
    notifyListeners();
    try {
      final payload = LoginModel(email: _emailCtr.text, password: _pssCtr.text);
      await AuthUsecase().login(payload);
      return true;
    } on DioException catch (e) {
      final eM = e.response?.data["error"];
      if (e.response?.statusCode == 401 && eM == 'Email does not exist') {
        _emailErr = eM;
      } else if (e.response?.statusCode == 401 && eM == 'Incorrect password') {
        _pswErr = eM;
      } else {
        _emailErr = eM;
        _pswErr = eM;
      }
      notifyListeners();
      return false;
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
