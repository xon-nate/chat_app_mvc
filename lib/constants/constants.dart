class AppConstants {
  static const String appName = 'Chat App';
  static const String appVersion = '1.0.0';
  static const emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const passwordRegex = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$';
  static const nameRegex = r'^[a-zA-Z ]+$';
  static const kInvalidEmailOrPassword = 'Invalid email or password';
}

class AppRoutes {
  static const String home = '/';
  static const String register = '/register';
  static const String login = '/login';
  static const String participants = '/participants';
  // Add more routes as needed
}
