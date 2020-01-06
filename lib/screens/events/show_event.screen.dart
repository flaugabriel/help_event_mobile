import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:help_event_mobile/model/event_item_model.dart';
import 'package:help_event_mobile/model/item_model.dart';
import 'package:help_event_mobile/screens/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

enum OrderOptions { atualizar }

class ShowEventScreen extends StatefulWidget {
  int id;
  String description;
  String created_at;
  String user;
  String total;

  ShowEventScreen(
      {this.id, this.created_at, this.description, this.user, this.total});

  @override
  _ShowEventScreenState createState() => _ShowEventScreenState();
}

class _ShowEventScreenState extends State<ShowEventScreen> {
  bool _isLoading = false;

  var jsonData;
  EventItemModel eventItemModel;

  @override
  void initState() {
    getItems(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text("Atualizar"),
                value: OrderOptions.atualizar,
              ),
            ],
            onSelected: _updateList,
          ),
        ],
        backgroundColor: Color.fromRGBO(0, 155, 182, 1),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                child: IconButton(
                  onPressed: showMenu,
                  icon: Icon(Icons.add),
                  color: Colors.black,
                  tooltip: "Adicionar item",
                ),
              ),
            ]),
      ),
      body: Scaffold(
        backgroundColor: Color.fromRGBO(251, 173, 59, 1),
        body: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            Positioned(
              child: Text(
                widget.description,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              top: 30,
              width: 350,
            ),
            Positioned(
              child: Text(
                "Criado em ${widget.created_at} por ${widget.user}",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              top: 60,
              width: 350,
            ),
            PageView(children: <Widget>[
              Scaffold(
                backgroundColor: Colors.orange,
                body: eventItemModel == null
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.white70),
                        ),
                      )
                    : GridView.count(
                        crossAxisCount: 1,
                        childAspectRatio: 15 / 4,
                        scrollDirection: Axis.vertical,
                        physics: BouncingScrollPhysics(),
                        children: eventItemModel.event_item
                            .map((EventItem eventItem) => GestureDetector(
                                  onTap: () {},
                                  child: Card(
                                    margin: EdgeInsets.only(
                                        left: 20, right: 20, top: 5),
                                    color: Color.fromRGBO(0, 155, 182, 1),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 4,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                bottom: 15, left: 5),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  eventItem.description,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 21),
                                                ),
                                                Text(
                                                  eventItem.location,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            padding: EdgeInsets.only(
                                                bottom: 20, top: 40),
                                            color: Colors.white,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: <Widget>[
                                                Text(
                                                  "R\$ ${eventItem.value}",
                                                  style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 24),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Container(
                                            color: Colors.transparent,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: <Widget>[
                                                Center(
                                                  child: RaisedButton.icon(
                                                    color: Colors.white,
                                                    onPressed: () {},
                                                    textColor: Colors.green,
                                                    icon: Icon(
                                                      Icons.check_circle,
                                                    ),
                                                    label: Text("Comprado!"),
                                                  ),
                                                ),
                                                Center(
                                                  child: RaisedButton.icon(
                                                    color: Colors.red,
                                                    onPressed: () {},
                                                    textColor: Colors.white,
                                                    icon: Icon(
                                                      Icons.delete,
                                                    ),
                                                    label: Text("Remover!"),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                        // COlumn 2 End
                                      ],
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
              ),
            ])
          ],
        ),
      ),
    );
  }

  getItems(id) async {
    var sharedPreferences = await SharedPreferences.getInstance();

    Map<String, String> headers = {
      "access-token": "${sharedPreferences.getString("token")}",
      "uid": "${sharedPreferences.getString("uid")}",
      "client": "${sharedPreferences.getString("client")}"
    };
    final response = await http.get(
        "http://helpevent.gabrielflauzino.com.br/api/v1/events/${id}",
        headers: headers);
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      eventItemModel = EventItemModel.fromJson(jsonData);
      setState(() {});
    } else {
      checkLoginStatus();
    }
  }

  removeItem(id) async {
    var sharedPreferences = await SharedPreferences.getInstance();

    Map<String, String> headers = {
      "access-token": "${sharedPreferences.getString("token")}",
      "uid": "${sharedPreferences.getString("uid")}",
      "client": "${sharedPreferences.getString("client")}"
    };
    final response = await http.get(
        "http://helpevent.gabrielflauzino.com.br/api/v1/events/${id}",
        headers: headers);
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      eventItemModel = EventItemModel.fromJson(jsonData);
      setState(() {});
    } else {
      checkLoginStatus();
    }
  }

  checkLoginStatus() async {
    var sharedPreferences = await SharedPreferences.getInstance();

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
        });
      } else {
        setState(() {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => LoginScreen()),
              (Route<dynamic> route) => false);
        });
      }
    }
  }

  void _updateList(OrderOptions result) {
    setState(() {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ShowEventScreen(
            id: widget.id,
            description: widget.description,
            total: widget.total,
            user: widget.user,
            created_at: widget.created_at),
      ));
    });
  }

  showMenu() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50.0),
                topRight: Radius.circular(50.0),
              ),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50.0),
                      topRight: Radius.circular(50.0),
                    ),
                    color: Colors.white,
                  ),
                  height: 36,
                ),
                SizedBox(
                    height: (56 * 6).toDouble(),
                    child: Container(
                        child: Stack(
                      alignment: Alignment(0, 0),
                      overflow: Overflow.visible,
                      children: <Widget>[
                        Positioned(
                          top: -36,
                          child: Container(
                            child: Center(
                              child: Text(
                                "Novo item",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 24),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          child: ListView(
                            physics: NeverScrollableScrollPhysics(),
                            children: <Widget>[
                              ListTile(
                                title: Text(
                                  "YRsdfgsd sd",
                                  style: TextStyle(color: Colors.black, fontSize:18 ),
                                ),
                                trailing: Icon(Icons.add),
                                onTap: () {},
                              ),
                            ],
                          ),
                        )
                      ],
                    ))),
              ],
            ),
          );
        });
  }
}
