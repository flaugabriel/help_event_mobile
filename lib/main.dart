import 'package:flutter/material.dart';
import 'package:help_event_mobile/futures/authentication.dart';
import 'package:help_event_mobile/screens/home_screen.dart';
import 'package:help_event_mobile/screens/login_screen.dart';
import 'package:help_event_mobile/widgets/custom_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'HelpEvent',
      theme: ThemeData(
        // primaryColor: Color.fromRGBO(0, 0, 155, 182)
      ),
      home: LoginScreen(),
    );
  }
}


class MainPage extends StatefulWidget {

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    veriricautenticidade();
  }

  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          backgroundColor: Colors.grey,
          appBar: new AppBar(
            backgroundColor: Colors.transparent,
            iconTheme: new IconThemeData(color: Colors.white,
            size: 100.0),
            elevation: 0.0,
          ),
          body: HomeScreen(),
          drawer: CustomDrawer(),
        ),
      ],
    );
  }

  veriricautenticidade() async{
    SharedPreferences sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    print("autenticidade?");
    print(sharedPreferences.getString("token"));
  }
}
