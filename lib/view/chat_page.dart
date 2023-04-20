import 'package:flutter/material.dart';

import '../controller/chat_controller.dart';
import '../controller/user_controller.dart';
import '../model/message_model.dart';
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
    Future<String> chatId = chatController.getChatId(sender.id, receiver.id);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Chat with ${sender.name}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Message>>(
              future: chatController.getMessages(chatId as String),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final messages = snapshot.data;
                  return ListView.builder(
                    itemCount: messages!.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isMe = message.senderId == sender.id;
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 10.0,
                        ),
                        child: Row(
                          mainAxisAlignment: isMe
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: isMe ? Colors.blue : Colors.grey,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Text(
                                message.text,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
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
