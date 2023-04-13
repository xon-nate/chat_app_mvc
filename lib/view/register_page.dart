import 'package:flutter/material.dart';

import '../controller/user_controller.dart';
import 'widgets/form_text_fields.dart';

class RegisterPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final UserController userController;
  RegisterPage({super.key, required this.userController});
  void addUser(String name, email, password) {
    userController.registerUser(name, email, password);
  }

  @override
  Widget build(BuildContext context) {
    String name = '', email = '', password = '';
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UserNameTextFormField(
                onChanged: (String value) => name = value,
              ),
              const SizedBox(height: 16),
              EmailTextFormField(
                onChanged: (String value) => email = value,
              ),
              const SizedBox(height: 16),
              PasswordTextFormField(
                onChanged: (String value) => password = value,
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
                    addUser(name, email, password);
                    Navigator.pushNamed(context, '/participants');
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
