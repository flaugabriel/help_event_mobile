import 'package:flutter/material.dart';
import 'package:help_event_mobile/screens/home_screen.dart';
import 'package:help_event_mobile/screens/login_screen.dart';
import 'package:help_event_mobile/tabs/home_tab.dart';
import 'package:help_event_mobile/widgets/custom_drawer.dart';

class MainScreen extends StatelessWidget {

  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        MaterialApp(home:  LoginScreen()
      )
      ],
    );
  }
}