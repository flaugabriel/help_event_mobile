import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:help_event_mobile/model/item_model.dart';
import 'package:help_event_mobile/screens/login_screen.dart';
import 'package:help_event_mobile/widgets/custom_drawer.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ItemsScreen extends StatefulWidget {
  @override
  _ItemsScreenState createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  bool _isLoading = false;

  SharedPreferences sharedPreferences;

  var jsonData;
  ItemModel itemModel;

  @override
  void initState() {
    super.initState();
    getItems();
  }

  @override
  Widget build(BuildContext context) {
    return
      Stack(
        children: <Widget>[
          Scaffold(
            backgroundColor: Colors.orange,
            appBar: new AppBar(
              backgroundColor: Colors.transparent,
              iconTheme: new IconThemeData(color: Colors.white,
                  size: 100.0),
              elevation: 0.0,
            ),
            body: PageView(children: <Widget>[
              Scaffold(
                backgroundColor: Colors.white10,
                body: itemModel == null
                    ? Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.white70),
                  ),
                )
                    : GridView.count(
                  crossAxisCount: 1,
                  childAspectRatio: 15 / 4,
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  children: itemModel.item
                      .map((Item item) => GestureDetector(
                    onTap: () {},
                    child: Card(
                      margin:
                      EdgeInsets.only(left: 20, right: 20, top: 5),
                      color: Color.fromRGBO(0, 155, 182, 1),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 7,
                            child: Padding(
                              padding:
                              EdgeInsets.only(bottom: 15, left: 5),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    item.description,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 21),
                                  ),
                                  Text(
                                    item.location,
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
                              padding:
                              EdgeInsets.only(bottom: 15, top: 40),
                              color: Colors.white,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Text(
                                    "R\$ ${item.value}",
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 24),
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
            ]),
            drawer: CustomDrawer(),
          ),
        ],
      );
  }

  getItems() async {
    var sharedPreferences = await SharedPreferences.getInstance();

    Map<String, String> headers = {
      "access-token": "${sharedPreferences.getString("token")}",
      "uid": "${sharedPreferences.getString("uid")}",
      "client": "${sharedPreferences.getString("client")}"
    };
    final response = await http.get(
        "http://helpevent.gabrielflauzino.com.br/api/v1/items",
        headers: headers);
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      itemModel = ItemModel.fromJson(jsonData);
      setState(() {});
    } else {
      print("não carregou os itens: ${response.body}");
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

      var response = await http.post(url,body: params);

      if (response.statusCode == 200) {
        setState(() {
          _isLoading = false;
          sharedPreferences.setString("token", (response.headers['access-token']));
          sharedPreferences.setString("client", (response.headers['client']));
          sharedPreferences.setString("uid", (response.headers['uid']));
          sharedPreferences.setString("passsword", ( sharedPreferences.getString("password")));
          sharedPreferences.setString("email", ( sharedPreferences.getString("email")));
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => ItemsScreen()),
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
