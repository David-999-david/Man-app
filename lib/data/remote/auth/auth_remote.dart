import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:user_auth/common/constant/api_url.dart';
import 'package:user_auth/common/constant/local_name.dart';
import 'package:user_auth/core/network/dio_client.dart';
import 'package:user_auth/core/network/storage_utils.dart';
import 'package:user_auth/data/model/auth/login_model.dart';
import 'package:user_auth/data/model/auth/register_model.dart';

class AuthRemote {
  final Dio _dio = DioClient().dio;

  Future<void> registerUser(RegisterModel user) async {
    try {
      final response = await _dio.post(ApiUrl.register, data: user.toJson());

      final code = response.statusCode;
      if (code != null && code >= 200 && code < 300) {
        final token = response.data['token'];
        if (token != null) {
          final local = await StorageUtils.getInstance();
          await local!.putString(LocalName.authToken, token);
        } else {
          throw Exception('Token is missing');
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
        final token = response.data['token'];
        if (token != null) {
          final local = await StorageUtils.getInstance();
          await local!.putString(LocalName.authToken, token);
        } else {
          throw Exception('Token is missing');
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
}
