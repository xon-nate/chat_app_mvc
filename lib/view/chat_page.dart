import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../controller/chat_controller.dart';
import '../controller/user_controller.dart';
import '../model/message_model.dart';
import '../model/user_model.dart';
import 'widgets/message_widgets.dart';

class ChatPage extends StatefulWidget {
  final MyAppUser participant;

  const ChatPage({
    super.key,
    required this.participant,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController scrollController = ScrollController();

  bool _isScrolledToBottom = true;
  // double _previousHeight = 0.0;
  bool _hasBuiltListView = false; // add this line

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      // user scrolled to the bottom
      setState(() {
        _isScrolledToBottom = true;
      });
    } else {
      setState(() {
        _isScrolledToBottom = false;
      });
    }
  }

  void _scrollToBottom() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 50),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctext) => ChatController(
        senderId: ctext.read<UserController>().currentUser!.id,
        receiverId: widget.participant.id,
      ),
      builder: (ctext, child) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Chat with ${widget.participant.name}'),
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
                    return StreamBuilder<DocumentSnapshot>(
                      stream: ctext.read<ChatController>().getChatDoc(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        Map<String, dynamic> chatData =
                            snapshot.data!.data() as Map<String, dynamic>;

                        List<dynamic> messages = chatData['messages'];
                        for (int i = 0; i < messages.length; i++) {
                          messages[i]['text'] = ctext
                              .read<ChatController>()
                              .decryptMessage(messages[i]['text']);
                        }
                        if (!_hasBuiltListView) {
                          ctext.read<ChatController>().itemCount =
                              messages.length;
                          // add this line
                          _hasBuiltListView = true;
                          SchedulerBinding.instance.addPostFrameCallback((_) {
                            _scrollToBottom();
                          });
                        }
                        if (messages.length >
                            ctext.read<ChatController>().itemCount) {
                          SchedulerBinding.instance.addPostFrameCallback((_) {
                            _scrollToBottom();
                          });
                          ctext.read<ChatController>().itemCount =
                              messages.length;
                        }
                        return Scrollbar(
                          thickness: 5,
                          thumbVisibility: true,
                          controller: scrollController,
                          radius: const Radius.circular(10),
                          child: ListView.builder(
                            itemCount: messages.length,
                            controller: scrollController,
                            itemBuilder: (context, index) {
                              final message = messages[index];
                              bool isSender = message['senderId'] ==
                                  context
                                      .read<UserController>()
                                      .currentUser!
                                      .id;
                              return isSender
                                  ? MessageFromMe(
                                      message: Message.fromJson(message))
                                  : MessageToMe(
                                      message: Message.fromJson(message),
                                      senderInitial: context
                                          .read<UserController>()
                                          .currentUser!
                                          .name[0],
                                    );
                            },
                          ),
                        );
                      },
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
                  Expanded(
                    child: TextFormField(
                      onTap: () {
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          _scrollToBottom();
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: 'Send a message',
                      ),
                      onChanged: (value) {
                        ctext.read<ChatController>().messageText = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // print(message);
                      ctext.read<ChatController>().sendMessage();
                    },
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
      ),
    );
  }
}
