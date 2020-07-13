import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:help_event_mobile/futures/api/event_item_api.dart';
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
  EventItemApi eventItemApi = EventItemApi();
  var jsonData;
  EventItemModel eventItemModel = new EventItemModel();

  @override
  void initState() {
    eventItemApi.getItems(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.description),
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
          backgroundColor: Colors.grey,
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: "Lista",
                icon: Icon(Icons.playlist_add_check),
              ),
              Tab(
                text: "Novo item",
                icon: Icon(Icons.add),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Scaffold(
              body: eventItemModel.event_item == null
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            Colors.lightBlueAccent),
                      ),
                    )
                  : ListView.separated(
                      itemCount: eventItemModel.event_item == null
                          ? 0
                          : eventItemModel.event_item.length,
                      separatorBuilder: (context, int index) => Divider(),
                      itemBuilder: (context, int index) {
                        return new Dismissible(
                            key: new Key(
                                eventItemModel.event_item[index].description),
                            onDismissed: (direction) {
                              eventItemModel.event_item.removeAt(index);
//                              removeItem(  eventItemModel.event_item[index].id.toString());
                              Scaffold.of(context).showSnackBar(new SnackBar(
                                  content: new Text("Item removido...")));
                            },
                            background: new Container(color: Colors.red),
                              child: new ListTile(
                                leading: eventItemModel.event_item[index].status
                                    .toString() ==
                                    'false'
                                    ? Icon(Icons.block)
                                    : Icon(Icons.favorite_border),
                                title: new Text(
                                    eventItemModel.event_item[index].description),
                                subtitle: Text("Adicionado por " +
                                    eventItemModel.event_item[index].user),
                                isThreeLine: true,
                                dense: true,
                                onTap: () {
                                  opendialog();
                                },
                                trailing: Text(
                                  "R\$ " + eventItemModel.event_item[index].value,
                                  style: TextStyle(color: Colors.lightGreen),
                                ),

                              ),
                          );
                      }),
            ),
            Center(child: Text("asdfasdf"),)
          ],
        ),
      ),
    );
  }



  removeItem(id) async {
    var sharedPreferences = await SharedPreferences.getInstance();

    Map<String, String> headers = {
      "access-token": "${sharedPreferences.getString("token")}",
      "uid": "${sharedPreferences.getString("uid")}",
      "client": "${sharedPreferences.getString("client")}"
    };
    final response = await http.delete(
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

  opendialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Voçê comprou este item?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Sim"),
              ),
              FlatButton(
                child: Text("Não"),
              ),
            ],
          );
        });
  }
}
