import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:user_auth/common/constant/api_url.dart';
import 'package:user_auth/common/constant/local_name.dart';
import 'package:user_auth/core/network/dio_client.dart';
import 'package:user_auth/core/network/storage_utils.dart';

class AuthInterceptor extends Interceptor {
  final StorageUtils _storageUtils;

  final Dio _refreshDio;

  static const _publicPaths = <String>[
    '/signin',
    '/signup',
    '/token/refresh',
    '/auth/check-email'
  ];

  AuthInterceptor._(this._storageUtils, this._refreshDio);

  static Future<AuthInterceptor> create() async {
    final storage = await StorageUtils.getInstance();
    final refreshDio = Dio(BaseOptions(baseUrl: ApiUrl.baseUrl));
    return AuthInterceptor._(storage!, refreshDio);
  }

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (_publicPaths.any((p) => options.path.endsWith((p)))) {
      return handler.next(options);
    }

    String? refreshTok = await _storageUtils.getString(LocalName.refreshToken);

    final bool refreshExpired =
        (refreshTok == null) ? true : JwtDecoder.isExpired(refreshTok);

    if (refreshExpired) {
      return handler.reject(
        DioException(
            requestOptions: options,
            response: Response(requestOptions: options, statusCode: 401),
            error: 'SESSION_EXPIRED',
            type: DioExceptionType.cancel),
      );
    }

    String? access = await _storageUtils.getString(LocalName.access);

    final bool accessExpired =
        (access == null) ? true : JwtDecoder.isExpired(access);

    if (accessExpired) {
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
      access = await _storageUtils.getString(LocalName.access);
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
            // final retry = await _refreshDio.request(err.requestOptions.path,
            //     options: Options(
            //         method: err.requestOptions.method,
            //         headers: err.requestOptions.headers),
            //     data: err.requestOptions.data,
            //     queryParameters: err.requestOptions.queryParameters);
            final retry = await _refreshDio.fetch(err.requestOptions);
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
    final token = await _storageUtils.getString(LocalName.refreshToken);

    if (token == null) return false;

    try {
      final response =
          await _refreshDio.post(ApiUrl.refresh, data: {'refreshToken': token});

      if (response.statusCode != null && response.statusCode == 201) {
        final data = response.data;

        final newAccess = data['newAccess'] as String?;
        final newRefresh = data['newRefresh'] as String?;

        if (newAccess == null || newRefresh == null)
          throw Exception('Invalid token response');

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
