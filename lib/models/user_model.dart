import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class UserModel {
  Map<String, dynamic> useData = Map();

  bool isLoading = false;

  void signUp(
      {@required Map<String, dynamic> userData,
      @required String email,
      @required String pass, @required String pass_confirme,
      @required String name,
      @required VoidCallback onSuccess,
      @required VoidCallback onFaill}) async {    isLoading = true;


    var url = "http://helpevent.herokuapp.com/api/v1/auth";

    Map params ={
      "name": name,
      "email": email,
      "password": pass,
      "password_confirmation": pass_confirme,
    };

    var response = await http.post(url, body: params);

    Map mapResponse = json.decode(response.body);
      print("foi ?? ${response.statusCode}");
    print(response.body);

  if (response.statusCode == '200') {
      print("foi ?? ${response.body}");
      onSuccess();
    } else {
      String mensage = mapResponse["full_messages"];
      print("message $mensage");
      onFaill();
    }
    isLoading = false;
  }

  void signIn(
      {@required Map<String, dynamic> userData,
      @required String pass,
      @required VoidCallback onSuccess(),
      @required VoidCallback onFaill}) async {

    isLoading = true;

   
    isLoading = false;
  }
}
