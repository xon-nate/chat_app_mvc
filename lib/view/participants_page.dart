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
      resizeToAvoidBottomInset: false,
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
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      useSafeArea: true,
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return SingleChildScrollView(
                          reverse: true,
                          child: Container(
                            padding: EdgeInsets.only(
                              bottom:
                                  MediaQuery.of(context).viewInsets.bottom + 40,
                              left: 20,
                              right: 20,
                              top: 10,
                            ),
                            // height: MediaQuery.of(context).size.height * 0.4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Send message',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 10),
                                    Divider(
                                      thickness: 2,
                                      height: 0,
                                      indent: 30,
                                      endIndent: 30,
                                      color: Colors.grey[400],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 25),
                                // const Text(
                                //   'To: ',
                                //   style: TextStyle(
                                //     fontWeight: FontWeight.bold,
                                //   ),
                                // ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: DropdownButtonFormField(
                                    hint: const Text('Select a user'),
                                    decoration: const InputDecoration(
                                      hintText: 'Select a user',
                                      labelText: 'Select a user',
                                    ),
                                    isExpanded: true,
                                    items: participants
                                        .map(
                                          (e) => DropdownMenuItem(
                                            child: Text(e.name),
                                            value: e,
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) {
                                      print(value);
                                    },
                                  ),
                                ),
                                SizedBox(height: 10),
                                const Text(
                                  'Message: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      hintText: 'Enter your message',
                                      suffixIcon: IconButton(
                                        alignment: Alignment.bottomRight,
                                        onPressed: () {},
                                        icon: const Icon(Icons.send),
                                      ),
                                    ),
                                    maxLines: 7,
                                    minLines: 3,
                                    expands: false,
                                    onChanged: (value) {
                                      print(value);
                                    },
                                  ),
                                ),
                                ElevatedButton(
                                    onPressed: () {},
                                    child: Text('Submit New Message'))
                              ],
                            ),
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
