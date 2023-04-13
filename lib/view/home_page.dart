import 'package:flutter/material.dart';

import '../controller/user_controller.dart';
import 'login_page.dart';
import 'register_page.dart';

class HomePage extends StatelessWidget {
  final UserController userController;
  const HomePage({super.key, required this.userController});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chat App'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'Login',
              ),
              Tab(
                text: 'Register',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            LoginPage(
              userController: userController,
            ),
            RegisterPage(
              userController: userController,
            ),
          ],
        ),
      ),
    );
  }
}
