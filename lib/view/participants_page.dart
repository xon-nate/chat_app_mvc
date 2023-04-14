import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/user_controller.dart';
import '../model/user_model.dart';

class ParticipantsPage extends StatelessWidget {
  final UserController userController;

  const ParticipantsPage({super.key, required this.userController});
  // print(userController.currentUser.toString());

  @override
  Widget build(BuildContext context) {
    // final User? loggedInUser = userController.currentUser;
    // List<User> participants = userController.getParticipants(loggedInUser);
    // final participants =
    //     context.watch<UserController>().getParticipants(loggedInUser);
    final User? loggedInUser = context.read<UserController>().currentUser;
    final List<User> participants =
        context.read<UserController>().getParticipants(loggedInUser);

    return Scaffold(
      appBar: AppBar(
        title: loggedInUser != null
            ? PreferredSize(
                preferredSize: const Size.fromHeight(48.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Welcome back ${loggedInUser.name}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            : const Text('Participants'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            userController.logoutUser();
            print('${loggedInUser.toString()} logged out');
          },
        ),
        bottom: loggedInUser != null
            ? const PreferredSize(
                preferredSize: Size.fromHeight(48.0),
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Participants List (Tap on a user to chat)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            : null,
      ),
      body: ListView.builder(
        itemCount: participants.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(participants[index].name),
            subtitle: Text(participants[index].email),
            trailing: const Icon(Icons.arrow_forward_ios),
            leading: CircleAvatar(
              child: Text(
                participants[index].name[0],
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor:
                  Colors.primaries[index % Colors.primaries.length],
            ),
            onTap: () {
              Navigator.pushNamed(context, '/chat', arguments: {
                'loggedInUser': loggedInUser,
                'selectedUser': participants[index],
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('View User List'),
        onPressed: () {
          loggedInUser == null
              ? ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please login to view user list'),
                  ),
                )
              : ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'You are already logged in as ${loggedInUser.name}'),
                  ),
                );
          print(userController.allUsers.toString());
        },
      ),
    );
  }
}
