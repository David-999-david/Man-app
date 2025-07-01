import 'package:dio/dio.dart';
import 'package:user_auth/data/model/todo/todo_model.dart';
import 'package:user_auth/data/remote/todo/todo_remote.dart';

class TodoRepository {
  Future<TodoModel> addTodo(FormData form) {
    return TodoRemote().addTodo(form);
  }

  Future<PaginationTodo> getAllTodo(String? query, int page, int limit) {
    return TodoRemote().getAllTodo(query, page, limit);
  }

  Future<TodoModel> getTodoById(int id) {
    return TodoRemote().getTodoById(id);
  }

  Future<TodoModel> editTodo(int id, EdiitTodo todo) {
    return TodoRemote().editTodo(id, todo);
  }

  Future<String> removeById(int id) {
    return TodoRemote().removeById(id);
  }

  Future<String> removeAll() {
    return TodoRemote().removeAll();
  }

  Future<int> removeMany(List<int> ids) {
    return TodoRemote().removeMany(ids);
  }

  Future<TodoModel> updateTodoStatus(int id, bool todoStatus) {
    return TodoRemote().updateTodoStatus(id, todoStatus);
  }
}
