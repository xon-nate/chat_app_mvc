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

  const ChatPage({
    super.key,
    required this.participant,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
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
          // leading: IconButton(
          //   onPressed: () {
          //     Navigator.pop(context);
          //     ctext.read<ChatController>().dispose();
          //   },
          //   icon: const Icon(Icons.arrow_back),
          // ),
        ),
        body: Column(
          children: [
            Expanded(
              child: FutureProvider<String>(
                initialData: '',
                create: (ctext) => ctext.read<ChatController>().chatIdFuture,
                builder: (ctext, child) {
                  final chatId = ctext.watch<String>();
                  if (chatId == '') {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (chatId.isEmpty) {
                    return const Center(
                      child: Text('No chat found'),
                    );
                  } else {
                    return Text(chatId);
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
      ),
    );
  }
}
