import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:help_event_mobile/model/event_model.dart';
import 'package:help_event_mobile/tabs/home_tab.dart';
import 'package:help_event_mobile/tabs/items_tab.dart';
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
  final _pageController = PageController();

  @override
  void initState() {

    super.initState();
    getItems();
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
          body: ItemsTab(),
          drawer: CustomDrawer(_pageController),
        ),
        Container(
          color: Colors.orange,
          child: Scaffold(

            body: eventModel == null
                ?

                Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.white70),

                  )
                )
                : GridView.count(crossAxisCount: 2,
            scrollDirection: Axis.vertical,
            physics: BouncingScrollPhysics(),
            children: eventModel.event.map((Event event) => Padding(
              padding: EdgeInsets.all(5.0),
              child: Card(
                elevation: 0.0,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    InkWell(
                      customBorder: CircleBorder(),
                      splashColor: Colors.brown[300],
                      onTap: () {
//                        Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                                builder: (BuildContext context) =>
//                                    ));
                      },
//                      child: Hero(
//                        tag: pokemon.img,
//                        child: Image(
//                          filterQuality: FilterQuality.high,
//                          fit: BoxFit.contain,
//                          image: NetworkImage(pokemon.img),
//                        ),
//                      ),
                    ),
                    Text(event.description,
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            )).toList()
            )
          ),
        )
      ],
    );
  }

  getItems() async {
    var sharedPreferences = await SharedPreferences.getInstance();

    Map<String, String> headers = {"Content-type": "application/json", "access-token": "${sharedPreferences.getString("token")}","uid": "${sharedPreferences.getString("uid")}" ,"client": "${sharedPreferences.getString("client")}"};
    final response = await http.get(
        "http://helpevent.gabrielflauzino.com.br/api/v1/",headers: headers);
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      print(jsonData[0]);
      eventModel = EventModel.fromJson(jsonData[0]);
      setState(() {});
    }else{
      print("não carregou os itens: ${response.body}");
    }
  }
}

