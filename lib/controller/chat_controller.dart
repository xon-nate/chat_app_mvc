import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/chat_model.dart';
import '../model/message_model.dart';

class ChatController extends ChangeNotifier {
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _chatCollection =
      FirebaseFirestore.instance.collection('chats');

  get getReceiver => null;

  Future<List<Message>> getMessages(String chatId) async {
    Future<QuerySnapshot<Map<String, dynamic>>> snapshot = _chatCollection
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .first;
    List<Message> messages = [];
    await snapshot.then((value) {
      for (var element in value.docs) {
        messages.add(Message.fromJson(element.data()));
      }
    });
    return messages;
  }

  Future<bool> chatExists(String user1Id, String user2Id) async {
    QuerySnapshot<Object?> snapshot = await _chatCollection
        .where('user1Id', isEqualTo: user1Id)
        .where('user2Id', isEqualTo: user2Id)
        .get();
    if (snapshot.docs.isEmpty) {
      snapshot = await _chatCollection
          .where('user1Id', isEqualTo: user2Id)
          .where('user2Id', isEqualTo: user1Id)
          .get();
    }
    return snapshot.docs.isNotEmpty;
  }

  Future<Chat> createChat(String user1Id, String user2Id) async {
    DocumentReference<Object?> docRef = await _chatCollection
        .add({'user1Id': user1Id, 'user2Id': user2Id, 'messages': []});
    return Chat(
      id: docRef.id,
      user1Id: user1Id,
      user2Id: user2Id,
      messages: List<Message>.from([
        Message(
          id: '',
          text: 'Hello',
          senderId: user1Id,
          receiverId: user2Id,
          createdAt: DateTime.now(),
        ),
        Message(
          id: '',
          text: 'Hi',
          senderId: user2Id,
          receiverId: user1Id,
          createdAt: DateTime.now(),
        ),
      ]),
    );
  }
}
