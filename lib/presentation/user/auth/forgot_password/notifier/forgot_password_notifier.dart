import 'package:flutter/cupertino.dart';
import 'package:user_auth/domain/usecase/auth/auth_usecase.dart';

class ForgotPasswordNotifier extends ChangeNotifier {
  final TextEditingController _emailCtrl = TextEditingController();

  final key = GlobalKey<FormState>();

  TextEditingController get emailCtrl => _emailCtrl;

  bool _success = false;

  bool get success => _success;

  String? _msg;

  String? get msg => _msg;

  String? _errmsg;

  String? get errmsg => _errmsg;

  bool _loading = false;

  bool get loading => _loading;

  Future<void> sendEmailOtp() async {
    _loading = true;
    _errmsg = null;
    notifyListeners();
    try {
      _msg =
          await AuthUsecase().sendEmailOtp(_emailCtrl.text.toString().trim());
      _success = true;
      notifyListeners();
    } catch (e) {
      _success = false;
      _errmsg = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }
}
