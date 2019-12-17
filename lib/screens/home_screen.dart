import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:help_event_mobile/main.dart';
import 'package:help_event_mobile/model/event_model.dart';
import 'package:help_event_mobile/screens/login_screen.dart';
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
                  childAspectRatio: 12/6,
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  children: eventModel.event
                      .map(
                        (Event event) => Card(

                            margin: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                            child: new InkWell(
                              onTap: (){

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
      print(jsonData);
      eventModel = EventModel.fromJson(jsonData);
      setState(() {});
    } else {
      print("não carregou os itens: ${response.body}");
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
              (Route<dynamic> route) => false);
    }
  }
}
