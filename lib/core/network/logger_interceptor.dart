import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class LoggerInterceptor extends Interceptor{
  Logger logger = Logger(
      printer: PrettyPrinter(methodCount: 0, printEmojis: true, colors: true));

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra['startTime'] = DateTime.now();

    final fullPath = '${options.baseUrl}${options.path}';
    logger.i('Request Method => ${options.method} $fullPath');

    if (options.headers.isNotEmpty) {
      options.headers.forEach((k, v) => logger.i('Request Headers => $k $v'));
    }
    if (options.queryParameters.isNotEmpty) {
      logger.i('Request Query   => ${options.queryParameters}');
    }
    if (options.data != null) {
      logger.i('Request Data Body  => ${options.data}');
    }

    logger.i('Request End => ${options.method}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final startTime = response.requestOptions.extra['startTime'] as DateTime?;
    final fullPath =
        '${response.requestOptions.baseUrl}${response.requestOptions.path}';

    if (startTime != null) {
      final ms = DateTime.now().difference(startTime).inMilliseconds;
      logger.i('$ms Response ms , ${response.statusCode} $fullPath');
    } else {
      logger.i('Response => ${response.statusCode} $fullPath');
    }

    if (response.headers.isEmpty) {
      logger.i('Response Header missing : ${response.statusCode}');
    } else {
      response.headers.forEach((k, v) => logger.i('Response Headers : $k : $v'));
    }

    logger.i('Response body : ${response.data}');

    logger.i('Response END');

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final options = err.requestOptions;
    final fullPath = '${options.baseUrl}${options.path}';
    final statusCode = err.response?.statusCode;
    final startTime = options.extra['startTime'] as DateTime?;

    if (startTime != null) {
      final ms = DateTime.now().difference(startTime).inMilliseconds;
      logger.i('$ms : Error request ms, ${options.method} $fullPath, $statusCode');
    } else {
      logger.i('Error => ${options.method} $fullPath , $statusCode');
    }

    if (options.data != null) {
      logger.i('Error Request Body : ${options.data}');
    }

    if (err.response?.data != null) {
      logger.i('Error Response Body : ${err.response?.data}');
    }

    logger.d('Error message : ${err.message}');

    handler.next(err);
  }
}
