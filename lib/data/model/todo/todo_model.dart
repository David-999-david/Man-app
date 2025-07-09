class TodoModel {
  final int id;
  final String title;
  final String description;
  final bool completed;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<TodoImage> imageUrl;

  TodoModel(
      {required this.id,
      required this.title,
      required this.description,
      required this.completed,
      required this.createdAt,
      required this.updatedAt,
      required this.imageUrl});

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
        id: json['id'] as int,
        title: json['title'] as String,
        description: json['description'] as String,
        completed: json['completed'] as bool,
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
        imageUrl: (json['images'] as List<dynamic>)
            .map((image) => TodoImage.fromJson(image))
            .toList());
  }
}

class PaginationTodo {
  final List<TodoModel> todos;
  final int limit;
  final int page;
  final int itemCounts;
  final int total;
  final int totalPages;

  PaginationTodo(
      {required this.todos,
      required this.limit,
      required this.page,
      required this.itemCounts,
      required this.total,
      required this.totalPages});

  factory PaginationTodo.fromJson(Map<String, dynamic> json) {
    final rawsList = json['data'] as List<dynamic>;
    final todo = rawsList.map((t) => TodoModel.fromJson(t)).toList();

    final meta = json['meta'] as Map<String, dynamic>;
    return PaginationTodo(
        todos: todo,
        limit: meta['limit'] as int,
        page: meta['page'] as int,
        itemCounts: meta['itemCounts'] as int,
        total: meta['totalCounts'] as int,
        totalPages: meta['totalPage'] as int);
  }
}

class TodoImage {
  final String? url;
  final String? imageDesc;

  TodoImage({required this.url, required this.imageDesc});

  factory TodoImage.fromJson(Map<String, dynamic> json) {
    return TodoImage(
        url: json['url'] as String, imageDesc: json['imageDesc'] as String);
  }
}

class TestTodo {
  final String title;
  final String description;
  final String? imageDesc;

  TestTodo({required this.title, required this.description, this.imageDesc});

  Map<String, dynamic> toJson() {
    return {'title': title, 'description': description, 'imageDesc': imageDesc};
  }
}

class ReturnTestTodo {
  final String title;
  final String description;
  final List<ReturnImageTodo> imagetodoList;

  ReturnTestTodo(
      {required this.title,
      required this.description,
      required this.imagetodoList});

  factory ReturnTestTodo.fromJson(Map<String, dynamic> json) {
    return ReturnTestTodo(
        title: json['title'] as String,
        description: json['description'] as String,
        imagetodoList: (json['images'] as List<dynamic>)
            .map((item) =>
                ReturnImageTodo.fromJson(item as Map<String, dynamic>))
            .toList());
  }
}

class ReturnImageTodo {
  final int id;
  final String imageDesc;

  ReturnImageTodo({required this.id, required this.imageDesc});

  factory ReturnImageTodo.fromJson(Map<String, dynamic> json) {
    return ReturnImageTodo(
        id: json['imageId'] as int, imageDesc: json['imageDesc'] as String);
  }
}
