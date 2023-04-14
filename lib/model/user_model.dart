// import 'package:chat_app_mvc/controller/user_controller.dart';

class User {
  final String name;
  final String email;
  final String password;
  final int id;

  User(
      {required this.name,
      required this.email,
      required this.password,
      required this.id});
  @override
  String toString() {
    return 'User{name: $name, email: $email, password: $password, id: $id}';
  }
}
