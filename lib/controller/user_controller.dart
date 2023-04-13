import 'package:chat_app_mvc/model/user_model.dart';
import 'package:flutter/foundation.dart';

class UserController with ChangeNotifier {
  UserController() {
    addUser('John', 'john@123', 'john1234');
    addUser('Dave', 'dave@123', 'dave1234');
    addUser('Mike', 'mike@123', 'mike1234');
  }
  List<User> userList = [];
  List<User> get allUsers => userList;
  User? currentUser;
  void setCurrentUser(User? user) {
    currentUser = user!;
  }

  void clearCurrentUser() {
    currentUser = null;
  }

  User addUser(String name, email, String password) {
    User newUser = User(
        name: name.trim(),
        email: email.trim(),
        password: password.trim(),
        id: userList.length);
    userList.add(newUser);
    notifyListeners();
    return newUser;
  }

  void registerUser(String name, String email, String password) {
    if (validateUserRegistration(name, email, password)) {
      debugPrint('${addUser(name, email, password)}');
    } else {
      debugPrint('User already exists');
    }
  }

  bool validateUserRegistration(String name, String email, String password) {
    for (var user in userList) {
      if (user.email == email.trim() || user.password == password) {
        return false;
      }
    }
    return true;
  }

  User? validateUserLogin(String email, String password) {
    for (var user in userList) {
      if (user.email == email.trim() && user.password == password) {
        return user;
      }
    }
    return null;
  }

  void logoutUser() {
    clearCurrentUser();
  }

  bool loginUser(String email, String password) {
    User? user = validateUserLogin(email, password);
    if (user != null) {
      setCurrentUser(user);
      return true;
    } else {
      debugPrint('Invalid credentials');
      return false;
    }
  }

  List<User> getParticipants(User? user) {
    if (user == null) {
      return userList;
    } else {
      List<User> participants =
          userList.where((element) => element.id != user.id).toList();
      return participants;
    }
  }

  int getSize() {
    return userList.length;
  }
}
