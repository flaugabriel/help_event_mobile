import 'package:flutter/material.dart';
import 'package:help_event_mobile/screens/login_screen.dart';
import 'package:help_event_mobile/tabs/home_tab.dart';
import 'package:help_event_mobile/widgets/custom_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pageController = PageController();

  SharedPreferences sharedPreferences;
  @override
  void initState(){
    super.initState();
    checkLoginStatus();

  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.getString("access-token") == null) {
            Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
            (Route<dynamic> route) => false);

    }
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      children: <Widget>[
        Scaffold(
          body: HomeTab(),
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Produtos"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),
        ),
        Container(color: Colors.orange)
      ],
    );

  }
}