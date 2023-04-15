// import 'package:chat_app_mvc/controller/user_controller.dart';

class MyAppUser {
  final String name;
  final String email;
  final String password;
  final String id;

  MyAppUser(
      {required this.name,
      required this.email,
      required this.password,
      required this.id});
  @override
  String toString() {
    return 'User{name: $name, email: $email, password: $password, id: $id}';
  }

  static MyAppUser fromMap(Map<String, dynamic> map, String id) {
    return MyAppUser(
      id: id,
      name: map['name'],
      email: map['email'],
      password: map['password'],
    );
  }

  static Map<String, dynamic> toMap(MyAppUser user) {
    return {
      'name': user.name,
      'email': user.email,
      'password': user.password,
    };
  }
}
