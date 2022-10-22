import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/common/utils/colors.dart';
import 'package:whatsapp/common/utils/utils.dart';
import 'package:whatsapp/common/widgets/custom_button.dart';
import 'package:country_picker/country_picker.dart';
import 'package:whatsapp/features/auth/controller/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login-screen';
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phoneNoController = TextEditingController();
  Country? _country;

  @override
  void dispose() {
    phoneNoController.dispose();
    super.dispose();
  }

  void pickCountry() {
    showCountryPicker(
        context: context,
        onSelect: (Country country) {
          setState(() {
            _country = country;
          });
        });
  }

  void sendPhoneNumber() {
    String phoneNumber = phoneNoController.text.trim();
    if (_country != null && phoneNumber.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .signInWithPhone(context, '+${_country!.phoneCode}$phoneNumber');
    } else {
      showSnackBar(context: context, content: 'Fill out all the fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Your Phone Number'),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Expanded(
          child: Column(children: [
            const Text('Whatsapp will need to verify your phone no.'),
            const SizedBox(
              height: 10,
            ),
            TextButton(
                onPressed: pickCountry, child: const Text('Pick Country')),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                if (_country != null) Text('+${_country!.phoneCode}'),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: size.width * 0.7,
                  child: TextField(
                    controller: phoneNoController,
                    decoration:
                        const InputDecoration(hintText: 'Enter Phone Number'),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 90,
                child: CustomButton(text: 'NEXT', onPressed: sendPhoneNumber),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
