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

    return Provider(
      create: (ctext) {
        final chatController = ChatController(
          senderId: ctext.read<UserController>().currentUser!.id,
          receiverId: participant.id,
        );
        chatController.getChatId();
        return chatController;
      },
      builder: (ctext, child) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Chat with ${participant.name}'),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              ctext.read<ChatController>().dispose();
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: Column(
          children: [
            Expanded(
                child: FutureBuilder<String>(
              future:
                  Provider.of<ChatController>(ctext, listen: false).getChatId(),
              builder: (ctext, snapshot) {
                if (snapshot.hasData ||
                    snapshot.connectionState == ConnectionState.done) {
                  print('ASD : Chat ID is set to : ${snapshot.data}');
                  return Text('SUCCESS: Chat ID is set to : ${snapshot.data}');
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  print('waiting for chat id : ${snapshot.data}');
                  return const CircularProgressIndicator();
                }
                return const Center(child: CircularProgressIndicator());
              },
            )),
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
      ),
    );
  }
}
