import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/chat_model.dart';
import '../model/message_model.dart';
import '../model/user_model.dart';

class ChatController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _chatCollection =
      FirebaseFirestore.instance.collection('chats');

  late Chat currentChat = Chat(id: '', user1Id: '', user2Id: '', messages: []);

  get getCurrentChat => currentChat;
  setCurrentChat(Chat chat) {
    currentChat = chat;
    notifyListeners();
  }

  Future<Chat> getChat(MyAppUser sender, MyAppUser receiver) async {
    DocumentSnapshot snapshot = await _chatCollection
        .where('user1Id', isEqualTo: sender.id)
        .where('user2Id', isEqualTo: receiver.id)
        .get()
        .then((value) => value.docs.first);

    if (!snapshot.exists) {
      snapshot = await _chatCollection
          .where('user1Id', isEqualTo: receiver.id)
          .where('user2Id', isEqualTo: sender.id)
          .get()
          .then((value) => value.docs.first);
      if (!snapshot.exists) {
        return await createChat(sender.id, receiver.id);
      }
      return Chat.fromMap(snapshot.data() as Map<String, dynamic>, snapshot.id);
    }
    // print(snapshot.data());
    Chat newChat =
        Chat.fromMap(snapshot.data() as Map<String, dynamic>, snapshot.id);
    setCurrentChat(newChat);
    return newChat;
  }

  Stream<QuerySnapshot> getMessages(String chatId) {
    return _chatCollection.doc(chatId).collection('messages').snapshots();
  }

  Future<Chat> createChat(String user1Id, String user2Id) async {
    DocumentReference docRef = await _chatCollection.add({
      'user1Id': user1Id,
      'user2Id': user2Id,
      'messages': [],
    });
    currentChat = Chat(
      id: docRef.id,
      user1Id: user1Id,
      user2Id: user2Id,
      messages: [
        Message(
          // id: '',
          senderId: user1Id,
          receiverId: user2Id,
          text: 'First message from $user1Id',
          timestamp: DateTime.now(),
        ),
        Message(
          // id: '',
          senderId: user2Id,
          receiverId: user1Id,
          text: 'First response from $user2Id',
          timestamp: DateTime.now(),
        ),
      ],
    );
    docRef.set(currentChat.toMap());
    return currentChat;
  }
}
