import 'package:dio/dio.dart';
import 'package:user_auth/common/constant/api_url.dart';
import 'package:user_auth/core/network/auth_interceptor.dart';
import 'package:user_auth/core/network/logger_interceptor.dart';

class DioClient {

  static final DioClient _instance = DioClient._internal();

  factory DioClient() => _instance;

  DioClient._internal(){
    _dio.interceptors.add(LoggerInterceptor());
    AuthInterceptor.create().then(_dio.interceptors.add);
  }

  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiUrl.baseUrl,
    headers: {'Content-Type': 'application/json'},
    receiveTimeout: Duration(seconds: 10),
    connectTimeout: Duration(seconds: 15),
    sendTimeout: Duration(seconds: 15),
    responseType: ResponseType.json,
  ));

  

  // DioClient() {
  //   _dio.interceptors.add(LoggerInterceptor());

  //   AuthInterceptor.create().then((AuthInterceptor) {
  //     _dio.interceptors.add(AuthInterceptor);
  //   });
  // }

  Dio get dio => _dio;

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
