import 'package:dio/dio.dart';
import 'package:user_auth/common/constant/api_url.dart';
import 'package:user_auth/core/network/auth_interceptor.dart';
import 'package:user_auth/core/network/logger_interceptor.dart';

class DioClient {
  static late final Dio _dio;

  static Future<void> init() async {
    final dio = Dio(BaseOptions(
      baseUrl: ApiUrl.baseUrl,
      headers: {'Content-Type': 'application/json'},
      receiveTimeout: Duration(seconds: 10),
      connectTimeout: Duration(seconds: 15),
      sendTimeout: Duration(seconds: 15),
      responseType: ResponseType.json,
    ));
    final auth = await AuthInterceptor.create();
    dio.interceptors.add(auth);

    dio.interceptors.add(LoggerInterceptor());

    _dio = dio;
  }

  static Dio get dio {
    if (_dio == null) {
      throw StateError(
          'DioClient.init() must be called before using dioclient.dio.');
    }
    return _dio;
  }

  Future<Response<dynamic>> onRequest(
      {required String path,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken}) {
    return _dio.get(path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken);
  }

  Future<Response<dynamic>> onPost(
      {required String path,
      Map<String, dynamic>? queryParameters,
      dynamic data,
      Options? options,
      CancelToken? cancelToken}) {
    return _dio.post(path,
        queryParameters: queryParameters,
        data: data,
        options: options,
        cancelToken: cancelToken);
  }

  Future<Response<dynamic>> onPut(
      {required String path,
      Map<String, dynamic>? queryParameters,
      dynamic data,
      Options? options,
      CancelToken? cancelToken}) {
    return _dio.put(path,
        queryParameters: queryParameters,
        data: data,
        options: options,
        cancelToken: cancelToken);
  }

  Future<Response<dynamic>> onDelete(
      {required String path,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken}) {
    return _dio.delete(path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken);
  }
}
