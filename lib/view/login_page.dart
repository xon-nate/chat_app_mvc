import 'package:flutter/material.dart';

import '../controller/user_controller.dart';
// import '../navigator.dart';
import 'widgets/form_text_fields.dart';
import 'package:chat_app_mvc/constants/constants.dart';

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
              // TextFormField(
              //   keyboardType: TextInputType.emailAddress,
              //   decoration: const InputDecoration(
              //     border: OutlineInputBorder(),
              //     hintText: 'Enter your email',
              //     prefixIcon: Icon(Icons.email),
              //   ),
              //   onChanged: (value) => email = value,
              //   validator: (value) {
              //     if (RegExp(AppConstants.emailRegex).hasMatch(value!)) {
              //       return 'Please a valid email';
              //     }
              //     return null;
              //   },
              // ),

              const SizedBox(height: 16),
              PasswordTextFormField(
                onChanged: (String value) => password = value,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                child: const Text('Login'),
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    bool loginUser =
                        userController.loginUser(email!, password!);
                    if (loginUser) {
                      Navigator.pushNamed(context, '/participants');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Invalid email or password'),
                        ),
                      );
                    }
                  }
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
}
