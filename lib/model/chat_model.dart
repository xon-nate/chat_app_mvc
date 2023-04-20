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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user1Id': user1Id,
      'user2Id': user2Id,
      'messages': messages.map((m) => m.toMap()).toList(),
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map, String id) {
    // print(map);
    return Chat(
      id: id,
      user1Id: map['user1Id'],
      user2Id: map['user2Id'],
      messages: (map['messages'] as List<dynamic>)
          .map((m) => Message.fromMap(m)) // pass document ID as second argument
          .toList(),
    );
  }
}
