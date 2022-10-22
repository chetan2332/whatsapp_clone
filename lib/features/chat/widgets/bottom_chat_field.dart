import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/common/utils/colors.dart';
import 'package:whatsapp/features/chat/controller/chat_controller.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String recieverId;
  const BottomChatField({
    Key? key,
    required this.recieverId,
  }) : super(key: key);

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  var isShowSendButton = false;

  final _messageController = TextEditingController();

  void sendTextMessage() {
    if (isShowSendButton) {
      ref.read(chatControllerProvider).sendTextMessage(
          context, _messageController.text.trim(), widget.recieverId);
    }
    _messageController.text = '';
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _messageController,
            onChanged: ((value) {
              if (value.isNotEmpty) {
                setState(() {
                  isShowSendButton = true;
                });
              } else {
                setState(() {
                  isShowSendButton = false;
                });
              }
            }),
            decoration: InputDecoration(
              hintText: 'Type a message!',
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: mobileChatBoxColor,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 6),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.emoji_emotions,
                    color: Colors.grey,
                  ),
                ),
              ),
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: 5),
                child: SizedBox(
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        splashRadius: 15,
                        onPressed: () {},
                        icon: const Icon(
                          Icons.camera_alt,
                          color: Colors.grey,
                        ),
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.attach_file,
                            color: Colors.grey,
                          )),
                      // Spacer()
                    ],
                  ),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              contentPadding: const EdgeInsets.all(10),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(2, 0, 2, 8),
          child: CircleAvatar(
            backgroundColor: const Color(0xFF128C7E),
            radius: 25,
            child: GestureDetector(
              onTap: isShowSendButton ? sendTextMessage : null,
              child: Icon(
                isShowSendButton ? Icons.send : Icons.mic,
                size: 25,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
