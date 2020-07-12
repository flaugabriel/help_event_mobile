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
  EventModel eventModel = new EventModel();

  @override
  void initState() {
    super.initState();
    getItems();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(children: <Widget>[
      Scaffold(
        body: eventModel == null
            ? Center(
                child: CircularProgressIndicator(
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
                ),
              )
            : new ListView.separated(
                itemCount: eventModel.event == null ? 0 : eventModel.event.length,
                separatorBuilder: (context, int index)
            => Divider(),
                itemBuilder: (context, int index) {
                  return new Dismissible(
                      key: new Key(eventModel.event[index].description),
                      onDismissed: (direction) {
                        eventModel.event.removeAt(index);
                        Scaffold.of(context).showSnackBar(new SnackBar(
                            content: new Text("Item removido...")));
                      },
                      background: new Container(color: Colors.red),
                      child: new ListTile(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ShowEventScreen(
                                  user: (eventModel.event[index].user),
                                  description:
                                      (eventModel.event[index].description),
                                  total: (eventModel.event[index].total),
                                  created_at:
                                      (eventModel.event[index].created_at),
                                  id: (eventModel.event[index].id))));
                        },
                        title: new Text(eventModel.event[index].description),
                        subtitle: new Text("Quantidade de itens "+eventModel.event[index].items.toString()),
                        isThreeLine: true,
                        trailing: Text("R\$ "+eventModel.event[index].total,style: TextStyle(color: Colors.lightGreen, fontSize: 24.0),),
                      ));
                }),
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

    if (sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
          (Route<dynamic> route) => false);
    } else {
      var sharedPreferences = await SharedPreferences.getInstance();

      var url = "http://helpevent.gabrielflauzino.com.br/api/v1/auth/sign_in";
      Map params = {
        "email": sharedPreferences.getString("email"),
        "password": sharedPreferences.getString("password")
      };

      var response = await http.post(url, body: params);

      if (response.statusCode == 200) {
        setState(() {
          _isLoading = false;
          sharedPreferences.setString(
              "token", (response.headers['access-token']));
          sharedPreferences.setString("client", (response.headers['client']));
          sharedPreferences.setString("uid", (response.headers['uid']));
          sharedPreferences.setString(
              "passsword", (sharedPreferences.getString("password")));
          sharedPreferences.setString(
              "email", (sharedPreferences.getString("email")));
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => MainPage()),
              (Route<dynamic> route) => false);
        });
      } else {
        setState(() {
          _isLoading = false;
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => LoginScreen()),
              (Route<dynamic> route) => false);
        });
      }
    }
  }
}
