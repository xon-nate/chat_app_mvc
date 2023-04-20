import 'message_model.dart';

class Chat {
  final String id;
  final String user1Id;
  final String user2Id;
  final List<Message> messages;

  Chat({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    required this.messages,
  });

  static Chat fromMap(Map<String, dynamic> map, String id) {
    return Chat(
      id: id,
      user1Id: map['user1Id'],
      user2Id: map['user2Id'],
      messages: map['messages'],
    );
  }

  static Map<String, dynamic> toMap(Chat chat) {
    return {
      'user1Id': chat.user1Id,
      'user2Id': chat.user2Id,
      'messages': chat.messages,
    };
  }

  @override
  String toString() {
    return 'Chat(id: $id, user1Id: $user1Id, user2Id: $user2Id, messages: $messages)';
  }
}
