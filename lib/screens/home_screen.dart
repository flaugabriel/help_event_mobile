import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:help_event_mobile/model/item_model.dart';
import 'package:help_event_mobile/tabs/home_tab.dart';
import 'package:help_event_mobile/widgets/custom_drawer.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var jsonData;
  ItemModel itemModel;
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
        Container(
          color: Colors.orange,
          child: ListView(

          ),
        )
      ],
    );
  }

  getItems() async {
    final response = await http.get(
        "http://helpevent.gabrielflauzino.com.br/api/v1/");
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      itemModel = ItemModel.fromJson(jsonData);
      print(jsonData);
      setState(() {});
    }
  }
}

