import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../controller/chat_controller.dart';
import '../controller/user_controller.dart';
import '../model/chat_model.dart';
import '../model/message_model.dart';
import '../model/user_model.dart';

class ChatPage extends StatelessWidget {
  final UserController userController;
  final ChatController chatController;
  final MyAppUser participant;
  final Chat chat;
  const ChatPage({
    super.key,
    required this.userController,
    required this.chatController,
    required this.participant,
    required this.chat,
  });

  @override
  Widget build(BuildContext context) {
    String chatId = chatController.getCurrentChat.id;
    // print(chatId);
    List<Message> messages = chatController.getChatMessages;
    // print(messages);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Chat with ${participant.name}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: chatController.getChatMessagesStream(chatId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print(snapshot.data!.docs);
                  messages = snapshot.data!.docs
                      .map((doc) =>
                          Message.fromMap(doc.data() as Map<String, dynamic>))
                      .toList();
                  print(messages[0].text);
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(messages[index].text),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
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
