# Flutter Chat App

![App Demo](demo.gif)

## Table of Contents
- [Description](#description)
- [Features](#features)
- [Installation and Setup](#installation-and-setup)
- [Configuration](#configuration)
- [Folder Structure](#folder-structure)
- [Encryption](#encryption)
- [Dependencies](#dependencies)
- [License](#license)
- [Contributing](#contributing)
- [Contact](#contact)

## Description
The Flutter Chat App is a mobile application built using the Flutter framework, Firebase Cloud Firestore, and Firebase Authentication. It provides a secure and real-time chat functionality for users to communicate with each other. The app employs encryption techniques to ensure the confidentiality of messages exchanged between users.

## Features
- User Registration: Users can create new accounts by providing their name, email, and password.
- User Login: Registered users can log in to the app using their email and password.
- Real-time Chat: Users can send and receive messages in real-time with other users.
- Encryption: Messages exchanged between users are encrypted using the AES (Advanced Encryption Standard) algorithm for enhanced security.
- User List: Users can view a list of other users and select them to initiate conversations.
- Logout: Users can securely log out of their accounts.

## Installation and Setup
1. Clone the repository: `git clone https://github.com/your-username/flutter-chat-app.git`
2. Navigate to the project directory: `cd flutter-chat-app`
3. Install the dependencies: `flutter pub get`
4. Set up Firebase project:
   - Create a new Firebase project (if not already created) from the [Firebase Console](https://console.firebase.google.com/).
   - Enable Firebase Authentication and Firebase Cloud Firestore for the project.
   - Download the Firebase configuration file (google-services.json) and place it in the `android/app` directory.
5. Run the app: `flutter run`

## Configuration
Before running the app, make sure to update the Firebase configuration in the `firebase_options.dart` file. Replace the `apiKey`, `appId`, `projectId`, `databaseURL`, `messagingSenderId`, and `storageBucket` values with your Firebase project's configuration.

## Folder Structure
- `constants`: Contains constant values used in the app.
- `controller`: Includes the chat and user controllers for managing app logic.
- `firebase_options.dart`: Configures Firebase options for initialization.
- `main.dart`: Entry point of the app, initializes Firebase, and sets up providers.
- `model`: Contains the model classes for chats, messages, and users.
- `navigator.dart`: Handles navigation within the app.
- `view`: Contains UI components, including pages and widgets.

## Encryption
The Flutter Chat App utilizes encryption to ensure the security and privacy of messages exchanged between users. The encryption process involves the following steps:

1. Initialization: When the app is launched, a unique chat ID is generated for each conversation between two users. This chat ID is used as the encryption key.

2. AES Encryption: The AES (Advanced Encryption Standard) algorithm is used for message encryption. Each message is encrypted using the AES algorithm with the chat ID as the encryption key.

3. AES Decryption: When a user receives an encrypted message, the app uses the corresponding chat ID as the decryption key to decrypt the message and display it in its original form.

By employing encryption, the Flutter Chat App ensures that even if messages are intercepted, they cannot be read without the proper decryption key, providing a high level of security for user communication.

## Dependencies
- `flutter`: [Flutter framework](https://flutter.dev/)
- `firebase_core`: [Firebase Core](https://pub.dev/packages/firebase_core)
- `cloud_firestore`: [Firebase Cloud Firestore](https://pub.dev/packages/cloud_firestore)
- `firebase_auth`: [Firebase Authentication](https://pub.dev/packages/firebase_auth)
- `provider`: [State management](https://pub.dev/packages/provider)
- `encrypt`: [Encryption and decryption](https://pub.dev/packages/encrypt)

## License
This project is licensed under the [MIT License](LICENSE).

## Contributing
Contributions are welcome! If you have any ideas, suggestions, or bug reports, please open an issue or submit a pull request.

## Contact
For any inquiries or feedback, please contact [your-email@example.com](mailto:your-email@example.com).
