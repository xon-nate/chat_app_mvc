import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/chat_model.dart';
import '../model/message_model.dart';
import '../model/user_model.dart';

class ChatController extends ChangeNotifier {
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _chatCollection =
      FirebaseFirestore.instance.collection('chats');

  late final MyAppUser receiver;
  late final MyAppUser sender;
  String chatId = '';
  List<Message> messages = [];

  get getReceiver => receiver;
  get getSender => sender;
  get getMessages => messages;
  get getChatId => chatId;

  Future<Chat> getChat(String chatId) async {
    final snapshot = await _chatCollection.doc(chatId).get();
    if (snapshot.exists) {
      return Chat.fromMap(snapshot.data() as Map<String, dynamic>, snapshot.id);
    } else {
      final newChatRef = await _chatCollection.add({});
      final newChatSnapshot = await newChatRef.get();
      _chatCollection.doc(newChatSnapshot.id).set({
        'user1Id': sender.id,
        'user2Id': receiver.id,
        'messages': [
          {
            'senderId': sender.id,
            'receiverId': receiver.id,
            'text': 'Hello',
            'timestamp': DateTime.now(),
          },
          {
            'senderId': receiver.id,
            'receiverId': sender.id,
            'text': 'Hi',
            'timestamp': DateTime.now(),
          }
        ],
      });
      Chat newChat = Chat.fromMap(
          newChatSnapshot.data() as Map<String, dynamic>, newChatSnapshot.id);
      return newChat;
      //
    }
  }

  Future<List<Message>> getMessagesByChatId(String chatId) async {
    Future<QuerySnapshot<Map<String, dynamic>>> snapshot = _chatCollection
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .first;
    await snapshot.then((value) {
      for (var element in value.docs) {
        messages.add(Message.fromJson(element.data()));
      }
    });

    return messages;
  }

  Future<String> getChatIdFromUsers(String senderId, receiverId) async {
    final snapshot = await _chatCollection
        .where('user1Id', isEqualTo: senderId)
        .where('user2Id', isEqualTo: receiverId)
        .get();
    if (snapshot.docs.isNotEmpty) {
      chatId = snapshot.docs.first.id;
      return chatId;
    } else {
      final snapshot = await _chatCollection
          .where('user1Id', isEqualTo: receiverId)
          .where('user2Id', isEqualTo: senderId)
          .get();
      if (snapshot.docs.isNotEmpty) {
        chatId = snapshot.docs.first.id;
        return chatId;
      } else {
        final newChatRef = await _chatCollection.add({});
        final newChatSnapshot = await newChatRef.get();
        _chatCollection.doc(newChatSnapshot.id).set({
          'user1Id': senderId,
          'user2Id': receiverId,
          'messages': [
            {
              'senderId': senderId,
              'receiverId': receiverId,
              'text': 'Hello',
              'timestamp': DateTime.now(),
            },
            {
              'senderId': receiverId,
              'receiverId': senderId,
              'text': 'Hi',
              'timestamp': DateTime.now(),
            }
          ],
        });
        chatId = newChatSnapshot.id;
      }
      return chatId;
    }
  }

  Future<Message> sendMessage(String chatId, String text) async {
    final message = Message(
      senderId: sender.id,
      receiverId: receiver.id,
      text: text,
      timestamp: DateTime.now(),
      id: '',
    );
    await _chatCollection
        .doc(chatId)
        .collection('messages')
        .add(message.toJson());
    return message;
  }
}
