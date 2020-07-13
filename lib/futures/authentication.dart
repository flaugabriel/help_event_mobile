import 'dart:async';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  String url = 'http://192.168.100.8:8000';

  final Dio dio = new Dio();
  bool res = false;

  SharedPreferences sharedPreferences;


  Future signIn(String email, String password) async {

    sharedPreferences = await SharedPreferences.getInstance();
    Map data = {'email': email, 'password': password};

    try {
      var response = await dio.post(url+"/api/v1/auth/sign_in",data: data,options: Options(headers: {"requiresToken" : true}));
      sharedPreferences.setString("token", (response.headers['access-token'][0].toString()));
      sharedPreferences.setString("client", (response.headers['client'][0].toString()));
      sharedPreferences.setString("uid",(response.headers['uid'][0]).toString());
      sharedPreferences.setString("password", (password));
      sharedPreferences.setString("email", (email));
      res = true;
    } on DioError catch (e){
      res = false;
    }
    return res;
  }

  Future<bool> signOut() async {

    if(sharedPreferences == null){
      res = false;
    }else {
      Map<String, String> headers = {
        "access-token": "${sharedPreferences.getString("token")}",
        "uid": "${sharedPreferences.getString("uid")}",
        "client": "${sharedPreferences.getString("client")}"
      };
      print(headers);
      try {
        var response = await dio.post(
            "$url/api/v1/auth/sign_out", options: Options(headers: headers));
        sharedPreferences.getString("token") == null;
        sharedPreferences.getString("client") == null;
        sharedPreferences.getString("uid") == null;
      } on DioError catch (e) {
      }
    }
    return res;
  }

  Future<bool> isLoged() async {
    print("islogeed");
    if(sharedPreferences == null) {
      res = true;
    }else if (sharedPreferences.getString("token") == null) {
      res = true;
    } else {
      res = false;
    }
    return res;
  }
}
