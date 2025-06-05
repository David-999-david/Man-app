import 'package:user_auth/data/model/auth/register_model.dart';
import 'package:user_auth/domain/repository/auth/auth_repo.dart';

class AuthUsecase {
  Future<void> register(RegisterModel user) async {
    return await AuthRepo().register(user);
  }
}
