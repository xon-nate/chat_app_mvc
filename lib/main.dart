import 'package:chat_app_mvc/view/home_page.dart';
import 'package:chat_app_mvc/view/register_page.dart';
import 'package:chat_app_mvc/view/participants_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants/constants.dart';
import 'controller/chat_controller.dart';
import 'controller/user_controller.dart';
import 'firebase_options.dart';
import 'view/login_page.dart';

Future<void> main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Run the app
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserController(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final UserController userController = Provider.of<UserController>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        AppRoutes.home: (_) => HomePage(userController: userController),
        AppRoutes.register: (_) => RegisterPage(userController: userController),
        AppRoutes.login: (_) => LoginPage(userController: userController),
        AppRoutes.participants: (_) => ParticipantsPage(
              userController: userController,
            ),
        // AppRoutes.chat: (_) => ChatPage(userController: userController),
        // '/chat': (context) => const ChatPage(),
      },
    );
  }
}
