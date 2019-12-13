import 'package:flutter/material.dart';
import 'package:help_event_mobile/screens/home_screen.dart';
import 'package:help_event_mobile/screens/login_screen.dart';
import 'package:help_event_mobile/widgets/custom_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HelpEvent',
      theme: ThemeData(
        primaryColor: Color.fromRGBO(251, 173, 59, 1)
        // primaryColor: Color.fromRGBO(0, 0, 155, 182)

      ),
      home: MainPage(),
      // home:
      debugShowCheckedModeBanner: false,
    );
  }
}


class MainPage extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainPage> {

  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    print(sharedPreferences.getString("token"));
    print(sharedPreferences.getString("client"));
    print(sharedPreferences.getString("uid"));
    if(sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginScreen()), (Route<dynamic> route) => false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
            home: HomeScreen(),
    );
  }
}
