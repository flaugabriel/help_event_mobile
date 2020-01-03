import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:help_event_mobile/main.dart';
import 'package:help_event_mobile/model/event_model.dart';
import 'package:help_event_mobile/screens/events/show_event.screen.dart';
import 'package:help_event_mobile/screens/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool _isLoading = false;

  SharedPreferences sharedPreferences;

  var jsonData;
  EventModel eventModel;

  @override
  void initState() {
    super.initState();
    getItems();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(children: <Widget>[
      Scaffold(
          backgroundColor: Color.fromRGBO(251, 173, 59, 1),
          body: eventModel == null
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(Colors.white70),
                  ),
                )
              : GridView.count(
                  crossAxisCount: 1,
                  childAspectRatio: 12/6,
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  children: eventModel.event
                      .map(
                        (Event event) => Card(

                            margin: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                            child: new InkWell(
                              onTap: (){
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    
                                    builder: (context)=>ShowEventScreen(
                                      user: event.user,
                                      description: event.description,
                                      total: event.total,
                                      created_at: event.created_at,
                                      id: event.id,)
                                    )
                                );
                              },
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      title: Text(
                                        event.description,
                                        style: TextStyle(fontSize: 24),
                                      ),
                                      subtitle: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                              'Criado por ${event.user} em ${event.created_at}'),
                                          Divider(
                                            color: Colors.transparent,
                                          ),
                                          Text(
                                            '6 items já adicionado',)
                                        ],

                                      ),

                                      trailing: Text("R\$ ${event.total}",style: TextStyle(fontSize: 18.0,color: Colors.green),),


                                    ),
                                  ]
                              ),
                            )
                          ),
                      )
                      .toList(),
                ),
        ),
    ]);
  }

  getItems() async {
    var sharedPreferences = await SharedPreferences.getInstance();

    Map<String, String> headers = {
      "access-token": "${sharedPreferences.getString("token")}",
      "uid": "${sharedPreferences.getString("uid")}",
      "client": "${sharedPreferences.getString("client")}"
    };
    final response = await http.get(
        "http://helpevent.gabrielflauzino.com.br/api/v1/",
        headers: headers);
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      eventModel = EventModel.fromJson(jsonData);
      setState(() {});
    } else {
      checkLoginStatus();
    }
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();

    if(sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginScreen()), (Route<dynamic> route) => false);
    }else{
      var sharedPreferences = await SharedPreferences.getInstance();

      var url = "http://helpevent.gabrielflauzino.com.br/api/v1/auth/sign_in";
      Map params = {"email": sharedPreferences.getString("email"), "password": sharedPreferences.getString("password")};

      var response = await http.post(url, body: params);

      if (response.statusCode == 200) {
        setState(() {
          _isLoading = false;
          sharedPreferences.setString("token", (response.headers['access-token']));
          sharedPreferences.setString("client", (response.headers['client']));
          sharedPreferences.setString("uid", (response.headers['uid']));
          sharedPreferences.setString("passsword", ( sharedPreferences.getString("password")));
          sharedPreferences.setString("email", ( sharedPreferences.getString("email")));
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => MainPage()),
                  (Route<dynamic> route) => false);
        });
      } else {
        setState(() {
          _isLoading = false;
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
                  (Route<dynamic> route) => false);
        });
      }
    }
  }
}
