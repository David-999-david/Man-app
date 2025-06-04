import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class LoggerInterceptor extends Interceptor{
  Logger logger = Logger(
      printer: PrettyPrinter(methodCount: 0, printEmojis: true, colors: true));

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra['startTime'] = DateTime.now();

    final fullPath = '${options.baseUrl}${options.path}';
    logger.i('Method => ${options.method} $fullPath');

    if (options.headers.isNotEmpty) {
      options.headers.forEach((k, v) => logger.i('Headers => $k $v'));
    }
    if (options.queryParameters.isNotEmpty) {
      logger.i('Query   => ${options.queryParameters}');
    }
    if (options.data != null) {
      logger.i('Data Body  => ${options.data}');
    }

    logger.i('End => ${options.method}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final startTime = response.requestOptions.extra['startTime'] as DateTime?;
    final fullPath =
        '${response.requestOptions.baseUrl}${response.requestOptions.path}';

    if (startTime != null) {
      final ms = DateTime.now().difference(startTime).inMilliseconds;
      logger.i('${ms} ms , ${response.statusCode} $fullPath');
    } else {
      logger.i('${response.statusCode} $fullPath');
    }

    if (response.headers.isEmpty) {
      logger.i('Header missing : ${response.statusCode}');
    } else {
      response.headers.forEach((k, v) => logger.i('Headers : $k : $v'));
    }

    logger.i('Response body : ${response.data}');

    logger.i('END');

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
      logger.i('$ms : ms, ${options.method} $fullPath, $statusCode');
    } else {
      logger.i('${options.method} $fullPath , $statusCode');
    }

    if (options.data != null) {
      logger.i('Request Body : ${options.data}');
    }

    if (err.response?.data != null) {
      logger.i('Response Body : ${err.response?.data}');
    }

    logger.d('Error message : ${err.message}');

    handler.next(err);
  }
}
