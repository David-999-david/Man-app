import 'dart:async';

import 'package:flutter/material.dart';
import 'package:user_auth/data/model/todo/todo_model.dart';
import 'package:user_auth/domain/usecase/todo/todo_usecase.dart';

class HomeNotifier extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  String? _msg;
  String? get msg => _msg;

  List<TodoModel> _todoList = [];
  List<TodoModel> get todoList => _todoList;

  PaginationTodo? _paginationTodo;
  PaginationTodo? get paginationTodo => _paginationTodo;

  final TextEditingController _searchQuery = TextEditingController();
  TextEditingController get searchQuery => _searchQuery;

  int _currentPage = 1;
  int get currentPage => _currentPage;

  int _limit = 20;
  int get limit => _limit;

  int? _totalPage;
  int? get totalPage => _totalPage;

  int? _totalCounts;
  int? get totalCounts => _totalCounts;

  int? _itemCounts;
  int? get itemCounts => _itemCounts;

  bool _seeMore = false;
  bool get seeMore => _seeMore;

  Timer? _debonuce;

  void onSearch() {
    _currentPage = 1;
    _debonuce?.cancel();
    _seeMore = true;
    _debonuce = Timer(const Duration(milliseconds: 800), () {
      getAllTodo();
    });
  }

  @override
  void dispose() {
    _searchQuery.dispose();
    _debonuce?.cancel();
    super.dispose();
  }

  void loadMore() {
    _seeMore = true;
    _currentPage = 1;
    _limit = totalCounts ?? _limit;
    notifyListeners();
  }

  void nextPage() async {
    if (_currentPage < _totalPage!) {
      _currentPage++;
      notifyListeners();
    }
  }

  void prevPage() {
    if (_currentPage >= 1) {
      _currentPage--;
      notifyListeners();
    }
  }

  void refresh() {
    _seeMore = false;
    _limit = 20;
    _searchQuery.clear();
    notifyListeners();
  }

  void getAllTodo() async {
    _loading = true;
    notifyListeners();
    try {
      if (_currentPage >= 1) {
        final pageTodo = await TodoUsecase()
            .getAllTodo(_searchQuery.text, _currentPage, _limit);

        _paginationTodo = pageTodo;

        _todoList = pageTodo.todos;

        _itemCounts = pageTodo.itemCounts;

        _totalCounts = pageTodo.total;

        _totalPage = pageTodo.totalPages;
      }
    } catch (e) {
      _msg = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
