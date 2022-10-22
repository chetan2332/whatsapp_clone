import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  static const routeName = '/reponsive-layout-screen';
  final Widget mobileScreenLayout;
  final Widget webScreenLayout;
  const ResponsiveLayout(
      {super.key,
      required this.mobileScreenLayout,
      required this.webScreenLayout});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 900) {
        // web screen
        return webScreenLayout;
      }
      // mobile screen
      return mobileScreenLayout;
    });
  }
}
