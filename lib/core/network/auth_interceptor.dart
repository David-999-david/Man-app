import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:user_auth/common/constant/api_url.dart';
import 'package:user_auth/common/constant/local_name.dart';
import 'package:user_auth/common/helper/app_navigator.dart';
import 'package:user_auth/presentation/user/auth/login/login_screen.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storageUtils;

  final Dio _refreshDio;

  static const _publicPaths = <String>[
    '/signin',
    '/signup',
    '/token/refresh',
    '/auth/check-email',
    '/request-otp',
    '/verify-otp',
    '/resend-otp',
    '/reset-password'
  ];

  AuthInterceptor._(this._storageUtils, this._refreshDio);

  static Future<AuthInterceptor> create() async {
    final storage = await FlutterSecureStorage();
    final refreshDio = Dio(BaseOptions(
        baseUrl: ApiUrl.baseUrl,
        headers: {'Content-Type': 'application/json'}));
    return AuthInterceptor._(storage!, refreshDio);
  }

  bool _isJwtExpired(String? token) {
    if (token == null || token.isEmpty) return true;
    try {
      return JwtDecoder.isExpired(token);
    } catch (_) {
      return true;
    }
  }

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (_publicPaths.any((p) => options.path.endsWith((p)))) {
      return handler.next(options);
    }

    // String? refreshTok = await _storageUtils.getString(LocalName.refreshToken);
    // debugPrint('This is refresh from local => $refreshTok');
    // if (refreshTok == null || refreshTok.isEmpty || _isJwtExpired(refreshTok)) {
    //   debugPrint('Refresh token invalid or expired');
    //   await _handleSessionExpired(options, reqHandler: handler);
    //   return;
    // }

    String? access = await _storageUtils.read(key: LocalName.access);
    debugPrint('This is access from local => $access');
    if (access == null || access.isEmpty || _isJwtExpired(access)) {
      debugPrint('Access token is invalid or expired');
      final refresh = await _refresh();
      if (!refresh) {
        await _handleSessionExpired(options, reqHandler: handler);
        return;
      }
      access = await _storageUtils.read(key: LocalName.access);
      debugPrint('New access token after refresh : $access');
    }

    if (access != null && access.isNotEmpty) {
      final header = options.headers['Authorization'] = 'Bearer $access';
      debugPrint('This is header => $header');
    } else {
      debugPrint('No valid access token available');
    }
    debugPrint('Final request headers: ${options.headers}');
    handler.next(options);
  }

  Future<void> _handleSessionExpired(RequestOptions options,
      {RequestInterceptorHandler? reqHandler,
      ErrorInterceptorHandler? errHandler}) async {
    await _storageUtils!.delete(key: LocalName.access);
    await _storageUtils!.delete(key: LocalName.refreshToken);
    AppNavigator.pushAndRemoveUntil(LoginScreen());
    final dioException = DioException(
        requestOptions: options,
        response: Response(requestOptions: options, statusCode: 401),
        error: 'SESSION_EXPIRED',
        type: DioExceptionType.cancel);

    if (reqHandler != null) {
      reqHandler.reject(dioException);
    } else if (errHandler != null) {
      errHandler.reject(dioException);
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_publicPaths.any((p) => err.requestOptions.path.endsWith(p))) {
      return handler.next(err);
    }
    if (err.response?.statusCode == 401 && err.error != 'SESSION_EXPIRED') {
      final refresh = await _refresh();
      if (refresh) {
        final access = await _storageUtils.read(key: LocalName.access);
        if (access != null && access.isNotEmpty) {
          err.requestOptions.headers['Authorization'] = 'Bearer $access';
          debugPrint('Retrying with New Authorization header: Bearer $access');
          try {
            // final retry = await _refreshDio.request(err.requestOptions.path,
            //     options: Options(
            //         method: err.requestOptions.method,
            //         headers: err.requestOptions.headers),
            //     data: err.requestOptions.data,
            //     queryParameters: err.requestOptions.queryParameters);
            final retry = await _refreshDio.fetch(err.requestOptions);
            debugPrint('Retry successful: ${retry.statusCode}');
            return handler.resolve(retry);
          } on DioException catch (e) {
            debugPrint(
                'Retry failed: ${e.response?.statusCode}, ${e.response?.data}');
            return handler.next(e);
          }
        }
      } else {
        await _handleSessionExpired(err.requestOptions, errHandler: handler);
        return;
      }
    }
    debugPrint('Passing error to next handler');
    handler.next(err);
  }

  Future<bool> _refresh() async {
    final token = await _storageUtils.read(key: LocalName.refreshToken);
    debugPrint('Start refresh new with $token');
    if (token == null || token.isEmpty) return false;

    try {
      final response = await _refreshDio.post(ApiUrl.refresh,
          data: {'refreshToken': token},
          options: Options(headers: {'Content-Type': 'application/json'}));
      debugPrint('Response code => ${response.statusCode}');
      if (response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>;

        final newAccess = data['newAccess']?.toString();
        final newRefresh = data['newRefresh']?.toString();

        if (newAccess == null || newRefresh == null) {
          debugPrint('Invalid refresh response: $data');
          throw Exception('Invalid token response');
        }

        await _storageUtils.write(key: LocalName.access, value: newAccess);

        await _storageUtils.write(
            key: LocalName.refreshToken, value: newRefresh);
        debugPrint('Refresh successful!');

        return true;
      }
      return false;
    } on DioException catch (e) {
      debugPrint('Error when refresh $e');
      return false;
    }
  }
}
