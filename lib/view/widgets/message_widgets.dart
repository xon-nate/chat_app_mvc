import 'package:flutter/material.dart';

import '../../model/message_model.dart';

class MessageFromMe extends StatelessWidget {
  final Message message;

  const MessageFromMe({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.blue.shade100,
      title: Text(
        message.text,
        textAlign: TextAlign.right,
      ),
      subtitle: Text(
        message.timestamp.toString(),
        textAlign: TextAlign.right,
      ),
    );
  }
}

class MessageToMe extends StatelessWidget {
  final Message message;
  final String senderInitial;
  const MessageToMe(
      {Key? key, required this.message, required this.senderInitial})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(senderInitial),
      ),
      tileColor: Colors.grey.shade100,
      title: Text(
        message.text,
        textAlign: TextAlign.left,
      ),
      subtitle: Text(
        message.timestamp.toString(),
        textAlign: TextAlign.left,
      ),
    );
  }
}
