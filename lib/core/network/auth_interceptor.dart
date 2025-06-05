import 'package:dio/dio.dart';
import 'package:user_auth/common/constant/local_name.dart';
import 'package:user_auth/common/helper/app_navigator.dart';
import 'package:user_auth/core/network/storage_utils.dart';
import 'package:user_auth/presentation/user/auth/login/login_screen.dart';

class AuthInterceptor extends Interceptor {
  final StorageUtils _storageUtils;

  AuthInterceptor._(this._storageUtils);

  static Future<AuthInterceptor> create() async {
    final storage = await StorageUtils.getInstance();
    return AuthInterceptor._(storage!);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _storageUtils.getString(LocalName.authToken);

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
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final statusCode = err.response?.statusCode;

    if (statusCode == 403) {
      _storageUtils.remove(LocalName.authToken);
      AppNavigator.pushAndRemoveUntil(LoginScreen());
    } else if (statusCode == 401) {
      _storageUtils.remove(LocalName.authToken);
      AppNavigator.pushAndRemoveUntil(LoginScreen());
    }

    handler.next(err);
  }
}
