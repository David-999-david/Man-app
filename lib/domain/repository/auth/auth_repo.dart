import 'package:dio/dio.dart';
import 'package:user_auth/data/model/auth/login_model.dart';
import 'package:user_auth/data/model/auth/register_model.dart';
import 'package:user_auth/data/model/auth/user_model.dart';
import 'package:user_auth/data/remote/auth/auth_remote.dart';

class AuthRepo {
  Future<void> register(RegisterModel user) {
    return AuthRemote().registerUser(user);
  }

  Future<void> login(LoginModel user) {
    return AuthRemote().login(user);
  }

  Future<UserModel> getUserProfile() {
    return AuthRemote().getUserProfile();
  }

  Future<void> signOut() {
    return AuthRemote().signout();
  }

  // Future<bool> isRealEmail(String email) {
  //   return AuthRemote().isRealEmail(email);
  // }

  // Future<void> verifyEmail(String token) {
  //   return AuthRemote().verifyEmail(token);
  // }

  // Future<bool> checkVerification(String email) {
  //   return AuthRemote().checkVerification(email);
  // }

  Future<String> sendEmailOtp(String email) {
    return AuthRemote().sendEmailOtp(email);
  }

  Future<String> verifyOtp(String email, String otp) {
    return AuthRemote().verifyOtp(email, otp);
  }

  Future<String> changePassword(String newPsw) {
    return AuthRemote().changePassword(newPsw);
  }

  Future<String> uploadProfile(FormData form) {
    return AuthRemote().uploadProfile(form);
  }
}
