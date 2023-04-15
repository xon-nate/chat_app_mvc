import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../controller/user_controller.dart';
import 'widgets/form_text_fields.dart';
import 'package:chat_app_mvc/constants/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final UserController userController;
  LoginPage({super.key, required this.userController});

  @override
  Widget build(BuildContext context) {
    String? email, password;
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Register'),
      //   centerTitle: true,
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              EmailTextFormField(
                onChanged: (String value) => email = value,
                // formKey: _formKey,
              ),
              const SizedBox(height: 16),
              PasswordTextFormField(
                onChanged: (String value) => password = value,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                child: const Text('Login'),
                onPressed: () {
                  if (_formKey.currentState!.validate())
                    signIn(email!, password!);
                  // Validate returns true if the form is valid, or false otherwise.
                  // if (_formKey.currentState!.validate()) {
                  //   bool loginUser =
                  //       userController.loginUser(email!, password!);
                  //   if (loginUser) {
                  //     Navigator.pushNamed(context, '/participants');
                  //   } else {
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //       const SnackBar(
                  //         content: Text('Invalid email or password'),
                  //       ),
                  //     );
                  //   }
                  // }
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('View User List'),
        onPressed: () {
          Navigator.pushNamed(context, '/participants');
        },
        // child: const Icon(Icons.list),
      ),
    );
  }

  Future signIn(String email, password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password!)
        .then((value) => print("Signed in"));
  }
}
