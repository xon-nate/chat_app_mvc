import 'package:chat_app_mvc/model/user_model.dart';

class UserController {
  late User user;
  List<User> userList = [];
  List<User> get allUsers => userList;

  void addUser(String name, email, String password) {
    User newUser =
        User(name: name, email: email, password: password, id: userList.length);
    userList.add(newUser);
  }

  bool validateUserRegistration(String name, String email, String password) {
    for (var user in userList) {
      if (user.email == email) {
        return false;
      }
    }
    return true;
  }

  bool validateUserLogin(String email, String password) {
    for (var user in userList) {
      if (user.email == email && user.password == password) {
        return true;
      }
    }
    return false;
  }

  void registerUser(String name, String email, String password) {
    if (validateUserRegistration(name, email, password)) {
      addUser(name, email, password);
    } else {
      print('User already exists');
    }
  }

  int getSize() {
    return userList.length;
  }
}
