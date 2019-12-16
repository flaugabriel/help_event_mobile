import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:help_event_mobile/model/event_model.dart';
import 'package:help_event_mobile/widgets/custom_drawer.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
          backgroundColor: Colors.orange,
          body: eventModel == null
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(Colors.white70),
                  ),
                )
              : GridView.count(
                  crossAxisCount: 1,
                  padding: EdgeInsets.all(10.0),
                  childAspectRatio: 8/5,
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  children: eventModel.event
                      .map(
                        (Event event) => Padding(
                          padding:
                              EdgeInsets.only(bottom: 250, right: 25, left: 25),
                          child: Card(
                            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    title: Text(
                                      event.description,
                                      style: TextStyle(fontSize: 24),
                                    ),
                                    subtitle: Text(
                                        'Criado por ${event.user} em ${event.created_at}'),
                                  ),
                                ]),
                          ),
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
      "Content-type": "application/json",
      "access-token": "${sharedPreferences.getString("token")}",
      "uid": "${sharedPreferences.getString("uid")}",
      "client": "${sharedPreferences.getString("client")}"
    };
    final response = await http.get(
        "http://helpevent.gabrielflauzino.com.br/api/v1/",
        headers: headers);
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      print(jsonData[0]);
      eventModel = EventModel.fromJson(jsonData);
      setState(() {});
    } else {
      print("não carregou os itens: ${response.body}");
    }
  }
}
