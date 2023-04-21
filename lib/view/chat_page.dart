import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/chat_controller.dart';
import '../controller/user_controller.dart';
import '../model/chat_model.dart';
import '../model/message_model.dart';
import '../model/user_model.dart';

class ChatPage extends StatelessWidget {
  final MyAppUser participant;

  ChatPage({
    super.key,
    required this.participant,
  });

  @override
  Widget build(BuildContext context) {
    // ChatController chatController = context.read<ChatController>();
    // String chatId = chatController.getCurrentChat.id;
    // print(messages);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Chat with ${participant.name}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ChangeNotifierProvider(
              create: (context) => ChatController(
                senderId: context.read<UserController>().currentUser!.id,
                receiverId: participant.id,
              ),
              child: StreamProvider<List<Message>>(
                create: (ctext) =>
                    ctext.read<ChatController>().getChatMessagesStream(),
                initialData: [],
                child: Consumer<List<Message>>(
                  builder: (context, messages, child) {
                    return ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(messages[index].text),
                        );
                      },
                    );
                  },
                ),
              ),
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
