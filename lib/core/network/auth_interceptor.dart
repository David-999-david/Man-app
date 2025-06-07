import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:user_auth/common/constant/api_url.dart';
import 'package:user_auth/common/constant/local_name.dart';
import 'package:user_auth/core/network/dio_client.dart';
import 'package:user_auth/core/network/storage_utils.dart';

class AuthInterceptor extends Interceptor {
  final StorageUtils _storageUtils;

  AuthInterceptor._(this._storageUtils);

  final Dio _dio = DioClient().dio;

  static Future<AuthInterceptor> create() async {
    final storage = await StorageUtils.getInstance();
    return AuthInterceptor._(storage!);
  }

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    String? access = await _storageUtils.getString(LocalName.access);
    bool expired = access == null || JwtDecoder.isExpired(access);

    if (expired) {
      final refresh = await _refresh();
      if (!refresh) {
        return handler.reject(
          DioException(
              requestOptions: options,
              response: Response(requestOptions: options, statusCode: 401),
              error: 'SESSION_EXPIRED',
              type: DioExceptionType.cancel),
        );
      }
      access = _storageUtils.getString(LocalName.access);
    }

    if (access != null && access.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $access';
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && err.error != 'SESSION_EXPIRED') {
      final refresh = await _refresh();
      if (refresh) {
        final access = await _storageUtils.getString(LocalName.access);
        if (access != null && access.isNotEmpty) {
          err.requestOptions.headers['Authorization'] = 'Bearer $access';
          try {
            // final retry = await _dio.request(err.requestOptions.path,
            //     options: Options(
            //         method: err.requestOptions.method,
            //         headers: err.requestOptions.headers),
            //     data: err.requestOptions.data,
            //     queryParameters: err.requestOptions.queryParameters);
            final retry = await _dio.fetch(err.requestOptions);
            return handler.resolve(retry);
          } on DioException catch (e) {
            return handler.next(e);
          }
        }
      }
    }
    handler.next(err);
  }

  Future<bool> _refresh() async {
    final token = _storageUtils.getString(LocalName.refreshToken);

    if (token == null) return false;

    try {
      final response =
          await _dio.post(ApiUrl.refresh, data: {'refreshToken': token});

      if (response.statusCode != null && response.statusCode == 201) {
        final data = response.data;

        final newAccess = data['newAccess'];
        final newRefresh = data['newRefresh'];

        await _storageUtils.putString(LocalName.access, newAccess);

        await _storageUtils.putString(LocalName.refreshToken, newRefresh);

        return true;
      }
    } on DioException catch (e) {
      debugPrint('Error when refresh $e');
    }
    return false;
  }
}
