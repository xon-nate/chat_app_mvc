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
  String get getCurrentUserName => currentUser!.name;
  String get getUserId => currentUser!.id;
  set setCurrentUser(MyAppUser user) {
    currentUser = user;
    notifyListeners();
  }

  UserController() {
    _auth.authStateChanges().listen(
      (User? user) async {
        if (user != null) {
          String userId =
              (await _firestore.collection('users').doc(user.uid).get()).id;
          String name =
              (await _firestore.collection('users').doc(user.uid).get())
                  .data()!['name'];
          String email =
              (await _firestore.collection('users').doc(user.uid).get())
                  .data()!['email'];
          String password =
              (await _firestore.collection('users').doc(user.uid).get())
                  .data()!['password'];
          currentUser = MyAppUser(
              id: userId, name: name, email: email, password: password);
          setCurrentUser = currentUser!;
          notifyListeners();
        }
      },
    );
  }

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
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String uid = userCredential.user!.uid;
      await _firestore.collection('users').doc(uid).set({
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
          snapshot.docs.first.id,
        );
      } catch (e) {
        rethrow;
      }
      return true;
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    currentUser = null;
    notifyListeners();
  }
}
