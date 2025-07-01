import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:user_auth/data/model/todo/todo_model.dart';
import 'package:user_auth/domain/usecase/todo/todo_usecase.dart';

class HomeNotifier extends ChangeNotifier {
  HomeNotifier({this.editTodo});

  TodoModel? editTodo;

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

  String? _imageUrl = '';
  String? get imageUrl => _imageUrl;

  Future<bool> requestGalleryAndCameraPer(ImageSource source) async {
    if (source == ImageSource.camera) {
      final status = await Permission.camera.status;

      if (status.isGranted) return true;

      final result = await Permission.camera.request();

      if (result.isGranted) return true;

      if (result.isPermanentlyDenied) {
        await openAppSettings();
      }
      return false;
    } else {
      if (Platform.isAndroid) {
        final status = await Permission.storage.status;

        if (status.isGranted) return true;

        final result = await Permission.storage.request();

        if (result.isGranted) return true;

        if (result.isPermanentlyDenied) {
          await openAppSettings();
        }
        return false;
      } else {
        final status = await Permission.storage.status;

        if (status.isGranted) return true;

        final result = await Permission.storage.request();

        if (result.isGranted) return true;

        if (result.isPermanentlyDenied) {
          await openAppSettings();
        }
        return false;
      }
    }
  }

  final key = GlobalKey<FormState>();

  TodoModel? _newTodo;
  TodoModel? get newTodo => _newTodo;

  final TextEditingController titleCtrl = TextEditingController();
  final TextEditingController descCtrl = TextEditingController();
  final TextEditingController imageDescCtrl = TextEditingController();

  XFile? _picked;

  Future<void> onPick(ImageSource source) async {
    if (await requestGalleryAndCameraPer(source)) {
      final picked = await ImagePicker().pickImage(source: source);
      if (picked == null) return;
      _picked = picked;
      _imageUrl = picked.path;
      notifyListeners();
    }
  }

  Future<bool> addNew(ImageSource source) async {
    _msg = null;
    _loading = true;
    notifyListeners();
    try {
      final mimeType = await lookupMimeType(_picked!.path) ?? 'image/jpeg';

      final part = mimeType.split('/');

      final file = FormData.fromMap({
        'title': titleCtrl.text,
        'description': descCtrl.text,
        'imageDescription': imageDescCtrl.text,
        'file': await MultipartFile.fromFile(_picked!.path,
            filename: _picked!.name, contentType: MediaType(part[0], part[1]))
      });

      final response = await TodoUsecase().addTodo(file);

      _newTodo = response;

      _todoList.insert(0, _newTodo!);

      titleCtrl.clear();
      descCtrl.clear();
      imageDescCtrl.clear();
      return true;
    } catch (e) {
      _msg = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  List<int> _selectedId = [];
  List<int> get selectedId => _selectedId;

  final List<TodoModel> _selectedTodo = [];
  List<TodoModel> get selectedTodo => _selectedTodo;

  int? _deletedCounts;
  int? get deletedCounts => _deletedCounts;

  void onSelect(TodoModel todo) {
    if (_selectedTodo.contains(todo)) {
      _selectedTodo.remove(todo);
    } else {
      _selectedTodo.add(todo);
    }
    _selectedId = _selectedTodo.map((todo) => todo.id).toList();
    notifyListeners();
  }

  Future<bool> removeMany() async {
    _loading = true;
    notifyListeners();
    try {
      final counts = await TodoUsecase().removeMany(selectedId);
      _deletedCounts = counts;
      _todoList.removeWhere((todo) => selectedId.contains(todo.id));
      _selectedId.clear();
      _selectedTodo.clear();
      return true;
    } catch (e) {
      _msg = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void cancel() {
    _selectedTodo.clear();
    _selectedId.clear();
    notifyListeners();
  }

  bool? _completed;
  bool? get completed => _completed;

  void getOld() {
    if (editTodo != null) {
      titleCtrl.text = editTodo!.title;
      descCtrl.text = editTodo!.description;
      _completed = editTodo!.completed;
    }
  }

  void getBool(bool value) {
    _completed = value;
    notifyListeners();
  }

  Future<bool> onEditTodo() async {
    _msg = null;
    _loading = true;
    notifyListeners();
    try {
      final editedTodo = await TodoUsecase().editTodo(
          editTodo!.id,
          EdiitTodo(
              title: titleCtrl.text,
              description: descCtrl.text,
              completed: _completed));
      final editTodoIndex =
          _todoList.indexWhere((todo) => todo.id == editedTodo.id);
      if (editTodoIndex != -1) {
        _todoList[editTodoIndex] = editedTodo;
      }
      titleCtrl.clear();
      descCtrl.clear();

      return true;
    } catch (e) {
      _msg = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> removeOne(TodoModel removeTodo) async {
    _msg = null;
    _loading = true;
    notifyListeners();
    try {
      await TodoUsecase().removeById(removeTodo.id);
      _todoList.removeWhere((todo) => todo.id == removeTodo.id);
      return true;
    } catch (e) {
      _msg = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // bool _status = false;
  // bool get status => _status;

  // void onEditStatus(bool value) {
  //   _status = value;
  //   notifyListeners();
  // }

  TodoModel? _ediedtTodo;
  TodoModel? get editedTodo => _ediedtTodo;

  Future<void> editStatus(TodoModel todo, bool status) async {
    _msg = null;
    _loading = true;
    notifyListeners();
    try {
      final edited = await TodoUsecase().updateTodoStatus(todo.id, status);
      final index = _todoList.indexWhere((td) => td.id == edited.id);
      if (index != -1) {
        _todoList[index] = edited;
      }
    } catch (e) {
      _msg = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
