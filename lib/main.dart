import 'package:flutter/material.dart';
import 'package:help_event_mobile/screens/home_screen.dart';
import 'package:help_event_mobile/screens/login_screen.dart';
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
  bool _isLoading = false;

  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();

    if(sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginScreen()), (Route<dynamic> route) => false);
    }else{
      var sharedPreferences = await SharedPreferences.getInstance();

      var url = "http://helpevent.gabrielflauzino.com.br/api/v1/auth/sign_in";
      var header = {"Context-type": "application/json"};

      Map params = {"email": sharedPreferences.getString("email"), "password": sharedPreferences.getString("password")};

      var response = await http.post(url, headers: header, body: params);

      if (response.statusCode == 200) {
        print("LOGADO!");

        setState(() {
          _isLoading = false;
          sharedPreferences.setString("token", (response.headers['access-token']));
          sharedPreferences.setString("client", (response.headers['client']));
          sharedPreferences.setString("uid", (response.headers['uid']));
          sharedPreferences.setString("passsword", ( sharedPreferences.getString("password")));
          sharedPreferences.setString("email", ( sharedPreferences.getString("email")));
        });
      } else {
        print("IVALIDO!");

        setState(() {
          _isLoading = false;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
            home: HomeScreen(),
    );
  }
}
