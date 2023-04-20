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
    print(chatController.getCurrentChat.id);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Chat with ${participant.name}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(chatController.getCurrentChat.id)
                  .collection('messages')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  List<Message> messages = snapshot.data!.docs
                      .map((doc) =>
                          Message.fromMap(doc.data() as Map<String, dynamic>))
                      .toList(growable: false);
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: messages[index].senderId ==
                                  userController.getCurrentUser!.id
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: messages[index].senderId ==
                                        userController.getCurrentUser!.id
                                    ? Colors.blue
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                messages[index].text,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
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
