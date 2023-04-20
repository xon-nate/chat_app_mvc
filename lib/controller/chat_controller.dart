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
  late MyAppUser sender;

  String chatId = '';
  List<Message> messages = [];
  late Chat currentChat;

  get getChat => Chat(
      id: chatId, user1Id: sender.id, user2Id: receiver.id, messages: messages);
  get getReceiver => receiver;
  get getSender => getChat.sender;
  get getMessages => getChat.messages;
  get getChatId => getChat.chatId;

  void setReceiver(MyAppUser? receiver) {
    this.receiver = receiver!;
    notifyListeners();
  }

  void setMessages(List<Message> messages) {
    this.messages = messages;
    notifyListeners();
  }

  void setCurrentChat(Chat chat) {
    currentChat = chat;
    chatId = chat.id;
    messages = chat.messages;
    notifyListeners();
  }

  Future<Chat> loadChat(MyAppUser sender, MyAppUser receiver) async {
    this.sender = sender;
    if (this.sender.id == receiver.id) {
      throw Exception('Sender and receiver cannot be the same');
    }
    // this.receiver = receiver;
    String chatId = await getChatIdFromUsers(sender.id, receiver.id);
    currentChat = await getChatFromId(chatId, sender);
    setCurrentChat(currentChat);
    return currentChat;
  }

  Future<Chat> getChatFromId(String chatId, MyAppUser loggedInUser) async {
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
            'text': 'Hello ${receiver.name}',
            'timestamp': DateTime.now(),
          },
          {
            'senderId': receiver.id,
            'receiverId': sender.id,
            'text': 'Hi ${sender.name}',
            'timestamp': DateTime.now(),
          }
        ],
      });
      Chat newChat = Chat.fromMap(
          newChatSnapshot.data() as Map<String, dynamic>, newChatSnapshot.id);
      setMessages(newChat.messages);
      notifyListeners();
      return newChat;
      //
    }
  }

  // Future<List<Message>> getMessagesByChatId(String chatId) async {
  //   Future<QuerySnapshot<Map<String, dynamic>>> snapshot = _chatCollection
  //       .doc(chatId)
  //       .collection('messages')
  //       .orderBy('timestamp', descending: true)
  //       .snapshots()
  //       .first;
  //   await snapshot.then((value) {
  //     for (var element in value.docs) {
  //       messages.add(Message.fromJson(element.data(), element.id));
  //     }
  //   });

  //   return messages;
  // }
  Future<List<Message>> getMessagesByChatId(String chatId) async {
    final snapshot = await _chatCollection.doc(chatId).get();
    if (snapshot.exists) {
      Chat chat = Chat.fromMap(snapshot.data() as Map<String, dynamic>, chatId);
      // setMessages(chat.messages);
      // notifyListeners();
      return chat.messages;
    } else {
      throw Exception('Chat does not exist');
    }
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
        // else create new chat
      } else {
        var newChatRef =
            await _chatCollection.add(Map<String, dynamic>.from({}));
        newChatRef.get().then((value) {
          chatId = value.id;
          print(chatId);
        });
        final newChatSnapshot = await newChatRef.get();
        _chatCollection.doc(newChatSnapshot.id).set({
          'user1Id': senderId,
          'user2Id': receiverId,
          'messages': [
            {
              'senderId': senderId,
              'receiverId': receiverId,
              'text': 'Hello ${receiver.name}',
              'timestamp': DateTime.now(),
            },
            {
              'senderId': receiverId,
              'receiverId': senderId,
              'text': 'Hi ${sender.name} - from getChatIdFromUsers',
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
