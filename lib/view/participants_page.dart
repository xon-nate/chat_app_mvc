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
    final User? loggedInUser = context.read<UserController>().currentUser;
    final List<User> participants =
        context.read<UserController>().getParticipants(loggedInUser);
    //TODO no need for consumer, future builder, then inside it call context.read....tkon future

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
        leading: loggedInUser == null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : Container(),
        actions: [
          loggedInUser != null
              ? IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    Navigator.pop(context);
                    userController.logoutUser();
                    print('${loggedInUser.getName.toString()} logged out');
                  },
                )
              : Container(),
        ],
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

      //TODO Implement future builder instead
      //TODO Implement streambuilder?
      //Sign out on firebase notifies the stream
      //when that happens you don't have token / logged out

      body: Consumer<UserController>(
        builder: (context, userController, child) {
          return ListView.builder(
            itemCount: participants.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(participants[index].name),
                subtitle: Text(participants[index].email),
                leading: CircleAvatar(child: Text(participants[index].name[0])),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pushNamed(context, '/chat', arguments: {
                    'loggedInUser': loggedInUser,
                    'selectedUser': participants[index],
                  });
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.message),
        onPressed: () {
          loggedInUser == null
              ? ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please login to send a message'),
                  ),
                )
              : Navigator.pushNamed(
                  context,
                  '/chat',
                  arguments: {
                    'loggedInUser': loggedInUser,
                    'selectedUser': null,
                  },
                );
        },
      ),
    );
  }
}
