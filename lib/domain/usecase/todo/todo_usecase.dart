import 'package:dio/dio.dart';
import 'package:user_auth/data/model/todo/todo_model.dart';
import 'package:user_auth/domain/repository/todo/todo_repository.dart';

class TodoUsecase {
  Future<TodoModel> addTodo(FormData form) async {
    return await TodoRepository().addTodo(form);
  }

  Future<PaginationTodo> getAllTodo(String? query, int page, int limit) async {
    return await TodoRepository().getAllTodo(query, page, limit);
  }

  Future<TodoModel> getTodoById(int id) async {
    return await TodoRepository().getTodoById(id);
  }

  Future<TodoModel> editTodo(int id, FormData todo) async {
    return await TodoRepository().editTodo(id, todo);
  }

  Future<String> removeById(int id) async {
    return await TodoRepository().removeById(id);
  }

  Future<String> removeAll() async {
    return await TodoRepository().removeAll();
  }

  Future<int> removeMany(List<int> ids) async {
    return await TodoRepository().removeMany(ids);
  }

  Future<TodoModel> updateTodoStatus(int id, bool todoStatus) async {
    return await TodoRepository().updateTodoStatus(id, todoStatus);
  }

  Future<List<ReturnTestTodo>> createManyTodo(List<TestTodo> todos) async {
    return await TodoRepository().createManyTodo(todos);
  }
}
