import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:help_event_mobile/model/item_model.dart';
import 'package:help_event_mobile/screens/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ItemsScreen extends StatefulWidget {
  @override
  _ItemsScreenState createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  var jsonData;
  ItemModel itemModel;

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
        body: itemModel == null
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.white70),
                ),
              )
            : GridView.count(
                crossAxisCount: 1,
                childAspectRatio: 12 / 4,
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                children: itemModel.item
                    .map(
                      (Item item) => Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                              bottomLeft: Radius.circular(50),
                              bottomRight: Radius.circular(50)),
                        ),
                        color: Color.fromRGBO(0, 155, 182, 1),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 7,
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 15.0, left: 20),
                                        child: Text(
                                          item.description,
                                          style: TextStyle(
                                              fontSize: 21,
                                              color: Colors.white),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 10.0, left: 20),
                                        child: Text(
                                          item.location,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white),
                                        ),
                                      )
                                    ]),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                padding: EdgeInsets.only(top: 80),
                                color: Colors.white,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Text(
                                      "R\$ ${item.value}",
                                      style: TextStyle(
                                          color: Colors.green, fontSize: 24),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
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
      "access-token": "${sharedPreferences.getString("token")}",
      "uid": "${sharedPreferences.getString("uid")}",
      "client": "${sharedPreferences.getString("client")}"
    };
    print(headers);
    final response = await http.get(
        "http://helpevent.gabrielflauzino.com.br/api/v1/items",
        headers: headers);
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      itemModel = ItemModel.fromJson(jsonData);
      setState(() {});
    } else {
      print("não carregou os itens: ${response.body}");
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
          (Route<dynamic> route) => false);
    }
  }
}
