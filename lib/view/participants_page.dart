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
    final MyAppUser? loggedInUser = context.watch<UserController>().currentUser;
    final userController = context.watch<UserController>();
    // final List<MyAppUser> participants =
    //     context.watch<UserController>().getUsers;

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
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pop(context);
              userController.signOut();
              print('${loggedInUser.toString()} logged out');
            },
          ),
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
      body: FutureProvider<List<MyAppUser>>.value(
        value: userController.getUserList(),
        initialData: const [],
        child: Consumer<List<MyAppUser>>(
          builder: (context, participants, _) {
            if (participants.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: participants.length,
              itemBuilder: (context, index) {
                final MyAppUser participant = participants[index];
                bool isUpperCased =
                    participant.name[0] == participant.name[0].toUpperCase();
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        Colors.primaries[index % Colors.primaries.length],
                    child: Text(
                      participant.name[0],
                      style: TextStyle(
                        fontWeight:
                            isUpperCased ? FontWeight.normal : FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    // color: Colors.black,
                  ),
                  title: Text(participant.name),
                  subtitle: Text(participant.email),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.message),
                                    title: const Text('Send Message'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.pushNamed(
                                        context,
                                        '/chat',
                                        arguments: participant,
                                      );
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.info),
                                    title: const Text('View Profile'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.pushNamed(
                                        context,
                                        '/profile',
                                        arguments: participant,
                                      );
                                    },
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  DropdownButton(
                                    value: participant,
                                    items: participants.map(
                                      (e) {
                                        return DropdownMenuItem(
                                          value: e,
                                          child: Text(e.name),
                                        );
                                      },
                                    ).toList(),
                                    onChanged: (value) {
                                      print(value);
                                    },
                                  ),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      hintText: 'Enter your message',
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.message),
        onPressed: () {},
      ),
    );
  }
}
// showModalBottomSheet(
//                       context: context,
//                       builder: (context) {
//                         return Container(
//                           height: 200,
//                           child: Column(
//                             children: [
//                               ListTile(
//                                 leading: const Icon(Icons.message),
//                                 title: const Text('Send Message'),
//                                 onTap: () {
//                                   Navigator.pop(context);
//                                   Navigator.pushNamed(
//                                     context,
//                                     '/chat',
//                                     arguments: participant,
//                                   );
//                                 },
//                               ),
//                               ListTile(
//                                 leading: const Icon(Icons.info),
//                                 title: const Text('View Profile'),
//                                 onTap: () {
//                                   Navigator.pop(context);
//                                   Navigator.pushNamed(
//                                     context,
//                                     '/profile',
//                                     arguments: participant,
//                                   );
//                                 },
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     )
