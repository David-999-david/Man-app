import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:user_auth/common/constant/api_url.dart';
import 'package:user_auth/common/constant/local_name.dart';
import 'package:user_auth/common/helper/app_navigator.dart';
import 'package:user_auth/core/network/dio_client.dart';
import 'package:user_auth/core/network/storage_utils.dart';
import 'package:user_auth/presentation/user/auth/login/login_screen.dart';

class AuthInterceptor extends Interceptor {
  final StorageUtils _storageUtils;

  AuthInterceptor._(this._storageUtils);

  final Dio _dio = DioClient().dio;

  static Future<AuthInterceptor> create() async {
    final storage = await StorageUtils.getInstance();
    return AuthInterceptor._(storage!);
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    String? token = await _storageUtils.getString(LocalName.authToken);
    final expired = token == null || JwtDecoder.isExpired(token);

    if (expired) {
      final ok = await refreshToken();
      if (!ok) {
        return handler.reject(DioException(
            requestOptions: options,
            response: Response(requestOptions: options, statusCode: 401),
            error: 'SESSION_EXPIRED',
            type: DioExceptionType.cancel));
      }
      token = _storageUtils.getString(LocalName.authToken);
    }

    if (token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;

    if (statusCode == 401 && err.error != 'SESSION_EXPIRED') {
      final ok = await refreshToken();
      if (ok) {
        final fresh = await _storageUtils.getString(LocalName.authToken);
        err.requestOptions.headers['Authorization'] = 'Bearer $fresh';
        try {
          final retry = await _dio.request(err.requestOptions.path,
              options: Options(
                  method: err.requestOptions.method,
                  headers: err.requestOptions.headers),
              data: err.requestOptions.data,
              queryParameters: err.requestOptions.queryParameters);
          return handler.resolve(retry);
        } on DioException catch (e) {
          return handler.next(e);
        }
      }
    }

    handler.next(err);
  }

  Future<bool> refreshToken() async {
    final rt = _storageUtils.getString(LocalName.refreshToken);

    if (rt == null) return false;

    try {
      final response =
          await _dio.post(ApiUrl.refresh, data: {'refreshToken': rt});
      if (response.statusCode == 201) {
        final data = response.data;

        final newAccess = data['newAccess'];
        final newRefresh = data['newRefresh'];

        await _storageUtils.putString(LocalName.authToken, newAccess);
        await _storageUtils.putString(LocalName.refreshToken, newRefresh);
        return true;
      }
    } on DioException catch (err) {
      debugPrint('Error on refreshToken ${err.error}');
    }
    return false;
  }
}
