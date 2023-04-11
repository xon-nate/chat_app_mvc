import 'package:chat_app_mvc/view/home_page.dart';
import 'package:chat_app_mvc/view/participants_page.dart';
import 'package:flutter/material.dart';

import 'controller/user_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    UserController userController = UserController();
    return MaterialApp(
      routes: {
        '/': (context) => MyHomePage(
              userController: userController,
            ),
        '/participants': (context) => ParticipantsPage(
              participants: userController.allUsers,
            ),
        // '/chat': (context) => const ChatPage(),
      },
      title: 'Chat App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
