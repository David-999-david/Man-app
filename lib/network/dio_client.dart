import 'package:dio/dio.dart';
import 'package:user_auth/network/auth_interceptor.dart';
import 'package:user_auth/network/logger_interceptor.dart';

class DioClient {

  final Dio _dio = Dio(BaseOptions(
    headers: {'Content-Type': 'application/json'},
    receiveTimeout: Duration(seconds: 10),
    connectTimeout: Duration(seconds: 15),
    sendTimeout: Duration(seconds: 15),
    responseType: ResponseType.json,
  ));

  DioClient() {
    _dio.interceptors.add(LoggerInterceptor());

    AuthInterceptor.create().then((AuthInterceptor) {
      _dio.interceptors.add(AuthInterceptor);
    });
  }

  Dio get dio => _dio;
}
