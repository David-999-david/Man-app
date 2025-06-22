import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:user_auth/common/constant/api_url.dart';
import 'package:user_auth/common/constant/local_name.dart';
import 'package:user_auth/common/helper/app_navigator.dart';
import 'package:user_auth/core/network/dio_client.dart';
import 'package:user_auth/data/model/auth/login_model.dart';
import 'package:user_auth/data/model/auth/register_model.dart';
import 'package:user_auth/data/model/auth/user_model.dart';
import 'package:user_auth/presentation/user/auth/login/login_screen.dart';

class AuthRemote {
  final Dio _dio = DioClient.dio;

  final _store = FlutterSecureStorage();

  Future<void> registerUser(RegisterModel user) async {
    try {
      final response = await _dio.post(ApiUrl.register, data: user.toJson());

      final code = response.statusCode;
      if (code != null && code >= 200 && code < 300) {
        final data = response.data['data'];
        final access = data['accessToken'];
        final refresh = data['refreshToken'];
        if (access != null) {
          await _store.write(key: LocalName.access, value: access);
        } else {
          throw Exception('Missing Access Token');
        }
        if (refresh != null) {
          await _store.write(key: LocalName.refreshToken, value: refresh);
        } else {
          throw Exception('Missing refresh Token');
        }
      } else {
        throw Exception('Fialed status in register : ${response.statusCode}');
      }
    } on DioException catch (err) {
      debugPrint(
          'Error when register : ${(err.response?.statusCode)},${err.response?.data}');
      rethrow;
    }
  }

  // Future<bool> isRealEmail(String email) async {
  //   try {
  //     final response =
  //         await _dio.post(ApiUrl.checkEmail, data: {'email': email});
  //     final code = response.statusCode;
  //     if (code == 200 && response.data['message'] == 'ok') {
  //       return true;
  //     } else if (code == 400) {
  //       throw Exception(response.data['error'] ?? 'Email valdation failed');
  //     }
  //     throw Exception('Unexpected status: $code');
  //   } on DioException catch (e) {
  //     final errorMsg = e.response?.data['error'] ?? 'Could not verify email';
  //     throw Exception(errorMsg);
  //   }
  // }
  // Future<void> verifyEmail(String token) async {
  //   try {
  //     final response =
  //         await _dio.get(ApiUrl.verifyEmail, queryParameters: {'token': token});
  //     if (response.statusCode == 200) {
  //       final data = response.data['data'];
  //       final access = data['accessToken'];
  //       final refresh = data['refreshToken'];
  //       if (access != null) {
  //         final local = await StorageUtils.getInstance();
  //         await local!.putString(LocalName.access, access);
  //       } else {
  //         throw Exception('Token is missing');
  //       }
  //       if (refresh != null) {
  //         final local = await StorageUtils.getInstance();
  //         await local!.putString(LocalName.refreshToken, refresh);
  //       }
  //     }
  //   } on DioException catch (e) {
  //     final errorMsg = e.response?.data['error'] ?? 'Could not verify email $e';
  //     throw Exception(errorMsg);
  //   }
  // }
  // Future<bool> checkVerification(String email) async {
  //   try {
  //     final response =
  //         await _dio.get(ApiUrl.checkEmail, queryParameters: {'email': email});
  //     if (response.statusCode == 200) {
  //       final verified = response.data['verified'];
  //       return verified as bool;
  //     } else {
  //       throw Exception(response.statusCode);
  //     }
  //   } on DioException catch (e) {
  //     final errorMsg = e.response?.data['error'] ?? 'Failed verification $e';
  //     throw Exception(errorMsg);
  //   }
  // }

  Future<void> login(LoginModel user) async {
    try {
      final response = await _dio.post(ApiUrl.login, data: user.toJson());

      final code = response.statusCode;
      if (code != null && code >= 200 && code < 300) {
        final data = response.data['data'];
        final access = data['accessToken']?.toString();
        final refresh = data['refreshToken']?.toString();
        debugPrint('This is access => $access');
        debugPrint('This is access => $refresh');
        if (access != null) {
          await _store.write(key: LocalName.access, value: access);
          final lclAcc = await _store.read(key: LocalName.access);
          debugPrint('This is access => $lclAcc');
        } else {
          throw Exception('Token is missing');
        }
        if (refresh != null) {
          await _store.write(key: LocalName.refreshToken, value: refresh);
          final lclRef = await _store.read(key: LocalName.refreshToken);
          debugPrint('This is access => $lclRef');
        }
      } else {
        throw Exception(
            'Failed status code in login => ${response.statusCode}');
      }
    } on DioException catch (err) {
      debugPrint(
          'Error when login  ${err.response?.statusCode}${err.response?.data['error']}');
      throw err;
    }
  }

  Future<UserModel> getUserProfile() async {
    try {
      final response = await _dio.get(ApiUrl.getProfile);
      debugPrint('Profile response => ${response.statusCode},${response.data}');
      if (response.statusCode != null && response.statusCode == 201) {
        return UserModel.fromJson(response.data);
      }
      throw Exception(
          'Failed to load profile Status => ${response.statusCode}');
    } on DioException catch (_) {
      // if (err.error == 'SESSION_EXPIRED') {
      //   signout();
      //   throw Exception('Session expired');
      // }
      // rethrow;
      throw Exception('Session expired');
    }
  }

  Future<void> signout() async {
    await _store.delete(key: LocalName.access);
    final access = await _store.read(key: LocalName.access);
    await _store.delete(key: LocalName.refreshToken);
    final refresh = await _store.read(key: LocalName.refreshToken);

    debugPrint('Access : $access , Refresh : $refresh');

    AppNavigator.pushAndRemoveUntil(LoginScreen());
  }

  Future<String> sendEmailOtp(String email) async {
    try {
      final response =
          await _dio.post(ApiUrl.sendEmailOtp, data: {'email': email});
      final status = response.statusCode!;
      if (status >= 200 && status < 300) {
        final message = response.data['message'];
        return message;
      } else {
        final err = response.data['error'] ?? 'Unknown error';
        throw err;
      }
    } on DioException catch (e) {
      throw '${e.response?.data['error']}';
    }
  }

  Future<String> verifyOtp(String email, String otp) async {
    try {
      final response =
          await _dio.post(ApiUrl.verifyOtp, data: {'email': email, 'otp': otp});

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final resetToken = response.data['resetToken'];
        debugPrint('This is reset Token from server => $resetToken');
        await _store.write(key: LocalName.resetToken, value: resetToken);

        final localReset = await _store.read(key: LocalName.resetToken);
        debugPrint('This is reset Token in local => $localReset');

        final message = response.data['message'];
        return message;
      } else {
        final errmsg = response.data['error'] ?? 'Unknown error';
        throw errmsg;
      }
    } on DioException catch (e) {
      throw e.response?.data['error'];
    }
  }

  Future<String> changePassword(String newPsw) async {
    try {
      final localReset = await _store.read(key: LocalName.resetToken);
      debugPrint('This is reset token from local => $localReset');

      final response = await _dio.post(ApiUrl.changePsw,
          data: {'resetToken': localReset, 'newPsw': newPsw});

      final status = response.statusCode!;

      if (status >= 200 && status < 300) {
        final msg = response.data['message'];
        return msg;
      } else {
        final errmsg = response.data['error'];
        throw errmsg;
      }
    } on DioException catch (e) {
      throw e.response?.data['error'];
    }
  }
}
