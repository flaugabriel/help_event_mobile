import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

class UserModel extends Model {
  Map<String, dynamic> useData = Map();

  bool isLoading = false;

  void signUp(
      {@required Map<String, dynamic> userData,
      @required String email,
      @required String pass, @required String pass_confirme,
      @required String name,
      @required VoidCallback onSuccess,
      @required VoidCallback onFaill}) async {    isLoading = true;
    notifyListeners();


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
    notifyListeners();
  }

  void signIn(
      {@required Map<String, dynamic> userData,
      @required String pass,
      @required VoidCallback onSuccess(),
      @required VoidCallback onFaill}) async {

    isLoading = true;
    notifyListeners();

    var url = "http://helpevent.herokuapp.com/api/v1/auth/sign_in";

    var header = {"Context-type": "application/json"};

    Map params = {"email": userData["email"], "password": pass};

    var response = await http.post(url, headers: header, body: params);

    Map mapResponse = json.decode(response.body);

    if (response.statusCode != '200') {
      onSuccess();
    } else {
      String mensage = mapResponse["errors"];
      print("message $mensage");
      onFaill();
    }
    isLoading = false;
    notifyListeners();
  }

  void recoverPass() {}

  bool isLoggedIn() {
  }
}
