class UserModel {
  final String name;
  final String email;
  final DateTime createdAt;
  final String? imageUrl;

  UserModel(
      {required this.name,
      required this.email,
      required this.createdAt,
      this.imageUrl});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        name: json['name']?.toString() ?? '',
        email: json['email']?.toString() ?? '',
        createdAt: DateTime.tryParse(json['created_at'] as String ?? '') ??
            DateTime.now(),
        imageUrl: json['profile_image_url'] ?? '');
  }
}
