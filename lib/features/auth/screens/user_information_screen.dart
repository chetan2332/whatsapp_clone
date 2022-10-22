import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/common/utils/utils.dart';
import 'package:whatsapp/features/auth/controller/auth_controller.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
  static const routeName = '/user-information';
  const UserInformationScreen({super.key});

  @override
  ConsumerState<UserInformationScreen> createState() =>
      _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  final nameController = TextEditingController();
  File? image;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void saveUserData() async {
    String name = nameController.text.trim();
    if (name.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .saveUserDataToFirebase(context, name, image);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: image == null
                    ? const CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(
                            'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png'),
                      )
                    : CircleAvatar(
                        radius: 60,
                        backgroundImage: FileImage(image!),
                      ),
              ),
              Positioned(
                  bottom: 5,
                  right: 5,
                  child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(Icons.add_a_photo)))
            ],
          ),
          Row(
            children: [
              Container(
                width: size.width * 0.85,
                padding: const EdgeInsets.all(20),
                child: TextField(
                  controller: nameController,
                  decoration:
                      const InputDecoration(hintText: 'Enter Your Name'),
                ),
              ),
              IconButton(
                onPressed: saveUserData,
                icon: const Icon(Icons.done),
              )
            ],
          )
        ]),
      )),
    );
  }
}
