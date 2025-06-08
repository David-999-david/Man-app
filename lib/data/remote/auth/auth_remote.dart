import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:user_auth/common/constant/api_url.dart';
import 'package:user_auth/common/constant/local_name.dart';
import 'package:user_auth/common/helper/app_navigator.dart';
import 'package:user_auth/core/network/dio_client.dart';
import 'package:user_auth/core/network/storage_utils.dart';
import 'package:user_auth/data/model/auth/login_model.dart';
import 'package:user_auth/data/model/auth/register_model.dart';
import 'package:user_auth/data/model/auth/user_model.dart';
import 'package:user_auth/presentation/user/auth/login/login_screen.dart';

class AuthRemote {
  final Dio _dio = DioClient().dio;

  Future<void> registerUser(RegisterModel user) async {
    try {
      final response = await _dio.post(ApiUrl.register, data: user.toJson());

      final code = response.statusCode;
      if (code != null && code >= 200 && code < 300) {
        final data = response.data['data'];
        final access = data['accessToken'];
        final refresh = data['refreshToken'];
        if (access != null) {
          final local = await StorageUtils.getInstance();
          await local!.putString(LocalName.access, access);
        } else {
          throw Exception('Token is missing');
        }
        if (refresh != null) {
          final local = await StorageUtils.getInstance();
          await local!.putString(LocalName.refreshToken, refresh);
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

  Future<void> login(LoginModel user) async {
    try {
      final response = await _dio.post(ApiUrl.login, data: user.toJson());

      final code = response.statusCode;
      if (code != null && code >= 200 && code < 300) {
        final data = response.data['data'];
        final access = data['accessToken'];
        final refresh = data['refreshToken'];
        if (access != null) {
          final local = await StorageUtils.getInstance();
          await local!.putString(LocalName.access, access);
        } else {
          throw Exception('Token is missing');
        }
        if (refresh != null) {
          final local = await StorageUtils.getInstance();
          await local!.putString(LocalName.refreshToken, refresh);
        }
      } else {
        throw Exception(
            'Failed status code in login => ${response.statusCode}');
      }
    } on DioException catch (err) {
      debugPrint(
          'Error when login  ${err.response?.statusCode}${err.response?.data}');
    }
  }

  Future<UserModel> getUserProfile() async {
    try {
      final response = await _dio.get(ApiUrl.getProfile);
      if (response.statusCode != null && response.statusCode == 201) {
        return UserModel.fromJson(response.data);
      }
      throw Exception(
          'Failed to load profile Status => ${response.statusCode}');
    } on DioException catch (err) {
      if (err.response?.statusCode == 401 || err.error == 'SESSION_EXPIRED') {
        signout();
        throw Exception('Session expired');
      }
      rethrow;
    }
  }

  Future<void> signout() async {
    final local = await StorageUtils.getInstance();
    await local!.remove(LocalName.access);
    await local.remove(LocalName.refreshToken);

    AppNavigator.pushAndRemoveUntil(LoginScreen());
  }
}
