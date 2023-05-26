// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:convert';
import '../model/chat_model.dart';
import '../model/message_model.dart';

class ChatController extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference _chatCollection;
  final String senderId;
  final String receiverId;
  late String chatId = '';

  late final encrypt.Key _key;
  late final encrypt.IV _iv;
  late final encrypt.Encrypter _encrypter;

  late Future<String> chatIdFuture;
  String messageText = '';
  int itemCount = 0;

  bool isChatIdSet = false;
  ChatController({required this.senderId, required this.receiverId}) {
    _chatCollection = firestore.collection('chats');
    print('Chat Controller initialized: _');
    chatIdFuture = getChatId().catchError((e) {
      print('ERROR CHATCONTROLLER ERROR: $e');
      return e;
    });
    initKey();
  }
  String encryptMessage(String text) {
    final encrypted = _encrypter.encrypt(text, iv: _iv);
    return encrypted.base64;
  }

  String decryptMessage(String text) {
    final decrypted = _encrypter.decrypt64(text, iv: _iv);
    return decrypted;
  }

  Message decryptMessageObject(Message msg) {
    msg.text = decryptMessage(msg.text);
    return msg;
  }

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
      // initKey();
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
        // initKey();
        return chatDoc.id;
      } else {
        final chatDoc = await createChat(senderId, receiverId);
        print('created new chat id');
        // print(newChatDocId);
        chatId = chatDoc.id;
        notifyListeners();
        print('CHAT ID IS SET TO : $chatId');
        // initKey();

        return chatDoc.id;
      }
    }
  }

  void initKey() {
    _key = encrypt.Key.fromUtf8(
        chatId.padRight(32).substring(0, 32)); // Key length must be 32 bytes
    _iv = encrypt.IV.fromUtf8('my 16 length iv.'); // IV length must be 16 bytes
    _encrypter =
        encrypt.Encrypter(encrypt.AES(_key, mode: encrypt.AESMode.cbc));
    print('KEY INITIALIZED');
  }

  Stream<DocumentSnapshot> getChatDoc() {
    return _chatCollection.doc(chatId).snapshots();
  }

  Future<void> sendMessage() async {
    if (messageText.isEmpty) return;
    final chatDoc = await _chatCollection.doc(chatId).get();
    final chat = Chat.fromMap(chatDoc.data()! as Map<String, dynamic>, chatId);
    final message = Message(
      senderId: senderId,
      receiverId: receiverId,
      text: encryptMessage(messageText),
      timestamp: DateTime.now().toUtc(),
    );
    chat.messages.add(message);
    chatDoc.reference.set(chat.toMap());
    messageText = '';
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
          'text': encryptMessage('First message from $user1Id'),
          'timestamp': DateTime.now().toUtc(),
        },
        {
          'senderId': user2Id,
          'receiverId': user1Id,
          'text': encryptMessage('First response from $user2Id'),
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
          text: encryptMessage('First message from $user1Id'),
          timestamp: DateTime.now().toUtc(),
        ),
        Message(
          senderId: user2Id,
          receiverId: user1Id,
          text: encryptMessage('First response from $user2Id'),
          timestamp: DateTime.now().toUtc(),
        ),
      ],
    );
    docRef.set(chat.toMap());
    return docRef;
  }
}
