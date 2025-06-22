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

  final TextEditingController _codeCtrl = TextEditingController();
  TextEditingController get codeCtrl => _codeCtrl;

  Future<void> verifyOtp() async {
    _loading = true;
    notifyListeners();
    try {
      _msg = await AuthUsecase().verifyOtp(email, _codeCtrl.text);
      _success = true;
    } catch (e) {
      _success = false;
      throw Exception('$e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }
}
