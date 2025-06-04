import 'package:dio/dio.dart';

class DioClient {
  Dio? _dio;

  DioClient() : _dio = Dio(
    BaseOptions(
      headers: {'Content-Type' : 'application/json'},
      receiveTimeout: Duration(seconds: 10),
      connectTimeout: Duration(seconds: 15),
      sendTimeout: Duration(seconds: 15),
      responseType: ResponseType.json,
    )
  )..interceptors.addAll([
    
  ]);
}