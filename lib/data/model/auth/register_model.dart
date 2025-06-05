class RegisterModel {
  final String name;
  final String email;
  final String password;

  RegisterModel({
    required this.name,
    required this.email,
    required this.password
  });

  toJson(){
    return {
      'name' : name,
      'email' : email,
      'password' : password
    };
  }
}