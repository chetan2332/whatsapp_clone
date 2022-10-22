class ChatContact {
  final String name;
  final String profilePic;
  final DateTime timeSent;
  final String lastMessage;
  final String contactId;

  ChatContact({
    required this.name,
    required this.profilePic,
    required this.timeSent,
    required this.lastMessage,
    required this.contactId,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profilePic': profilePic,
      'timeSent': timeSent.toIso8601String(),
      'lastMessage': lastMessage,
      'contactId': contactId,
    };
  }

  factory ChatContact.fromMap(Map<String, dynamic> map) {
    return ChatContact(
      name: map['name'] ?? 'null',
      profilePic: map['profilePic'] ?? '',
      timeSent: DateTime.parse(map['timeSent']),
      lastMessage: map['lastMessage'] ?? 'error',
      contactId: map['contactId'] ?? '38yorLxNVUZe0oE3qxGCRG2ZNoD3',
    );
  }
}
