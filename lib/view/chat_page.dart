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
      create: (ctext) => ChatController(
        senderId: ctext.read<UserController>().currentUser!.id,
        receiverId: participant.id,
      ),
      builder: (ctext, child) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Chat with ${participant.name}'),
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
                    return Column(
                      children: [
                        // Text(chatId),
                        StreamProvider<DocumentSnapshot<Object?>?>(
                          create: (context) =>
                              ctext.read<ChatController>().getChatDoc(),
                          initialData: null,
                          builder: (ctext, child) {
                            final DocumentSnapshot<Object?>? chatDoc =
                                ctext.read<DocumentSnapshot>();
                            // ignore: unnecessary_null_comparison
                            if (chatDoc == null) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (chatDoc.data() == null) {
                              return const Center(
                                child: Text('No chat found'),
                              );
                            } else {
                              var docData = chatDoc.data();
                              Map<String, dynamic> chatData =
                                  docData as Map<String, dynamic>;
                              List messageObjects = chatData['messages']
                                  .map((e) => Message.fromJson(e))
                                  .toList();
                              for (var element in messageObjects) {
                                print(element.text);
                              }

                              return Expanded(
                                child: ListView.builder(
                                  itemCount: messageObjects.length,
                                  itemBuilder: (context, index) {
                                    bool isMe =
                                        messageObjects[index].senderId ==
                                            ctext
                                                .read<UserController>()
                                                .currentUser!
                                                .id;
                                    return ListTile(
                                      tileColor: isMe
                                          ? Colors.blue.shade100
                                          : Colors.grey.shade100,
                                      title: Text(
                                        messageObjects[index].text,
                                        textAlign: isMe
                                            ? TextAlign.right
                                            : TextAlign.left,
                                      ),
                                      subtitle: Text(
                                        messageObjects[index]
                                            .timestamp
                                            .toString(),
                                        textAlign: isMe
                                            ? TextAlign.right
                                            : TextAlign.left,
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.blue.shade100,
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
                    icon: const Icon(
                      Icons.send,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     ctext.read<ChatController>().getChatMessagesSnapshot();
        //   },
        //   child: const Icon(Icons.add),
        // ),
      ),
    );
  }
}
