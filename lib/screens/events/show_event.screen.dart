import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:help_event_mobile/model/event_item_model.dart';
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
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.white,
        icon: Icon(
          Icons.add,
          color: Colors.black,
        ),
        label: Text(
          "Novo item",
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
        onPressed: showMenu,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
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
                        childAspectRatio: 17 / 6,
                        scrollDirection: Axis.vertical,
                        physics: BouncingScrollPhysics(),
                        children: eventItemModel.event_item
                            .map((EventItem eventItem) => GestureDetector(
                                onTap: () {},
                                child: Container(
                                  width: 200,
                                  child: Card(
                                    elevation: 10,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    margin: EdgeInsets.only(
                                        left: 20, right: 20, top: 5),
                                    color: Colors.white,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        ListTile(
                                            leading: Text(
                                              "R\$ ${eventItem.value}",
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 24),
                                            ),
                                            title: Text(
                                              eventItem.description,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 21),
                                            ),
                                            subtitle: Text(
                                              eventItem.location,
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )),
                                        ButtonTheme(
                                          child: ButtonBar(
                                            children: <Widget>[
                                              FlatButton(
                                                onPressed: null,
                                                child: Column(
                                                  // Replace with a Row for horizontal icon + text
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.check,
                                                      color: Colors.green,
                                                    ),
                                                    Text(
                                                      "Comprado",
                                                      style: TextStyle(
                                                          color: Colors.green),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              FlatButton(
                                                onPressed: null,
                                                child: Column(
                                                  children: <Widget>[
                                                      Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                    ),
                                                    Text(
                                                      "Remove",
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )))
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
                        GridView.count(
                        crossAxisCount: 1,
                        childAspectRatio: 17 / 6,
                        scrollDirection: Axis.vertical,
                        physics: BouncingScrollPhysics(),
                        children: eventItemModel.event_item
                            .map((EventItem eventItem) => Positioned(
                                top: -36,
                           child: Container(
                             child: Center(
                              child: Text(
                                 "Novo item",
                                 style: TextStyle(
                                     color: Colors.black, fontSize: 24),
                               ),
                             ),
                           ),))
                          .toList(),
                      ),
                        // Positioned(
                        //   top: -36,
                        //   child: Container(
                        //     child: Center(
                        //       child: Text(
                        //         "Novo item",
                        //         style: TextStyle(
                        //             color: Colors.black, fontSize: 24),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // Positioned(
                        //   child: ListView(
                        //     physics: NeverScrollableScrollPhysics(),
                        //     children: <Widget>[
                        //       ListTile(
                        //         title: Text(
                        //           "YRsdfgsd sd",
                        //           style: TextStyle(
                        //               color: Colors.black, fontSize: 18),
                        //         ),
                        //         trailing: Icon(Icons.add),
                        //         onTap: () {},
                        //       ),
                        //     ],
                        //   ),
                        // )
                      ],
                    ))),
              ],
            ),
          );
        });
  }
}
