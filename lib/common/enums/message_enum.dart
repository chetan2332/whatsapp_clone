enum MessageEnum {
  text('text'),
  audio('audio'),
  image('image'),
  video('video'),
  gif('gif');

  //Enhanced Enums
  const MessageEnum(this.type);
  final String type;
}

// using an extension
extension ConvertMessage on String {
  MessageEnum toEnum() {
    switch (this) {
      case 'audio':
        return MessageEnum.audio;
      case 'text':
        return MessageEnum.text;
      case 'video':
        return MessageEnum.video;
      case 'gif':
        return MessageEnum.gif;
      case 'image':
        return MessageEnum.image;
      default:
        return MessageEnum.text;
    }
  }
}
