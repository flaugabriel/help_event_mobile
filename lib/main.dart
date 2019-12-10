import 'package:flutter/material.dart';
import 'package:help_event_mobile/models/user_model.dart';
import 'package:help_event_mobile/screens/home_screen.dart';
import 'package:help_event_mobile/screens/login_screen.dart';
import 'package:help_event_mobile/screens/main_screen.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  final _pageController = PageController();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child:MaterialApp(
      title: 'HelpEvent',
      theme: ThemeData(
        primaryColor: Color.fromRGBO(251, 173, 59, 1)
        // primaryColor: Color.fromRGBO(0, 0, 155, 182)

      ),
      home: MainScreen(),
      // home:
      debugShowCheckedModeBanner: false,
    ),
    );
  }
}