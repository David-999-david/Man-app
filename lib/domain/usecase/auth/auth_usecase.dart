import 'package:user_auth/data/model/auth/login_model.dart';
import 'package:user_auth/data/model/auth/register_model.dart';
import 'package:user_auth/data/model/auth/user_model.dart';
import 'package:user_auth/domain/repository/auth/auth_repo.dart';

class AuthUsecase {
  Future<void> register(RegisterModel user) async {
    return await AuthRepo().register(user);
  }

  Future<void> login(LoginModel user) async {
    return await AuthRepo().login(user);
  }

  Future<UserModel> getUserProfile() async {
    return await AuthRepo().getUserProfile();
  }

  Future<void> signOut() async {
    return await AuthRepo().signOut();
  }

  // Future<bool> isRealEmail(String email) async {
  //   return await AuthRepo().isRealEmail(email);
  // }

  // Future<void> verifyEmail(String token) {
  //   return AuthRepo().verifyEmail(token);
  // }

  // Future<bool> checkVerification(String email) {
  //   return AuthRepo().checkVerification(email);
  // }

  Future<String> sendEmailOtp(String email) async {
    return await AuthRepo().sendEmailOtp(email);
  }

  Future<String> verifyOtp(String email, String otp) async {
    return await AuthRepo().verifyOtp(email, otp);
  }

  Future<String> changePassword(String newPsw) async {
    return await AuthRepo().changePassword(newPsw);
  }
}
