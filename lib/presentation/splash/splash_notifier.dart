import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:user_auth/common/constant/api_url.dart';
import 'package:user_auth/common/constant/local_name.dart';
import 'package:user_auth/common/helper/app_navigator.dart';
import 'package:user_auth/core/network/dio_client.dart';
import 'package:user_auth/presentation/active/active_screen.dart';
import 'package:user_auth/presentation/user/auth/login/login_screen.dart';

class SplashNotifier extends ChangeNotifier {
  final Dio _dio = DioClient.dio;

  bool _checking = false;
  bool get checking => _checking;

  void determineStart() async {
    _checking = true;
    notifyListeners();
    try {
      final storage = FlutterSecureStorage();
      final refreshTok = await storage.read(key: LocalName.refreshToken);

      if (refreshTok != null && !JwtDecoder.isExpired(refreshTok)) {
        final response =
            await _dio.post(ApiUrl.refresh, data: {'refreshToken': refreshTok});

        final status = response.statusCode!;
        if (status >= 200 && status < 300) {
          final data = response.data as Map<String, dynamic>;

          final newAccess = data['newAccess'] as String?;
          final newRefresh = data['newRefresh'] as String?;

          if (newAccess != null && newRefresh != null) {
            await storage.write(key: LocalName.access, value: newAccess);

            await storage.write(key: LocalName.refreshToken, value: newRefresh);

            AppNavigator.pushAndRemoveUntil(ActiveScreen(
              pageIdx: 0,
            ));
          }
        } else {
          throw Exception(
              'Error => status=$status , message=${response.data['error']}');
        }
      } else {
        await storage.delete(key: LocalName.access);
        await storage.delete(key: LocalName.refreshToken);

        AppNavigator.pushAndRemoveUntil(LoginScreen());
      }
    } catch (e) {
      debugPrint(e.toString());
      final storage = FlutterSecureStorage();
      await storage.delete(key: LocalName.access);
      await storage.delete(key: LocalName.refreshToken);

      AppNavigator.pushAndRemoveUntil(LoginScreen());
    } finally {
      _checking = false;
      notifyListeners();
    }
  }
}
