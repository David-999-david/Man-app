import 'package:dio/dio.dart';
import 'package:user_auth/common/constant/api_url.dart';
import 'package:user_auth/core/network/dio_client.dart';
import 'package:user_auth/data/model/todo/todo_model.dart';

class TodoRemote {
  final Dio _dio = DioClient.dio;

  Future<TodoModel> addTodo(AddTodo todo) async {
    try {
      final response = await _dio.post(ApiUrl.addTodo, data: todo.toJson());

      final status = response.statusCode;
      if (status! >= 200 && status < 300) {
        final data = response.data['data'] as Map<String, dynamic>;
        return TodoModel.fromJson(data);
      } else {
        throw Exception(
            'Error => status=$status ,  message => ${response.data['error']}');
      }
    } on DioException catch (e) {
      throw Exception(
          '${e.response?.statusCode} : ${e.response?.data['error']}');
    }
  }

  Future<PaginationTodo> getAllTodo(String? query, int page, int limit) async {
    try {
      final response = await _dio.get(ApiUrl.getAllTodo,
          queryParameters: {'q': query, 'page': page, 'limit': limit});
      final status = response.statusCode;

      if (status! >= 200 && status < 300) {
        final data = response.data as Map<String, dynamic>;

        return PaginationTodo.fromJson(data);
      } else {
        throw Exception(
            'Error => status=$status , message => ${response.data['error']}');
      }
    } on DioException catch (e) {
      throw Exception(
          '${e.response?.statusCode} : ${e.response?.data['error']}');
    }
  }
}
