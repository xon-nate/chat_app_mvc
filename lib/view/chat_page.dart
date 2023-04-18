import 'package:flutter/material.dart';

import '../controller/chat_controller.dart';
import '../controller/user_controller.dart';
import '../model/user_model.dart';

class ChatPage extends StatelessWidget {
  final UserController userController;
  final ChatController chatController;
  const ChatPage({
    super.key,
    required this.userController,
    required this.chatController,
  });

  @override
  Widget build(BuildContext context) {
    final MyAppUser sender = userController.getCurrentUser!;
    final MyAppUser receiver = chatController.getReceiver!;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Chat with ${sender.name}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Message $index'),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
