import 'package:flutter/material.dart';

import '../model/user_model.dart';

class ParticipantsPage extends StatelessWidget {
  final List<User> participants;

  const ParticipantsPage({super.key, required this.participants});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Participants'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: participants.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(participants[index].name),
            subtitle: Text(participants[index].email),
          );
        },
      ),
    );
  }
}
