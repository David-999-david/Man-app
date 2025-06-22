import 'package:flutter/material.dart';
import 'package:user_auth/domain/usecase/auth/auth_usecase.dart';

class ChangePasswordNotifier extends ChangeNotifier {
  final TextEditingController _newPsw = TextEditingController();
  final TextEditingController _confirmPsw = TextEditingController();

  TextEditingController get newPsw => _newPsw;
  TextEditingController get confirmPsw => _confirmPsw;

  bool _loading = false;
  bool get loading => _loading;

  bool _success = false;
  bool get success => _success;

  String? _msg;
  String? get msg => _msg;

  String? _errMsg;
  String? get errMsg => _errMsg;

  String? validateNewPsw(String value) {
    if (value.isEmpty) {
      return 'Password can\'t be empty';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validateConfirmPsw(String value) {
    if (value.isEmpty) {
      return 'Password can\'t be empty';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    if (value != newPsw.text) {
      return 'Password do not match';
    }
    return null;
  }

  void changePassword() async {
    _loading = true;
    _errMsg = null;
    _msg = null;
    notifyListeners();
    try {
      _msg = await AuthUsecase().changePassword(confirmPsw.text);
      _success = true;
    } catch (e) {
      _success = false;
      _errMsg = e.toString();
      notifyListeners();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _newPsw.dispose();
    _confirmPsw.dispose();
    super.dispose();
  }
}
