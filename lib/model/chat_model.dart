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

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      user1Id: json['user1Id'],
      user2Id: json['user2Id'],
      messages: List<Message>.from(
        json['messages'].map(
          (e) => Message.fromJson(e),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user1Id': user1Id,
      'user2Id': user2Id,
      'messages': messages.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'Chat(id: $id, user1Id: $user1Id, user2Id: $user2Id, messages: $messages)';
  }
}
