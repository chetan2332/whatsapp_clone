import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp/common/enums/message_enum.dart';
import 'package:whatsapp/common/utils/utils.dart';
import 'package:whatsapp/models/chat_contact.dart';
import 'package:whatsapp/models/message.dart';
import 'package:whatsapp/models/user_model.dart';

final chatRepositoryProvider = Provider((ref) => ChatRepository(
      firestore: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance,
    ));

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRepository({required this.firestore, required this.auth});

  Stream<List<ChatContact>> getChatContacts() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contacts = [];
      for (var document in event.docs) {
        var chatContact = ChatContact.fromMap(document.data());
        var userData = await firestore
            .collection('users')
            .doc(chatContact.contactId)
            .get();
        var user = UserModel.fromMap(userData.data()!);
        contacts.add(
          ChatContact(
            name: user.name,
            profilePic: user.profilePic,
            contactId: chatContact.contactId,
            timeSent: chatContact.timeSent,
            lastMessage: chatContact.lastMessage,
          ),
        );
      }
      return contacts;
    });
  }

  void _saveDataToContactsSubCollection(
    UserModel senderData,
    UserModel recieverData,
    String text,
    DateTime timesent,
    String recieverUserId,
  ) async {
    var recieverUserChatContact = ChatContact(
      name: senderData.name,
      profilePic: senderData.profilePic,
      timeSent: timesent,
      lastMessage: text,
      contactId: senderData.uid,
    );
    await firestore
        .collection('users')
        .doc(recieverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .set(recieverUserChatContact.toMap());

    var senderUserChatContact = ChatContact(
      name: recieverData.name,
      profilePic: recieverData.profilePic,
      timeSent: timesent,
      lastMessage: text,
      contactId: recieverData.uid,
    );
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .set(
          senderUserChatContact.toMap(),
        );
  }

  void _saveMessageToMessaageSubCollection(
      {required recieverUserId,
      required String text,
      required DateTime timeSent,
      required String messageId,
      required String recieverUsername,
      required MessageEnum messageType}) async {
    var message = Message(
        recieverId: recieverUserId,
        senderId: auth.currentUser!.uid,
        text: text,
        messageId: messageId,
        timeSent: timeSent,
        isSeen: false,
        messageType: MessageEnum.text);

    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());
    await firestore
        .collection('users')
        .doc(recieverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());
  }

  void sendTextMessage(
      {required BuildContext context,
      required String text,
      required String recieverId,
      required UserModel senderUser}) async {
    try {
      var timeSent = DateTime.now();
      UserModel recieverUserData;
      var userDatamap =
          await firestore.collection('users').doc(recieverId).get();
      recieverUserData = UserModel.fromMap(userDatamap.data()!);
      var messageId = const Uuid().v1();

      _saveDataToContactsSubCollection(
          senderUser, recieverUserData, text, timeSent, recieverId);

      _saveMessageToMessaageSubCollection(
          recieverUserId: recieverUserData.uid,
          text: text,
          timeSent: timeSent,
          messageId: messageId,
          recieverUsername: recieverUserData.name,
          messageType: MessageEnum.text);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
