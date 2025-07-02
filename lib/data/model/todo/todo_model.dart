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

// class AddTodo {
//   final String title;
//   final String description;
//   final FormData? file;
//   final String? imageDesc;

//   AddTodo(
//       {required this.title,
//       required this.description,
//       this.file,
//       this.imageDesc});

//   Map<String, dynamic> toJson() {
//     return {
//       'title': title,
//       'description': description,
//       'imageDescription': imageDesc,
//       ''
//     };
//   }
// }

class EdiitTodo {
  final String? title;
  final String? description;
  final bool? completed;

  EdiitTodo({this.title, this.description, this.completed});

  Map<String, dynamic> toJson() {
    return {'title': title, 'description': description, 'completed': completed};
  }
}
