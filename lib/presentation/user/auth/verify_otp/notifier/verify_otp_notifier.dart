import 'package:flutter/material.dart';
import 'package:user_auth/domain/usecase/auth/auth_usecase.dart';

class VerifyOtpNotifier extends ChangeNotifier {
  final String email;
  VerifyOtpNotifier(this.email);
  bool _loading = false;
  bool get loading => _loading;

  String? _msg;
  String? get msg => _msg;

  bool _success = false;
  bool get success => _success;

  // final TextEditingController _codeCtrl = TextEditingController();
  // TextEditingController get codeCtrl => _codeCtrl;

  String _pin = '';
  String get pin => _pin;

  void updatePin(String value) {
    _pin = value;
    notifyListeners();
  }

  String? _errMsg;
  String? get errMsg => _errMsg;

  Future<void> verifyOtp() async {
    _loading = true;
    _errMsg = null;
    notifyListeners();
    try {
      _msg = await AuthUsecase().verifyOtp(email, _pin);
      _success = true;
    } catch (e) {
      _success = false;
      _errMsg = e.toString();
    } finally {
      _loading = false;
      
      notifyListeners();
    }
  }
}
