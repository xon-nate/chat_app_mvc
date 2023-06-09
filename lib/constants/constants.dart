import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'Chat App';
  static const String appVersion = '1.0.0';
  static const emailRegex = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[\w-]{2,4}$';
  static const passwordRegex = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$';
  static const nameRegex = r'^[a-zA-Z ]+$';
  static const kInvalidEmailOrPassword = 'Invalid email or password';
}

class AppRoutes {
  static const String home = '/';
  static const String register = '/register';
  static const String login = '/login';
  static const String participants = '/participants';
  static const String chat = '/chat';
  // Add more routes as needed
}

class HigherFabLocation extends FloatingActionButtonLocation {
  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    // Adjust the y-axis offset to position the FAB higher
    final double fabX = scaffoldGeometry.scaffoldSize.width - 80.0;
    final double fabY =
        650.0; // Change this value to push the FAB higher or lower
    return Offset(fabX, fabY);
  }
}
