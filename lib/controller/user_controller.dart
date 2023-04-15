import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../model/user_model.dart';

class UserController with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  MyAppUser? currentUser;
  List<MyAppUser> _userList = [];

  List<MyAppUser> get getUsers => _userList;
  MyAppUser? get getCurrentUser => currentUser;

  Future<List<MyAppUser>> getUserList() async {
    QuerySnapshot snapshot = await _firestore.collection('users').get();
    if (getCurrentUser != null) {
      _userList = snapshot.docs
          .map((doc) =>
              MyAppUser.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .where((element) => element.email != getCurrentUser!.email)
          .toList(growable: false);
    } else {
      _userList = snapshot.docs
          .map((doc) =>
              MyAppUser.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList(growable: false);
    }

    notifyListeners();
    return _userList;
  }

  Future<bool> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await _firestore.collection('users').add({
        'name': name,
        'email': email,
        'password': password,
      });
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    }
  }

  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      try {
        QuerySnapshot snapshot = await _firestore
            .collection('users')
            .where('email', isEqualTo: email)
            .get();
        currentUser = MyAppUser.fromMap(
            snapshot.docs.first.data() as Map<String, dynamic>,
            snapshot.docs.first.id);
      } catch (e) {
        throw e;
      }
      return true;
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    }
  }

  Future<void> logoutUser() async {
    await _auth.signOut();
  }
}
