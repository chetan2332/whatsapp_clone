import 'package:flutter/material.dart';
import 'package:whatsapp/features/auth/screens/login_screen.dart';
import 'package:whatsapp/features/auth/screens/user_information_screen.dart';
import 'package:whatsapp/features/select_contacts/screens/select_contact_screen.dart';
import 'package:whatsapp/responsive/responsive_layout.dart';
import 'package:whatsapp/features/chat/screens/mobile_chat_screen.dart';
import 'package:whatsapp/screens/mobile_layout_screen.dart';
import 'package:whatsapp/screens/web_layout_screen.dart';

import './common/widgets/error.dart';
import 'features/auth/screens/otp_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case ResponsiveLayout.routeName:
      return MaterialPageRoute(
        builder: (context) => const ResponsiveLayout(
          mobileScreenLayout: MobileLayoutScreen(),
          webScreenLayout: WebLayoutScreen(),
        ),
      );
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    case SelectContactScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SelectContactScreen(),
      );
    case MobileChatScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final name = arguments['name'];
      final uid = arguments['uid'];
      return MaterialPageRoute(
        builder: (context) => MobileChatScreen(name: name, uid: uid),
      );
    case OTPScreen.routeName:
      return MaterialPageRoute(
        builder: (context) {
          final verificationId = settings.arguments as String;
          return OTPScreen(verificationId: verificationId);
        },
      );
    case UserInformationScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const UserInformationScreen(),
      );
    default:
      return MaterialPageRoute(
        builder: (context) =>
            const ErrorScreen(error: 'This page doesn\'t exist'),
      );
  }
}
