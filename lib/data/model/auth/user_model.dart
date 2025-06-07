class UserModel {
  final String name;
  final String email;
  final DateTime createdAt;

  UserModel({required this.name, required this.email, required this.createdAt});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        name: json['name']?.toString() ?? '',
        email: json['email']?.toString() ?? '',
        createdAt: DateTime.tryParse(json['created_at'] as String ?? '') ??
            DateTime.now());
  }
}
