import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:help_event_mobile/screens/items_screen.dart';
import 'package:help_event_mobile/widgets/custom_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class NewItemScreen extends StatefulWidget {
  @override
  _NewItemScreenState createState() => _NewItemScreenState();
}

class _NewItemScreenState extends State<NewItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _valueController = TextEditingController();
  final _locationController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    SharedPreferences sharedPreferences;

    return Stack(
      children: <Widget>[
        Scaffold(
          backgroundColor: Color.fromRGBO(251, 173, 59, 1),
          appBar: new AppBar(
            backgroundColor: Colors.transparent,
            iconTheme: new IconThemeData(color: Colors.white, size: 100.0),
            elevation: 0.0,
          ),
          drawer: CustomDrawer(),
          body: Scaffold(
            backgroundColor: Color.fromRGBO(251, 173, 59, 1),
            body: Container(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          left: 20, top: 0, bottom: 10, right: 20),
                      child: TextFormField(
                        controller: _descriptionController,
                        validator: (text) {
                          if (text.isEmpty) return "Descrição não inserida!";
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: InputBorder.none,
                          hintText: "Descrição",
                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 8.0, top: 8.0),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.7),
                              borderSide: BorderSide(color: Colors.white)),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(25.7),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 20, top: 16, bottom: 10, right: 20),
                      child: TextFormField(
                        controller: _valueController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: InputBorder.none,
                          hintText: "Preço",
                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 8.0, top: 8.0),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.7),
                              borderSide: BorderSide(color: Colors.white)),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(25.7),
                          ),
                        ),
                        validator: (text) {
                          if (text.isEmpty) return "Valor não inserido!";
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 20, top: 16, bottom: 10, right: 20),
                      child: TextFormField(
                        controller: _locationController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: InputBorder.none,
                          hintText: "Local",
                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 8.0, top: 8.0),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.7),
                              borderSide: BorderSide(color: Colors.white)),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(25.7),
                          ),
                        ),
                      ),
                    ),
                    FlatButton(
                      padding: EdgeInsets.only(
                          left: 20, top: 16, bottom: 10, right: 20),
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                                BorderRadius.all(Radius.circular(32))),
                        child: Center(
                          child: Text(
                            "Criar",
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            _isLoading = true;
                          });
                          createItem(_descriptionController.text,
                              _valueController.text, _locationController.text);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  createItem(String description, String value, String location) async {

    var sharedPreferences = await SharedPreferences.getInstance();
    var url = "http://helpevent.gabrielflauzino.com.br/api/v1/items";

    Map<String, String> headers = {
      "Context-type": "application/json",
      "Accept": "application/json",
      "access-token": "${sharedPreferences.getString("token")}",
      "uid": "${sharedPreferences.getString("uid")}",
      "client": "${sharedPreferences.getString("client")}"
    };

    Map data = {
      'item': {
        'description': "${description}",
        'value': "${value}",
        'location': "${location}"
      },
    };


    final response = await http.post(url, headers: headers, body: json.encode(data));

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
            MaterialPageRoute(builder: (BuildContext context) => ItemsScreen()),
            (Route<dynamic> route) => false);
      });

    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
