import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/chat_model.dart';
import '../model/message_model.dart';
import '../model/user_model.dart';

class ChatController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _chatCollection =
      FirebaseFirestore.instance.collection('chats');

  // late Chat currentChat = Chat(id: '', user1Id: '', user2Id: '', messages: []);

  // get getCurrentChat => currentChat;
  final String senderId;
  final String receiverId;
  String? chatId;
  bool isChatIdSet = false;
  ChatController({required this.senderId, required this.receiverId}) {
    chatId = null;

    _initialize();
    print(senderId);
    print(receiverId);
    print(chatId);
  }

  Future<void> _initialize() async {
    while (chatId == null) {
      await getChatId();
    }
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

  Stream<List<Message>> getChatMessagesStream() {
    print('Chat ID is set to : $chatId');
    getChatId();
    print('Chat ID is set to : $chatId');
    Stream<QuerySnapshot<Map<String, dynamic>>> msgs = _chatCollection
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots();

    return msgs.map(
        (event) => event.docs.map((e) => Message.fromMap(e.data())).toList());
  }

  Future<void> getChatId() async {
    DocumentSnapshot snapshot = await _chatCollection
        .where('user1Id', isEqualTo: senderId)
        .where('user2Id', isEqualTo: receiverId)
        .get()
        .then((value) => value.docs.first);
    if (!snapshot.exists) {
      snapshot = await _chatCollection
          .where('user1Id', isEqualTo: receiverId)
          .where('user2Id', isEqualTo: senderId)
          .get()
          .then((value) => value.docs.first);
      print('getCHATID: ${snapshot.id}');
      chatId = snapshot.id;
      notifyListeners();
      // setChatId(snapshot.id);
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages() {
    if (chatId == null) {
      getChatId();
    }
    var msgs =
        _chatCollection.doc(chatId).collection('messages').orderBy('timestamp');
    print(msgs);
    print(msgs.snapshots());
    return msgs.snapshots();
  }

  Future<Chat> createChat(String user1Id, String user2Id) async {
    DocumentReference docRef = await _chatCollection.add({
      'user1Id': user1Id,
      'user2Id': user2Id,
      'messages': [],
    });
    Chat currentChat = Chat(
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
