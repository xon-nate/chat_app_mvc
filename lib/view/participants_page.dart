import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/user_controller.dart';
import '../controller/chat_controller.dart';
import '../model/user_model.dart';
import '../navigator.dart';
import 'chat_page.dart';
import 'widgets/dropdown_user_select.dart';
import 'widgets/modal_text_field.dart';

class ParticipantsPage extends StatelessWidget {
  final UserController userController;

  const ParticipantsPage({super.key, required this.userController});
  // print(userController.currentUser.toString());

  @override
  Widget build(BuildContext context) {
    final MyAppUser? loggedInUser = context.read<UserController>().currentUser;
    final userController = context.read<UserController>();
    final List<MyAppUser> participants =
        context.read<UserController>().getUsers;

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
                      fontSize: 20,
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
                    'Participants List ',
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
        child: ListView.builder(
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
              onTap: () async {
                ChatController chatController = context.read<ChatController>();
                if (loggedInUser != null) {
                  String user1Id = loggedInUser.id;
                  String user2Id = participant.id;
                  String chatId = chatController.getChatId(user1Id, user2Id);
                  await chatController.getChat(chatId);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                        chatController: chatController,
                        userController: userController,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please log in to chat'),
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.message),
        onPressed: () {
          showNewMessageModal(context, userController.getUsers);
        },
      ),
    );
  }

  Future<dynamic> showNewMessageModal(
      BuildContext context, List<MyAppUser> participants) {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          reverse: true,
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 40,
              left: 20,
              right: 20,
              top: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                Divider(
                  thickness: 4,
                  indent: 100,
                  endIndent: 100,
                  color: Colors.grey[400],
                ),
                const Center(
                  child: Text(
                    'New Message',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
                const MessageTextFormField(),
                // const SizedBox(height: 25),
                Row(
                  // direction: Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    DropdownUserSelect(
                      participants: participants,
                    ),
                    const Spacer(),
                    FittedBox(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: const [
                            Text('Send'),
                            SizedBox(width: 5),
                            FittedBox(
                              fit: BoxFit.contain,
                              child: Icon(Icons.send, size: 20),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
