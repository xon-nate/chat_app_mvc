// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/chat_model.dart';
import '../model/message_model.dart';
import '../model/user_model.dart';

class ChatController extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference _chatCollection;

  // late Chat currentChat = Chat(id: '', user1Id: '', user2Id: '', messages: []);

  // get getCurrentChat => currentChat;
  final String senderId;
  final String receiverId;
  late String chatId = '';
  late Future<String> chatIdFuture;

  bool isChatIdSet = false;
  ChatController({required this.senderId, required this.receiverId}) {
    _chatCollection = firestore.collection('chats');
    print('Chat Controller initialized: _');
    chatIdFuture = getChatIdFunc();
    print('CHATCONTROLLER CONSTRUCTOR : $senderId');
    print('CHATCONTROLLER CONSTRUCTOR : $receiverId');
  }

  setChatId(String id) {
    chatId = id;
    notifyListeners();
  }

  Stream<QuerySnapshot> getChatMessagesSnapshot() {
    print('Chat ID is set to : $chatId');

    Stream<QuerySnapshot> msgs = _chatCollection
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots();

    return msgs;
  }

  // Stream<List<Message>> getChatMessagesStream() {
  //   print('Chat ID is set to : $chatId');
  //   // getChatId();
  //   print('Chat ID is set to : $chatId');
  //   // getChatId();
  //   Stream<QuerySnapshot<Map<String, dynamic>>> msgs = _chatCollection
  //       .doc(chatId)
  //       .collection('messages')
  //       .orderBy('timestamp')
  //       .snapshots();
  //   return msgs.map(
  //       (event) => event.docs.map((e) => Message.fromMap(e.data())).toList());
  // }

  // Future<void> loadSetChatId() async {
  // chatId = await getChatId();
  // notifyListeners();
  // }

  Future<String> getChatIdFunc() async => await getChatId();

  Future<String> getChatId() async {
    final chatDocs = await _chatCollection
        .where('user1Id', isEqualTo: senderId)
        .where('user2Id', isEqualTo: receiverId)
        .limit(1)
        .get();
    QueryDocumentSnapshot<Object?> chatDoc;
    if (chatDocs.docs.isNotEmpty) {
      chatDoc = chatDocs.docs.first;
      print('found chat id');
      // print(chatDoc.id);
      print('CHAT ID IS SET TO : $chatId');
      chatId = chatDoc.id;
      notifyListeners();
      return chatDoc.id;
    } else {
      final reverseChatDocs = await _chatCollection
          .where('user1Id', isEqualTo: receiverId)
          .where('user2Id', isEqualTo: senderId)
          .limit(1)
          .get();

      if (reverseChatDocs.docs.isNotEmpty) {
        final chatDoc = reverseChatDocs.docs.first;
        print('found chat id');
        // print(chatDoc.id);
        chatId = chatDoc.id;
        notifyListeners();
        print('CHAT ID IS SET TO : $chatId');
        return chatDoc.id;
      } else {
        final chatDoc = await createChat(senderId, receiverId);
        print('created new chat id');
        // print(newChatDocId);
        chatId = chatDoc.id;
        notifyListeners();
        print('CHAT ID IS SET TO : $chatId');
        return chatDoc.id;
      }
    }
    notifyListeners();
    // return chatDocs.docs.first.id;
    return '';
  }

  Future<DocumentReference<Object?>> createChat(
      String user1Id, String user2Id) async {
    final docRef = await _chatCollection.add({
      'user1Id': user1Id,
      'user2Id': user2Id,
      'messages': [
        {
          'senderId': user1Id,
          'receiverId': user2Id,
          'text': 'First message from $user1Id',
          'timestamp': DateTime.now().toUtc(),
        },
        {
          'senderId': user2Id,
          'receiverId': user1Id,
          'text': 'First response from $user2Id',
          'timestamp': DateTime.now().toUtc(),
        },
      ],
    });
    final chat = Chat(
      id: docRef.id,
      user1Id: user1Id,
      user2Id: user2Id,
      messages: [
        Message(
          senderId: user1Id,
          receiverId: user2Id,
          text: 'First message from $user1Id',
          timestamp: DateTime.now().toUtc(),
        ),
        Message(
          senderId: user2Id,
          receiverId: user1Id,
          text: 'First response from $user2Id',
          timestamp: DateTime.now().toUtc(),
        ),
      ],
    );
    docRef.set(chat.toMap());
    return docRef;
  }
}
