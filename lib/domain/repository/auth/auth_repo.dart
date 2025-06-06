import 'package:user_auth/data/model/auth/login_model.dart';
import 'package:user_auth/data/model/auth/register_model.dart';
import 'package:user_auth/data/remote/auth/auth_remote.dart';

class AuthRepo {
  Future<void> register(RegisterModel user) {
    return AuthRemote().registerUser(user);
  }

  Future<void> login(LoginModel user){
    return AuthRemote().login(user);
  }
}
