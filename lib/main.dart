import 'package:chat_app_mvc/view/home_page.dart';
import 'package:chat_app_mvc/view/register_page.dart';
import 'package:chat_app_mvc/view/participants_page.dart';
import 'package:flutter/material.dart';
import 'controller/user_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'view/login_page.dart';

Future<void> main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Run the app
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
        '/': (context) => HomePage(),
        '/register': (context) => RegisterPage(
              userController: userController,
            ),
        '/login': (context) => LoginPage(
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
