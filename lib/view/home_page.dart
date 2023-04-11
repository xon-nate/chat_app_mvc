import 'package:flutter/material.dart';

import '../controller/user_controller.dart';
import 'widgets/password_text_field.dart';

class MyHomePage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final UserController userController;
  MyHomePage({super.key, required this.userController});
  void addUser(String name, email, password) {
    userController.registerUser(name, email, password);
  }

  String name = '', email = '', password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your name',
                  prefixIcon: Icon(Icons.person),
                ),
                onChanged: (value) => name = value,
                validator: (value) {
                  //Regular expression for name with only letters and spaces
                  final RegExp nameRegExp = RegExp(r'^[a-zA-Z ]+$');
                  if (value == null ||
                      value.isEmpty ||
                      !nameRegExp.hasMatch(value)) {
                    return 'Please a valid name';
                  } else if (value.length < 3) {
                    return 'Name must be at least 3 characters';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your email',
                  prefixIcon: Icon(Icons.email),
                ),
                onChanged: (value) => email = value,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Please a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              PasswordTextFormField(
                onChanged: (String value) {
                  password = value;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  debugPrint(userController.allUsers.toString());
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Valid Data')),
                    );
                    Navigator.pushNamed(context, '/participants');
                    addUser(name, email, password);
                  }
                },
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
