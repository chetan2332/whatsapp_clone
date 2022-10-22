import 'package:whatsapp/common/enums/message_enum.dart';
// import 'dart:convert';

class Message {
  final String recieverId;
  final String senderId;
  final String text;
  final String messageId;
  final DateTime timeSent;
  final bool isSeen;
  final MessageEnum messageType;

  Message({
    required this.recieverId,
    required this.senderId,
    required this.text,
    required this.messageId,
    required this.timeSent,
    required this.isSeen,
    required this.messageType,
  });

  Map<String, dynamic> toMap() {
    return {
      'recieverId': recieverId,
      'senderId': senderId,
      'text': text,
      'messageId': messageId,
      'timeSent': timeSent.toIso8601String(),
      'isSeen': isSeen,
      'messageType': messageType.type,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      recieverId: map['recieverId'],
      senderId: map['senderId'],
      text: map['text'],
      messageId: map['messageId'],
      timeSent: DateTime.parse(map['timeSent']),
      isSeen: map['isSeen'],
      messageType: (map['messageType'] as String).toEnum(),
    );
  }
}
