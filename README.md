# Flutter Chat App

![App Demo](demo.gif)

## Table of Contents
- [Description](#description)
- [Features](#features)
- [Installation and Setup](#installation-and-setup)
- [Configuration](#configuration)
- [Folder Structure](#folder-structure)
- [Encryption](#encryption)
- [Code Explanation](#code-explanation)
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

The chat messages in this app are encrypted to ensure the privacy and security of user conversations. The encryption process is handled in the `ChatController` class.

The encryption process involves the following steps:

1. **Message Encryption**: When a user sends a message, the `encryptMessage` method is called. This method takes the message text and the chat ID as input parameters. It generates an encryption key using the UTF-8 representation of the chat ID and creates an Initialization Vector (IV) of length 16. The AES algorithm is used to encrypt the message text using the encryption key and IV. The resulting encrypted message is returned in Base64 format.

2. **Message Decryption**: When a user receives an encrypted message, the `decryptMessage` method is called. This method takes the encrypted message and the chat ID as input parameters. It uses the same encryption key and IV generated from the chat ID to decrypt the message. The AES algorithm is used to decrypt the encrypted message, and the original message text is obtained.

By encrypting the messages, the app ensures that the content of the conversations remains confidential and protected from unauthorized access.

## Code Explanation
The Flutter Chat App follows a modular and organized code structure. Here's an explanation of the key code files and controllers used:

- `controller/chat_controller.dart`: Manages the logic for handling chat-related operations, such as sending and receiving messages, creating chat rooms, and retrieving chat history.

- `controller/user_controller.dart`: Handles user-related operations, such as user registration, login, logout, and fetching user details.

- `view/chat_page.dart`: Renders the UI for the chat page, displaying the chat conversation, text input field, and send button.

- `view/user_list_page.dart`: Displays the list of users available for chatting and allows users to select a user to start a conversation.

- `model/chat.dart`: Represents a chat room and contains information such as the chat ID, participants, and last message.

- `model/message.dart`: Represents a message and includes details like the sender, content, timestamp, and encrypted flag.

- `model/user.dart`: Represents a user and contains attributes like the user ID, name, and email.

Feel free to explore these files and controllers for a deeper understanding of the app's implementation.

## Dependencies
The Flutter Chat App relies on the following dependencies:

- `flutter`: Flutter SDK, the foundation of the app.
- `firebase_core`: Firebase Core, for initializing the Firebase services.
- `cloud_firestore`: Firebase Cloud Firestore, for real-time data synchronization and storage.
- `firebase_auth`: Firebase Authentication, for user authentication and management.
- `provider`: State management, for managing app state and data flow.
- `encrypt`: Encryption and decryption, for implementing secure message communication.

Make sure to check the `pubspec.yaml` file for the exact versions of these dependencies used in the project.

## License
This project is licensed under the [MIT License](LICENSE).

## Contributing
Contributions are welcome! If you have any ideas, suggestions, or bug reports, please open an issue or submit a pull request.

## Contact
For any inquiries or feedback, please contact [xon.nate@gmail.com](mailto:xon.nate@gmail.com) / [aminecj0@gmail.com](mailto:aminecj0@gmail.com).
