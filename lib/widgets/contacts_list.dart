import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/common/utils/colors.dart';
import 'package:whatsapp/common/widgets/loader.dart';
import 'package:whatsapp/features/chat/controller/chat_controller.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp/models/chat_contact.dart';
import '../features/chat/screens/mobile_chat_screen.dart';

class ContactsList extends ConsumerWidget {
  const ContactsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: StreamBuilder<List<ChatContact>>(
        stream: ref.watch(chatControllerProvider).chatContacts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          if (snapshot.data == null) {
            return const Center(
              child: Text('no snapshot data reached till ui'),
            );
          }
          return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: ((context, index) {
                var chatContact = snapshot.data![index];
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(MobileChatScreen.routeName, arguments: {
                          'name': chatContact.name,
                          'uid': chatContact.contactId,
                        });
                      },
                      child: ListTile(
                        title: Text(
                          chatContact.name,
                          style: const TextStyle(fontSize: 18),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Text(
                            chatContact.lastMessage,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        leading: CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                NetworkImage(chatContact.profilePic)),
                        trailing: Text(
                          DateFormat.Hm().format(chatContact.timeSent),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    const Divider(
                      color: dividerColor,
                      indent: 72,
                      height: 0,
                    )
                  ],
                );
              }));
        },
      ),
    );
  }
}
